# Eclipse splash and original identity

The new splash is an **implementation candidate for visual review**, not a claim
that the owner has approved final artwork. Its original conjunction seal combines
an eclipsed dark disc, broken meridians, an inclined ring and a small northern
index diamond. Sparse rays retain a recognizable silhouette without turning the
splash into a game sigil. The outlined wordmark is constructed from original
paths, not a font. No game assets, reference photographs or generated wallpaper
are included in this theme. The rejected generated image is not used.

## Files and provenance

- `.github/assets/eclipse-mark.svg`: canonical, original small-size mark.
- `.github/assets/eclipse-wordmark.svg`: canonical, original outlined wordmark.
- `.github/assets/eclipse-splash.png`: static layout preview at 1920 × 1080;
  illustrative 70% progress, with the rings in their aligned position. This is
  an asset composition, **not a screenshot of Plymouth**.
- `.github/assets/eclipse-plymouth-{boot,password,shutdown}.png`: actual
  Plymouth/X11 renderer captures at 1280 × 720 from the isolated smoke below.
- `system/usr/share/plymouth/themes/eclipse/eclipse.plymouth`: script-module
  descriptor, installed theme name `eclipse`.
- `system/usr/share/plymouth/themes/eclipse/eclipse.script`: runtime layout,
  progress, authentication, messages and shutdown presentation.
- `system/usr/share/plymouth/themes/eclipse/source/`: editable SVG sources for
  the outer/inclined meridians, entry field, password bullet and progress rule.
  PNGs beside the script are the runtime assets; Plymouth does not need an SVG
  renderer in the initramfs.

The new vectors were authored for Eclipse on 2026-10-28 and are distributed under
GPL-3.0-or-later, as stated in each source. They contain no third-party font
outlines or sampled imagery. Rendering uses librsvg's `rsvg-convert`; the static
preview was composed with ImageMagick. There is no image-model provenance to
supply because these assets are deterministic, original vector construction.

The script's dialogue/layout integration derives from
[Impasto by Andreu Massanet](https://github.com/andreumassanet/impasto).
Its attribution remains in the script and descriptor, and the repository's
upstream `LICENSE` remains intact. Rebranding does not replace legal credit.
The old board, paint daubs, painting background and Impasto wordmark are removed
from the theme rather than retained as a hidden fallback.

## Behavior

The background is a quiet charcoal-violet gradient, not a scene wallpaper.
Meridians ease from slightly separated positions into conjunction as Plymouth
reports boot progress. They do not spin endlessly or pretend time alone is
progress. A thin track/fill gives explicit progress independent of that motion.
Images are scaled once at initialization; the refresh callback only moves/fades
sprites. Progress images are resized only when their displayed pixel width
changes. Shutdown/reboot begins with the mark aligned and a clear mode label.

An encrypted-disk prompt raises the emblem and shows Plymouth's actual prompt,
a field and masked bullets. Only the bullet count is rendered: the script never
receives or stores the password. The field shows up to 28 bullets, avoiding
screen overflow for longer passphrases; Plymouth still receives the full entry.
Returning to normal hides the field. Status updates and more prominent messages
(including filesystem-check or authentication/error messages) have separate
bottom rows. Long text is scaled to fit, rather than silently truncated.
Plymouth's normal Escape-to-details behavior is not intercepted.

The API is Plymouth's script module, using Image, Sprite, Window and Math plus
its password, normal, progress, status and display/hide-message callbacks. See
[the upstream scripting reference](https://www.freedesktop.org/wiki/Software/Plymouth/Scripts/)
and the installed example `/usr/share/plymouth/themes/script/script.script`.
There are no Qt, JavaScript browser or canvas dependencies.

## Regenerate raster assets

From the repository root, with librsvg installed:

```bash
theme=system/usr/share/plymouth/themes/eclipse
rsvg-convert -w 1024 -h 1024 .github/assets/eclipse-mark.svg -o "$theme/mark.png"
rsvg-convert -w 1200 -h 187 .github/assets/eclipse-wordmark.svg -o "$theme/wordmark.png"
for asset in ring-a ring-b entry progress bullet; do
    rsvg-convert "$theme/source/$asset.svg" -o "$theme/$asset.png"
done
```

The runtime sizes at 1080p are 256 px for the seal, 360 px for the meridians,
300 × 47 px for the wordmark and 440 × 60 px for the password field. All share
the smaller of the horizontal/vertical screen scale, preserving aspect ratio.
The reusable mark SVG is deliberately less detailed than the surrounding splash
instrument, so it can also stand alone at small sizes.

## Preview and smoke recipe — disposable VM or designated test laptop only

Do not run these commands on the development workstation or during an active
boot/shutdown. Previewing Plymouth uses its system daemon/socket and a VT: it is
not isolated just because no initramfs is rebuilt. Use a disposable graphical VM
(or the designated laptop once deployment is agreed), a spare VT, and a second
terminal for control and recovery. Keep a working SSH/console session.

1. Inspect the machine's bootloader, root encryption and current theme first.
   Record `plymouth-set-default-theme` and preserve `/etc/plymouth/plymouthd.conf`
   if present. Ensure no Plymouth daemon is already running. For this preview,
   copy only `system/usr/share/plymouth/themes/eclipse/` to
   `/usr/share/plymouth/themes/eclipse/`; do not use `./setup install` or
   `./setup system` as a preview command.
2. On that disposable target choose `sudo plymouth-set-default-theme eclipse`
   **without `-R`**. This changes the target's default theme but does not rebuild
   its initramfs. Start the daemon in the first terminal:

   ```bash
   sudo plymouthd --no-daemon --debug --debug-file=/tmp/eclipse-plymouth.log \
       --no-boot-log --tty=/dev/tty8 --mode=boot
   ```

3. From the second terminal request and exercise the splash:

   ```bash
   sudo plymouth show-splash
   sudo plymouth update --status='Checking storage'
   sudo plymouth display-message --text='Preview: an example diagnostic message'
   sudo plymouth hide-message --text='Preview: an example diagnostic message'
   sudo plymouth ask-for-password --prompt='Preview only: enter a dummy passphrase' | wc -c
   sudo plymouth quit
   ```

   Switch to the spare VT through the VM console as needed. Enter **dummy text
   only**: this is a UI preview, not a disk unlock. Check bullets, backspace,
   an empty field, a long passphrase, prompt visibility and return to normal.
   Use `sudo plymouth quit` from the control terminal to recover. Inspect the
   debug log for parser errors, missing images and script runtime errors. Repeat
   the daemon preview with `--mode=shutdown` to inspect the shutdown label. The
   `reboot` label is selected when Plymouth reports reboot mode.
4. Check 1280 × 720, 1920 × 1080 and a HiDPI VM display, plus portrait/narrow
   layouts if used. Confirm clear silhouette, wordmark, password prompt, bottom
   status/messages, and no ongoing spin after alignment. The preview daemon's
   estimated boot progress is not proof of real service progress.
5. Quit the daemon and restore the target's previous default theme/config after
   preview. Keep the debug log and visual captures as evidence.

## Exercised isolated renderer smoke

On 2026-10-28 the installed Plymouth daemon and `script.so` were run against the
checkout theme in a Bubblewrap sandbox, with private user, mount, PID, IPC and
network namespaces (`--unshare-all --uid 0 --gid 0 --die-with-parent`). `/usr` and
`/etc` were read-only, `/dev` was a private device tree, `/run` and `/tmp` were
private tmpfs mounts, and the theme and a sandbox-only configuration were bound
over `/usr/share/plymouth/themes/eclipse` and `/etc/plymouth/plymouthd.conf`.
The private network namespace isolates Plymouth's abstract Unix socket from any
host daemon. No real VT, DRM device or host daemon socket was exposed.

Xvfb 21.1.25-2 was downloaded/extracted temporarily without package installation;
Mesa software rendering was selected with
`__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json` and
`LIBGL_ALWAYS_SOFTWARE=1`. The daemon's `--tty` was a sandbox-created PTY, **not
`/dev/null`** (which stalls terminal setup), with `DISPLAY=:97`. It used
`--no-daemon --debug --no-boot-log --mode=boot` and a sandbox debug log.

Observed: the X11 renderer opened, `script.so` parsed/executed the theme, and
actual captures showed the original emblem/wordmark, status plus diagnostic
message, empty password prompt and five masked bullets. XTest input of a dummy
five-character string followed by Backspace and Return produced a four-byte
response and returned the display to normal. Status, display/hide-message and
quit clients all returned zero. A fresh sandbox daemon in `--mode=shutdown`
rendered the aligned seal, completed progress rule and “Shutting down” label.
Debug logs contained no theme parse/runtime or missing-image errors; missing
optional default-theme/config probes were expected in the intentionally minimal
filesystem. A separate fake two-head run rendered at 800 × 600 and 640 × 480.

This is real script-module rendering, not actual startup or a disk unlock.
Hardware/DRM, target fonts, HiDPI, real service-driven progress, error retries,
Escape-to-details and boot-to-SDDM still require target acceptance. The test
namespace exited and its daemons were terminated; no host theme default,
service, bootloader or initramfs was changed.

## Real-boot acceptance still required

After the owner accepts the visual candidate and authorizes deployment, inspect
and back up the designated laptop's actual boot configuration. `./setup splash`
selects `eclipse` and can edit bootloader configuration/rebuild initramfs: it is
**deployment**, not preview. The existing `impasto.conf` mkinitcpio drop-in name
is intentionally retained for the installer's tracked-file lifecycle; it is not
a displayed brand or a second theme. Have a known-working boot entry/recovery
medium before changing early boot.

Verify an actual boot through progress, encrypted-root prompt if applicable,
wrong-password/retry diagnostics, Escape-to-details and the SDDM handoff. Verify
shutdown and restart on the target. An image preview or syntax check cannot
establish those outcomes. Only the isolated, private-renderer smoke above was
performed on the development workstation; no live daemon, host settings,
service, bootloader or initramfs operation was performed.
