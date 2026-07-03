#!/bin/bash
set -e

BASE=$(cd "$(dirname "$0")/.." && pwd)
THEME_SRC=$BASE/sddm/theme
ASSETS=$BASE/assets
THEME_DST=/usr/share/sddm/themes/night-city

echo "=== Installing Night City Login SDDM Theme ==="

mkdir -p "$THEME_DST"
mkdir -p "$THEME_DST/fonts"

cp "$THEME_SRC/Main.qml" "$THEME_DST/Main.qml"
cp "$THEME_SRC/BackgroundLayer.qml" "$THEME_DST/BackgroundLayer.qml"
cp "$THEME_SRC/CornerBrackets.qml" "$THEME_DST/CornerBrackets.qml"
cp "$THEME_SRC/ClockDisplay.qml" "$THEME_DST/ClockDisplay.qml"
cp "$THEME_SRC/StatusPills.qml" "$THEME_DST/StatusPills.qml"
cp "$THEME_SRC/AuthPanel.qml" "$THEME_DST/AuthPanel.qml"
cp "$THEME_SRC/PowerButtons.qml" "$THEME_DST/PowerButtons.qml"
cp "$THEME_SRC/SessionSwitcher.qml" "$THEME_DST/SessionSwitcher.qml"
cp "$ASSETS/background.jpg" "$THEME_DST/background.jpg"
cp "$THEME_SRC/metadata.desktop" "$THEME_DST/metadata.desktop"
cp "$ASSETS/fonts/"*.ttf "$THEME_DST/fonts/"

# Bake the OS name into StatusPills.qml (reading it at runtime would need file
# XHR, which Qt 6 disables by default).
OS_NAME=$( ( . /etc/os-release 2>/dev/null; echo "${NAME:-Linux}${VERSION_ID:+ $VERSION_ID}" ) | tr '[:lower:]' '[:upper:]' )
sed -i "s|__OS_NAME__|${OS_NAME}|g" "$THEME_DST/StatusPills.qml"
echo "OS pill set to: $OS_NAME"

# Allow the greeter's QML to read sysfs (battery %) via XMLHttpRequest. Qt 6
# blocks GET on local files unless QML_XHR_ALLOW_FILE_READ=1 is in the greeter
# environment. /etc/pam.d/sddm-greeter runs pam_env, which loads /etc/environment
# into the greeter session, so setting it there reliably reaches the greeter.
# Takes effect on the next greeter start (reboot / systemctl restart sddm).
if ! grep -q '^QML_XHR_ALLOW_FILE_READ=' /etc/environment 2>/dev/null; then
    echo 'QML_XHR_ALLOW_FILE_READ=1' >> /etc/environment
    echo "Added QML_XHR_ALLOW_FILE_READ=1 to /etc/environment"
fi

restorecon -v "$THEME_DST/"*.qml "$THEME_DST/background.jpg" "$THEME_DST/metadata.desktop" "$THEME_DST/fonts/"*.ttf 2>/dev/null || true

# Clean up old files from previous versions
rm -f "$THEME_DST/GlowBlob.qml" "$THEME_DST/ScanlinesOverlay.qml" "$THEME_DST/GrainOverlay.qml"
rm -f "$THEME_DST/ColorGradeOverlay.qml" "$THEME_DST/BootSweep.qml" "$THEME_DST/TelemetryPanel.qml"
rm -f "$THEME_DST/BottomBar.qml" "$THEME_DST/AccessGrantedOverlay.qml" "$THEME_DST/AuthCard.qml"
rm -f "$THEME_DST/background_shader.frag" "$THEME_DST/background_shader.qsb" "$THEME_DST/background.mp4" "$THEME_DST/background_4k.mp4"

echo ""
echo "=== Theme installed to $THEME_DST ==="
echo ""
echo "To test without switching:"
echo "  sddm-greeter-qt6 --test-mode --theme $THEME_DST"
echo "  # (on Qt 5 distros: sddm-greeter --test-mode --theme $THEME_DST)"
echo ""
echo "If SDDM is not your current DM, enable it:"
echo "  sudo systemctl enable sddm.service"
