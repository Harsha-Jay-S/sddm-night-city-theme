#!/bin/bash
# Installs the Night City SDDM theme, sets it as the active theme, and wires
# up the runtime bits it needs (distro logo, battery read permission).
#
# Verified end-to-end on Fedora 43 only. The distro-logo resolution, the
# /etc/environment route to the greeter, and the sddm.conf precedence handling
# are written to be distro-agnostic (freedesktop/systemd standards, not
# Fedora-specific), but have not been tested on Arch/Ubuntu/Debian/openSUSE.
# If something here doesn't fire on your distro, that's the part to check.
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: sudo ./install.sh" >&2
    exit 1
fi

BASE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
THEME_SRC=$BASE/sddm/theme
ASSETS=$BASE/assets
THEME_NAME=night-city
THEME_DST=/usr/share/sddm/themes/$THEME_NAME

echo "=== Installing Night City SDDM theme ==="

if ! command -v sddm-greeter-qt6 >/dev/null 2>&1; then
    echo "WARNING: sddm-greeter-qt6 not found. This theme uses QtQuick.Effects" >&2
    echo "         (Qt 6 only) and will not render under a Qt 5-only SDDM install." >&2
fi

mkdir -p "$THEME_DST/fonts"

for f in Main.qml BackgroundLayer.qml CornerBrackets.qml ClockDisplay.qml \
         StatusPills.qml AuthPanel.qml PowerButtons.qml SessionSwitcher.qml \
         metadata.desktop; do
    cp "$THEME_SRC/$f" "$THEME_DST/$f"
done
cp "$ASSETS/background.jpg" "$THEME_DST/background.jpg"
cp "$ASSETS/fonts/"*.ttf "$THEME_DST/fonts/"

# --- bake the OS name (reading it at runtime would need file XHR, see below) ---
OS_NAME=$( ( . /etc/os-release 2>/dev/null; echo "${NAME:-Linux}${VERSION_ID:+ $VERSION_ID}" ) | tr '[:lower:]' '[:upper:]' )
sed -i "s|__OS_NAME__|${OS_NAME}|g" "$THEME_DST/StatusPills.qml"
echo "OS pill: $OS_NAME"

# --- resolve a real distro logo from the running system ---
# Uses the freedesktop os-release LOGO field (an icon-theme name, e.g.
# "fedora-logo-icon") plus common fallback names, searched across the
# standard icon locations every distro uses. Shown in native colours, not
# recoloured. PNG is preferred over SVG since it always renders — SVG needs
# the qt6-qtsvg plugin, which is not guaranteed installed.
LOGO_NAME=$( . /etc/os-release 2>/dev/null; echo "${LOGO:-}" )
DISTRO_ID=$( . /etc/os-release 2>/dev/null; echo "${ID:-}" )
ICON_DIRS=(
    /usr/share/icons/hicolor/256x256/apps
    /usr/share/icons/hicolor/128x128/apps
    /usr/share/icons/hicolor/scalable/apps
    /usr/share/pixmaps
)
CANDIDATES=()
[ -n "$LOGO_NAME" ] && CANDIDATES+=("$LOGO_NAME")
[ -n "$DISTRO_ID" ] && CANDIDATES+=("distributor-logo-$DISTRO_ID" "$DISTRO_ID-logo" "$DISTRO_ID")
CANDIDATES+=("distributor-logo")

FOUND=""
FOUND_EXT=""
for name in "${CANDIDATES[@]}"; do
    for ext in png svg; do
        for d in "${ICON_DIRS[@]}"; do
            if [ -f "$d/$name.$ext" ]; then
                FOUND="$d/$name.$ext"
                FOUND_EXT="$ext"
                break 3
            fi
        done
    done
done

if [ -n "$FOUND" ]; then
    cp "$FOUND" "$THEME_DST/distro-logo.$FOUND_EXT"
    LOGO_FILE="distro-logo.$FOUND_EXT"
    echo "Distro logo: $FOUND"
else
    cp "$ASSETS/distro-logo-fallback.svg" "$THEME_DST/distro-logo-fallback.svg"
    LOGO_FILE="distro-logo-fallback.svg"
    echo "Distro logo: none found on this system, using generic fallback"
fi
sed -i "s|__DISTRO_LOGO_FILE__|${LOGO_FILE}|g" "$THEME_DST/StatusPills.qml"

restorecon -Rv "$THEME_DST" 2>/dev/null || true

# Clean up files from older versions of this theme that no longer exist.
rm -f "$THEME_DST/GlowBlob.qml" "$THEME_DST/ScanlinesOverlay.qml" "$THEME_DST/GrainOverlay.qml"
rm -f "$THEME_DST/ColorGradeOverlay.qml" "$THEME_DST/BootSweep.qml" "$THEME_DST/TelemetryPanel.qml"
rm -f "$THEME_DST/BottomBar.qml" "$THEME_DST/AccessGrantedOverlay.qml" "$THEME_DST/AuthCard.qml"
rm -f "$THEME_DST/background_shader.frag" "$THEME_DST/background_shader.qsb" "$THEME_DST/background.mp4" "$THEME_DST/background_4k.mp4"

# --- allow the greeter to read sysfs (battery %) via XMLHttpRequest ---
# Qt 6 blocks GET on local files unless QML_XHR_ALLOW_FILE_READ=1 is in the
# greeter's environment. Verified route (Fedora 43): /etc/pam.d/sddm-greeter
# runs pam_env.so, which loads /etc/environment into the greeter session.
# pam_env is a standard PAM module shipped on essentially all Linux distros,
# but the exact sddm-greeter PAM stack is packaged per-distro, so this is
# expected-but-unverified elsewhere. Takes effect on the next greeter start.
if ! grep -q '^QML_XHR_ALLOW_FILE_READ=' /etc/environment 2>/dev/null; then
    echo 'QML_XHR_ALLOW_FILE_READ=1' >> /etc/environment
    echo "Added QML_XHR_ALLOW_FILE_READ=1 to /etc/environment"
fi

# --- set as the active theme ---
# sddm merges config in this order, each overriding the last (per `man
# sddm.conf`): /usr/lib/sddm/sddm.conf.d, /etc/sddm.conf.d/*.conf, then
# /etc/sddm.conf — so /etc/sddm.conf has the final word. If it already sets
# Current=, that's the one that counts and must be the one we edit; otherwise
# a conf.d drop-in is enough.
if [ -f /etc/sddm.conf ] && grep -q '^Current=' /etc/sddm.conf; then
    sed -i "s|^Current=.*|Current=$THEME_NAME|" /etc/sddm.conf
    echo "Set Current=$THEME_NAME in /etc/sddm.conf"
else
    mkdir -p /etc/sddm.conf.d
    printf '[Theme]\nCurrent=%s\n' "$THEME_NAME" > /etc/sddm.conf.d/10-theme.conf
    echo "Set Current=$THEME_NAME in /etc/sddm.conf.d/10-theme.conf"
fi

# --- run the greeter on X11 (reliable mouse input) ---
# Fedora's default SDDM greeter runs under weston (Wayland, `--shell=kiosk`),
# which mis-delivers pointer clicks to a QML theme surface under fractional/
# HiDPI scaling — keyboard works but buttons don't. The X11 greeter delivers
# clicks reliably. This only changes the *greeter*; the user still logs into
# whatever (Wayland) session they pick. Written as a separate, clearly-named
# drop-in so it is trivial to revert. Only done when Xorg is actually present.
X11_DROPIN=/etc/sddm.conf.d/20-night-city-x11.conf
if command -v Xorg >/dev/null 2>&1; then
    mkdir -p /etc/sddm.conf.d
    printf '[General]\nDisplayServer=x11\n' > "$X11_DROPIN"
    echo ""
    echo "NOTE: set the SDDM greeter to X11 (DisplayServer=x11) for reliable mouse"
    echo "      input — the weston Wayland greeter drops clicks under HiDPI scaling."
    echo "      This affects only the login screen, not your desktop session."
    echo "      Revert with:  sudo rm $X11_DROPIN  &&  sudo systemctl restart sddm"
else
    echo ""
    echo "NOTE: Xorg not found, leaving the greeter on its default display server."
    echo "      If buttons don't respond to the mouse at the login screen, it is the"
    echo "      weston Wayland greeter; install Xorg or see the README for the"
    echo "      Wayland greeter-scale workaround."
fi

echo ""
echo "=== Installed to $THEME_DST ==="
echo ""
echo "Test without rebooting:"
echo "  QML_XHR_ALLOW_FILE_READ=1 sddm-greeter-qt6 --test-mode --theme $THEME_DST"
echo ""
echo "Reboot (or: systemctl restart sddm) for the real login screen, and for the"
echo "battery-read environment variable to take effect."
echo ""
echo "If SDDM is not your current display manager:"
echo "  sudo systemctl enable sddm.service"
