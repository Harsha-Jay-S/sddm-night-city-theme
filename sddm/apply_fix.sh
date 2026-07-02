#!/bin/bash
set -e

BASE=/home/jayharsha/night-city-theme
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
cp "$ASSETS/background.jpg" "$THEME_DST/background.jpg"
cp "$THEME_SRC/metadata.desktop" "$THEME_DST/metadata.desktop"
cp "$ASSETS/fonts/"*.ttf "$THEME_DST/fonts/"

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
echo ""
echo "To enable:"
echo "  sudo systemctl disable gdm.service"
echo "  sudo systemctl enable sddm.service"
echo ""
echo "To revert:"
echo "  sudo systemctl disable sddm.service"
echo "  sudo systemctl enable gdm.service"
