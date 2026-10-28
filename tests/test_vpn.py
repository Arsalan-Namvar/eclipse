"""Offline libnm regressions; no system bus, profiles, or network changes.

Run with /usr/bin/python3 -m unittest discover -s tests -p test_vpn.py.
"""
import importlib.util
from pathlib import Path
import socket
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "home/.config/quickshell/scripts/vpn.py"
spec = importlib.util.spec_from_file_location("eclipse_vpn", SCRIPT)
vpn = importlib.util.module_from_spec(spec)
spec.loader.exec_module(vpn)


class ImportReviewTests(unittest.TestCase):
    def connection(self):
        connection = vpn.NM.SimpleConnection.new()
        connection.add_setting(vpn.NM.SettingVpn.new())
        ip4 = vpn.NM.SettingIP4Config.new()
        ip4.set_property("method", "auto")
        connection.add_setting(ip4)
        return connection

    def test_ncp_disable_survives_plugin_ignored_option(self):
        connection = self.connection()
        vpn.apply_openvpn_ip(connection, vpn.review_openvpn("client\nncp-disable\n"))
        self.assertEqual(connection.get_setting_vpn().get_data_item("ncp-disable"), "yes")

    def test_openvpn_hooks_and_includes_are_rejected(self):
        for directive in ("up /tmp/hook", "down /tmp/hook", "plugin /tmp/plugin.so", "config other.ovpn", "script-security 2", "tls-verify /tmp/hook"):
            with self.subTest(directive=directive):
                with self.assertRaises(vpn.UserError):
                    vpn.review_openvpn("client\n" + directive)

    def test_wireguard_hooks_are_rejected_case_insensitively(self):
        for name in ("PreUp", "PostUp", "PreDown", "PostDown", "postup", "SaveConfig"):
            with self.subTest(name=name):
                with self.assertRaises(vpn.UserError):
                    vpn.review_wireguard("[Interface]\n" + name + "=do-not-run\n")

    def test_unknown_directives_never_silently_disappear(self):
        with self.assertRaises(vpn.UserError):
            vpn.review_openvpn("client\nnot-an-option secret-value\n")
        with self.assertRaises(vpn.UserError):
            vpn.review_wireguard("[Interface]\nUnknown=value\n")

    def test_inline_keys_are_not_interpreted_as_directives(self):
        result = vpn.review_openvpn("client\n<key>\nup this-is-private-key-content\n</key>\n")
        self.assertEqual(result, [("client", [])])

    def test_routing_dns_and_split_intent(self):
        connection = self.connection()
        vpn.apply_openvpn_ip(connection, vpn.review_openvpn("route-nopull\nredirect-gateway def1\ndhcp-option DNS 10.20.0.1\ndhcp-option DOMAIN-SEARCH internal.example\nroute-ipv6 fd00:20::/64\n"))
        ip4 = connection.get_setting_ip4_config()
        self.assertTrue(ip4.get_property("ignore-auto-routes"))
        self.assertTrue(ip4.get_property("ignore-auto-dns"))
        self.assertTrue(ip4.get_property("never-default"))
        self.assertEqual(ip4.get_num_routes(), 2)
        self.assertEqual(ip4.get_route(0).get_prefix(), 1)
        self.assertEqual(ip4.get_dns(0), "10.20.0.1")
        self.assertEqual(ip4.get_dns_search(0), "internal.example")
        self.assertEqual(connection.get_setting_ip6_config().get_route(0).get_dest(), "fd00:20::")

    def test_wireguard_dns_not_silently_dropped(self):
        with self.assertRaises(vpn.UserError):
            vpn.review_wireguard("[Interface]\nAddress=10.20.0.2/24\nDNS=fd00::1\n")
        vpn.review_wireguard("[Interface]\nAddress=10.20.0.2/24,fd00::2/64\nDNS=10.20.0.1,fd00::1,internal.example\n")

    def test_errors_do_not_echo_configuration_values(self):
        secret = "synthetic-secret-do-not-echo"
        with self.assertRaises(vpn.UserError) as error:
            vpn.review_openvpn("unsupported " + secret)
        self.assertNotIn(secret, str(error.exception))


if __name__ == "__main__":
    unittest.main()
