#!/usr/bin/env bash
set -euo pipefail

# === Night City GDM Theme Installer ===
# Run: sudo bash /home/jayharsha/night-city-theme/gdm/install-gdm-theme.sh

BASE="/home/jayharsha/night-city-theme"
FONT_DIR="/usr/local/share/fonts/truetype/night-city"
TMPDIR=$(mktemp -d /tmp/gdm-theme-XXXXXX)
trap "rm -rf $TMPDIR" EXIT

echo "[1/7] Installing fonts system-wide..."
mkdir -p "$FONT_DIR"
cp "$BASE/assets/fonts/"*.ttf "$FONT_DIR/"
fc-cache -f -v

echo "[2/7] Extracting original gresource..."
for r in $(gresource list /usr/share/gnome-shell/gnome-shell-theme.gresource); do
  rel="${r#/org/gnome/shell/}"
  mkdir -p "$TMPDIR/$(dirname "$rel")"
  gresource extract /usr/share/gnome-shell/gnome-shell-theme.gresource "$r" > "$TMPDIR/$rel"
done

echo "[3/7] Adding wallpaper..."
cp "$BASE/assets/background.jpg" "$TMPDIR/theme/background.jpg"

echo "[4/7] Creating gresource XML..."
cat > "$TMPDIR/theme/gnome-shell-theme.gresource.xml" << 'XMLEOF'
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
    <file>background.jpg</file>
    <file>calendar-today-light.svg</file>
    <file>calendar-today.svg</file>
    <file>gnome-shell-dark.css</file>
    <file>gnome-shell-high-contrast.css</file>
    <file>gnome-shell-light.css</file>
    <file>gnome-shell-start.svg</file>
    <file>pad-osd.css</file>
    <file>workspace-placeholder.svg</file>
  </gresource>
</gresources>
XMLEOF

echo "[5/7] Applying CSS patches..."
patch -d "$TMPDIR/theme" < "$BASE/gdm/gdm-dark.patch"
patch -d "$TMPDIR/theme" < "$BASE/gdm/gdm-light.patch"

echo "[6/7] Compiling new gresource..."
glib-compile-resources --sourcedir="$TMPDIR/theme" "$TMPDIR/theme/gnome-shell-theme.gresource.xml"

echo "[7/7] Installing gresource..."
cp "$TMPDIR/theme/gnome-shell-theme.gresource" /usr/share/gnome-shell/gnome-shell-theme.gresource

echo "=== Setting GDM accent color ==="
mkdir -p /etc/dconf/db/gdm.d
cat > /etc/dconf/db/gdm.d/01-cyber-accent << 'DCEOF'
[org/gnome/login-screen]
accent-color='#00ffff'
DCEOF
dconf update

echo ""
echo "=== INSTALLATION COMPLETE ==="
echo ""
echo "Now switch to GDM and reboot:"
echo "  sudo systemctl disable sddm"
echo "  sudo systemctl enable gdm"
echo "  reboot"
echo ""
echo "To restore stock theme after gnome-shell update:"
echo "  sudo dnf reinstall gnome-shell"
echo "Then re-run: sudo bash $0"
