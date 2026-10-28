#!/usr/bin/python3
"""NetworkManager VPN profiles. Never print imported contents or raw plugin errors.

NetworkManager owns connections/secrets; this is a short-lived client, not a
network daemon. Passwords are requested by nmcli's interactive secret agent.
"""
import ipaddress
import json
import os
from pathlib import Path
import shlex
import shutil
import socket
import stat
import subprocess
import sys
import uuid

import gi

gi.require_version("NM", "1.0")
from gi.repository import GLib, NM

OPENVPN = "org.freedesktop.NetworkManager.openvpn"
# Options handled by the official OpenVPN importer. Unknown options must not
# disappear silently (the plugin itself currently skips unknown directives).
OPENVPN_OPTIONS = set("""allow-compression allow-pull-fqdn auth auth-nocache
ncp-disable auth-user-pass ca cert cipher client comp-lzo compress connect-timeout
crl-verify data-ciphers data-ciphers-fallback dev dev-type extra-certs float
fragment group http-proxy http-proxy-retry ifconfig keepalive key keysize
key-direction max-routes mssfix mtu-disc nobind ns-cert-type persist-key persist-tun
ping ping-exit ping-restart pkcs12 port proto push-peer-info remote remote-cert-tls
remote-random remote-random-hostname reneg-sec route rport secret server-poll-timeout
socks-proxy socks-proxy-retry tls-auth tls-cipher tls-client tls-crypt tls-crypt-v2
tls-remote tls-version-min tls-version-max topology tun-ipv6 tun-mtu user
verify-x509-name""".split())
INLINE = set("ca cert extra-certs crl-verify key pkcs12 secret tls-auth tls-crypt tls-crypt-v2".split())
HOOKS = set("up down route-up route-pre-down ipchange tls-verify auth-user-pass-verify client-connect client-disconnect learn-address plugin script-security config cd chroot management".split())


class UserError(Exception):
    pass


def emit(**result):
    print(json.dumps(result), flush=True)


def protocol(connection):
    kind = connection.get_connection_type()
    if kind == "wireguard":
        return "WireGuard"
    setting = connection.get_setting_vpn()
    if kind == "vpn" and setting and setting.get_service_type() == OPENVPN:
        return "OpenVPN"
    return None


def client():
    result = NM.Client.new(None)
    if not result.get_nm_running():
        raise UserError("NetworkManager is not running.")
    return result


def profile(nm, identifier):
    result = nm.get_connection_by_uuid(identifier)
    if not result or not protocol(result):
        raise UserError("This VPN profile no longer exists. Refresh the list.")
    return result


def profiles(nm):
    active = {connection.get_uuid(): connection for connection in nm.get_active_connections()}
    rows = []
    for connection in nm.get_connections():
        kind = protocol(connection)
        if not kind:
            continue
        current = active.get(connection.get_uuid())
        state = current.get_state() if current else NM.ActiveConnectionState.DEACTIVATED
        labels = {NM.ActiveConnectionState.UNKNOWN: "Unknown", NM.ActiveConnectionState.ACTIVATING: "Connecting", NM.ActiveConnectionState.ACTIVATED: "Active", NM.ActiveConnectionState.DEACTIVATING: "Disconnecting", NM.ActiveConnectionState.DEACTIVATED: "Disconnected"}
        rows.append(dict(uuid=connection.get_uuid(), name=connection.get_id(), protocol=kind,
                         state=labels.get(state, "Unknown"), active=state == NM.ActiveConnectionState.ACTIVATED,
                         engaged=current is not None, reason=int(current.get_state_reason()) if current else 0))
    return sorted(rows, key=lambda row: row["name"].casefold())


def finish_async(start, finish):
    loop = GLib.MainLoop()
    result = []
    errors = []

    def completed(source, pending, *_):
        try:
            result.append(finish(source, pending))
        except GLib.Error:
            errors.append(True)
        loop.quit()

    start(completed)
    loop.run()
    if errors:
        raise UserError("NetworkManager refused the operation or authorization was cancelled. Check the session polkit prompt and profile permissions.")
    return result[0] if result else None


def read_config(path):
    path = Path(path).expanduser().resolve(strict=True)
    if not path.is_file() or path.stat().st_size > 4 * 1024 * 1024:
        raise UserError("Choose a regular configuration file smaller than 4 MiB.")
    return path, path.read_text(encoding="utf-8-sig")


def review_openvpn(text):
    options = []
    inline = None
    for number, line in enumerate(text.splitlines(), 1):
        line = line.strip()
        if inline:
            if line == f"</{inline}>":
                inline = None
            continue
        if not line or line.startswith(("#", ";")):
            continue
        if line.startswith("<") and line.endswith(">"):
            tag = line[1:-1]
            if tag not in INLINE:
                raise UserError(f"Unsupported OpenVPN inline section on line {number}; no profile was imported.")
            inline = tag
            continue
        try:
            args = shlex.split(line, comments=True)
        except ValueError:
            raise UserError(f"Invalid quoting on line {number}.") from None
        if not args:
            continue
        name = args[0].removeprefix("--")
        if name in HOOKS:
            raise UserError(f"Unsafe executable/include directive on line {number}. Eclipse never executes imported hooks. Remove it only after reviewing its purpose.")
        if name not in OPENVPN_OPTIONS | {"redirect-gateway", "route-nopull", "dhcp-option", "route-ipv6"}:
            raise UserError(f"Unsupported OpenVPN directive on line {number}. Use NetworkManager's manual editor to express its intent; it will not be silently dropped.")
        if name == "auth-user-pass" and len(args) > 1:
            raise UserError("A credential-file reference cannot be imported. Replace it with bare auth-user-pass; activation asks securely in a terminal.")
        if name == "topology":
            raise UserError("The OpenVPN plugin does not preserve local topology directives. Configure topology on the controlled server or express the required address setup in NetworkManager's editor.")
        if name == "redirect-gateway" and any(flag not in {"def1", "ipv6", "!ipv4"} for flag in args[1:]):
            raise UserError("Unsupported redirect-gateway flag; bypass/local policies need explicit routes in the NetworkManager editor.")
        if name == "dhcp-option" and (len(args) != 3 or args[1] not in {"DNS", "DNS6", "DOMAIN", "DOMAIN-SEARCH"}):
            raise UserError("Unsupported dhcp-option. Only DNS, DNS6, DOMAIN and DOMAIN-SEARCH are imported.")
        if name == "route-ipv6" and not 2 <= len(args) <= 4:
            raise UserError("Invalid route-ipv6 directive.")
        if name == "route-nopull" and len(args) != 1:
            raise UserError("Invalid route-nopull directive.")
        options.append((name, args[1:]))
    if inline:
        raise UserError("Unterminated OpenVPN inline section.")
    return options


def apply_openvpn_ip(connection, options):
    ip4 = connection.get_setting_ip4_config()
    ip6 = connection.get_setting_ip6_config()
    if ip6 is None:
        ip6 = NM.SettingIP6Config.new()
        ip6.set_property("method", "auto")
        connection.add_setting(ip6)
    for name, args in options:
        if name == "ncp-disable":
            connection.get_setting_vpn().add_data_item("ncp-disable", "yes")
        if name == "route-nopull":
            for setting in (ip4, ip6):
                setting.set_property("ignore-auto-routes", True)
                setting.set_property("ignore-auto-dns", True)
                setting.set_property("never-default", True)
        elif name == "redirect-gateway":
            if "!ipv4" not in args:
                if "def1" in args:
                    ip4.add_route(NM.IPRoute.new(socket.AF_INET, "0.0.0.0", 1, None, -1))
                    ip4.add_route(NM.IPRoute.new(socket.AF_INET, "128.0.0.0", 1, None, -1))
                else:
                    ip4.add_route(NM.IPRoute.new(socket.AF_INET, "0.0.0.0", 0, None, -1))
            if "ipv6" in args:
                ip6.add_route(NM.IPRoute.new(socket.AF_INET6, "2000::", 4, None, -1))
                ip6.add_route(NM.IPRoute.new(socket.AF_INET6, "3000::", 4, None, -1))
        elif name == "dhcp-option":
            if args[0] in {"DNS", "DNS6"}:
                address = ipaddress.ip_address(args[1])
                (ip4 if address.version == 4 else ip6).add_dns(str(address))
            else:
                for setting in (ip4, ip6):
                    setting.add_dns_search(args[1])
        elif name == "route-ipv6":
            network = ipaddress.IPv6Network(args[0], strict=False)
            gateway = args[1] if len(args) > 1 else None
            if gateway:
                gateway = str(ipaddress.IPv6Address(gateway))
            metric = int(args[2]) if len(args) > 2 else -1
            ip6.add_route(NM.IPRoute.new(socket.AF_INET6, str(network.network_address), network.prefixlen, gateway, metric))


def review_wireguard(text):
    section = None
    interface = {"privatekey", "address", "listenport", "dns", "mtu", "table", "fwmark"}
    peer = {"publickey", "presharedkey", "allowedips", "endpoint", "persistentkeepalive"}
    addresses = set()
    dns_families = set()
    domains = False
    for number, line in enumerate(text.splitlines(), 1):
        line = "".join(line.split("#", 1)[0].split())
        if not line:
            continue
        if line.lower() in {"[interface]", "[peer]"}:
            section = line.lower()
            continue
        if "=" not in line or section is None:
            raise UserError(f"Unsupported WireGuard configuration on line {number}.")
        name, value = line.split("=", 1)
        name = name.lower()
        if name in {"preup", "postup", "predown", "postdown", "saveconfig"}:
            raise UserError(f"WireGuard hook/SaveConfig on line {number} is unsupported and will never execute. Express routes and DNS in NetworkManager instead.")
        if name not in (interface if section == "[interface]" else peer):
            raise UserError(f"Unsupported WireGuard field on line {number}; no fields will be silently dropped.")
        if name == "address":
            addresses.update(ipaddress.ip_interface(item).version for item in value.split(","))
        elif name == "dns":
            for item in value.split(","):
                try:
                    dns_families.add(ipaddress.ip_address(item).version)
                except ValueError:
                    domains = True
    # libnm discards DNS for an address family without an interface address.
    # Reject instead of silently importing a different DNS policy.
    if not dns_families.issubset(addresses) or (domains and not addresses):
        raise UserError("NetworkManager cannot preserve this DNS setting without an interface address in the same IP family. Add that address or configure DNS explicitly in its editor.")


def import_profile(nm, kind, filename):
    created_stores = []
    try:
        return _import_profile(nm, kind, filename, created_stores)
    except Exception:
        # Only remove fresh namespaces created by this operation. Never touch
        # original imports, existing certificates or another profile's keys.
        for directory in created_stores:
            shutil.rmtree(directory)
        raise


def _import_profile(nm, kind, filename, created_stores):
    path, text = read_config(filename)
    if kind == "wireguard":
        review_wireguard(text)
        connection = NM.conn_wireguard_import(str(path))
    elif kind == "openvpn":
        options = review_openvpn(text)
        info = NM.VpnPluginInfo.new_search_file(None, OPENVPN)
        if info is None:
            raise UserError("Install networkmanager-openvpn, including its editor plugin, to import OpenVPN.")
        # Use the plugin's standard certificate store, in a fresh restricted
        # namespace: inline private keys must never overwrite another profile.
        base = Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))) / "networkmanagement/certificates" / str(uuid.uuid4())
        base.mkdir(mode=0o700, parents=True)
        created_stores.append(base)
        target = base / "nm-openvpn"
        target.mkdir(mode=0o700)
        os.environ["NM_CERT_PATH"] = str(base)
        try:
            plugin = info.load_editor_plugin()
            connection = plugin.import_(str(path))
        finally:
            # The upstream importer uses 0600 files; enforce on this new
            # namespace only, never on the user's existing certificate files.
            for created in target.iterdir():
                if created.is_file() and not created.is_symlink():
                    created.chmod(stat.S_IRUSR | stat.S_IWUSR)
        apply_openvpn_ip(connection, options)
    else:
        raise UserError("Choose OpenVPN or WireGuard.")
    if connection is None:
        raise UserError("NetworkManager could not import this configuration.")
    setting = connection.get_setting_connection()
    setting.set_property("uuid", str(uuid.uuid4()))
    if not setting.get_id():
        setting.set_property("id", path.stem)
    setting.set_property("type", "wireguard" if kind == "wireguard" else "vpn")
    setting.set_property("autoconnect", False)
    setting.add_permission("user", GLib.get_user_name(), None)
    connection.normalize(None)
    connection.verify()
    saved = finish_async(lambda callback: nm.add_connection_async(connection, True, None, callback, None),
                         lambda source, result: source.add_connection_finish(result))
    return saved.get_uuid()


def main():
    action = sys.argv[1] if len(sys.argv) > 1 else "list"
    nm = client()
    if action == "list":
        emit(profiles=profiles(nm), version=nm.get_version())
    elif action == "import":
        identifier = import_profile(nm, sys.argv[2], sys.argv[3])
        emit(ok=True, uuid=identifier, message="Imported into NetworkManager. Review routes/DNS in Edit before connecting; no tunnel was activated. OpenVPN process defaults (auth-nocache, nobind, persist-key/tun, user/group), if present, are managed by the NetworkManager service rather than copied literally.")
    elif action == "disconnect":
        connection = profile(nm, sys.argv[2])
        current = next((item for item in nm.get_active_connections() if item.get_uuid() == connection.get_uuid()), None)
        if current:
            finish_async(lambda callback: nm.deactivate_connection_async(current, None, callback, None),
                         lambda source, result: source.deactivate_connection_finish(result))
        emit(ok=True, message="Disconnection requested.")
    elif action == "delete":
        connection = profile(nm, sys.argv[2])
        if any(item.get_uuid() == connection.get_uuid() for item in nm.get_active_connections()):
            raise UserError("Disconnect the VPN before deleting its profile.")
        finish_async(lambda callback: connection.delete_async(None, callback, None),
                     lambda source, result: source.delete_finish(result))
        emit(ok=True, message="Profile deleted from NetworkManager. Original import and external certificate files were not deleted.")
    elif action == "connect":
        connection = profile(nm, sys.argv[2])
        # Kitty supplies a controlling terminal. nmcli --ask registers a real
        # NetworkManager secret agent and disables terminal echo for secrets.
        # Never collect, forward, or persist its output in Quickshell.
        status = subprocess.call(["nmcli", "--ask", "--wait", "120", "connection", "up", "uuid", connection.get_uuid()])
        if status:
            input("VPN activation failed or was cancelled. Press Enter to close.")
        return status
    else:
        raise UserError("Unknown VPN operation.")
    return 0


if __name__ == "__main__":
    os.umask(0o077)
    try:
        sys.exit(main())
    except UserError as error:
        emit(ok=False, error=str(error))
        sys.exit(1)
    except (GLib.Error, OSError, ValueError, TypeError, AttributeError, IndexError):
        # Plugin parse errors can quote source lines containing secrets.
        emit(ok=False, error="VPN operation failed. Check the selected file, supported options, NetworkManager/plugin versions and polkit authorization. No configuration contents are logged.")
        sys.exit(1)
