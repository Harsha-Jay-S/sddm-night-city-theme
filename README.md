# SDDM Night City Theme

Cyberpunk/anime login theme for **SDDM** (QML).

Full QML theme with animated scanlines, corner brackets, glassmorphism auth panel, orbital clock glow, and power buttons.

## Requirements

- **SDDM** 0.22+ (display manager)
- **Qt 6** (uses `QtQuick.Effects` — Qt 5 / Qt 5Compat not supported)
- Test command: `sddm-greeter-qt6`

Tested end-to-end on Fedora 43 / Qt 6.10 / SDDM 0.22. `install.sh` is written to be
distro-agnostic (it detects your OS name and logo, and uses standard
freedesktop/systemd/PAM mechanisms rather than anything Fedora-specific), but
has not been run on Arch/Ubuntu/Debian/openSUSE. If something doesn't fire on
your distro, the install output tells you which step it was.

## Install

```bash
git clone <repo-url> sddm-night-city-theme
cd sddm-night-city-theme
sudo ./install.sh

# Enable SDDM if it isn't your current display manager
sudo systemctl disable gdm.service   # or lightdm
sudo systemctl enable sddm.service
reboot
```

`install.sh` copies the theme to `/usr/share/sddm/themes/night-city`, sets it as
the active theme, bakes in your OS name and logo (resolved from the running
system — falls back to a generic Linux glyph if none is found), and enables
the battery-percentage indicator. Re-run it any time after `git pull` to
update an existing install.

## Greeter runs on X11 (mouse-input fix)

Fedora's default SDDM greeter runs under **weston** (Wayland, `--shell=kiosk`),
which does not reliably deliver mouse clicks to a QML theme surface when
fractional/HiDPI scaling is in use — the keyboard works but buttons don't
respond. To avoid this, `install.sh` sets the **greeter** to X11 when `Xorg` is
available, via `/etc/sddm.conf.d/20-night-city-x11.conf`:

```ini
[General]
DisplayServer=x11
```

Because the greeter now runs on X11, `install.sh` also drops
`/etc/X11/xorg.conf.d/40-night-city-touchpad-tap.conf` to enable touchpad
**tap-to-click** at the greeter (libinput leaves tapping off by default, and the
greeter has no per-user desktop setting to turn it on).

This only changes the login screen — you still log into whatever (Wayland)
desktop session you pick. To revert to the default Wayland greeter:

```bash
sudo rm /etc/sddm.conf.d/20-night-city-x11.conf \
        /etc/X11/xorg.conf.d/40-night-city-touchpad-tap.conf
sudo systemctl restart sddm
```

If `Xorg` isn't installed and you hit dead buttons on the Wayland greeter, the
underlying issue is weston's output scale. As an alternative to X11 you can try
forcing the greeter scale to 1 (or matching your panel) via a `weston.ini` for
the `sddm` user / SDDM's `[Wayland]` compositor settings — fiddlier and less
reliable than the X11 route above.

**Lock-out safety:** changing the greeter's display server is a login-screen
change. If the X11 greeter ever fails to start, switch to a text console
(Ctrl+Alt+F3), log in, run the revert command above, and reboot.

## Test without switching

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/night-city
```

## Assets

| File | Source |
|------|--------|
| `assets/background.jpg` | Neon race car wallpaper (5760×3600) |
| `assets/fonts/Orbitron-Variable.ttf` | [Orbitron](https://fonts.google.com/specimen/Orbitron) — OFL |
| `assets/fonts/ChakraPetch-*.ttf` | [ChakraPetch](https://fonts.google.com/specimen/ChakraPetch) — OFL |
| `assets/distro-logo-fallback.svg` | [Simple Icons](https://simpleicons.org) "linux" glyph — CC0-1.0. Used only when `install.sh` can't find a distro-specific icon on the system; your actual distro's own logo (already on your disk) is used when available and shown in its native colours, not this fallback. |

## Layout

```
sddm-night-city-theme/
├── assets/
│   ├── fonts/                    # Shared TTF files
│   ├── background.jpg
│   └── distro-logo-fallback.svg  # Used only if no system icon is found
├── sddm/
│   └── theme/           # QML files + metadata.desktop
├── install.sh            # Installs to /usr/share/sddm/themes/night-city
├── README.md
└── .gitignore
```
