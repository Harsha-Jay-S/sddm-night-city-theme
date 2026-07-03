# Night City Login Theme

Cyberpunk/anime login theme for **SDDM** (QML) and **GDM** (CSS).

## SDDM Theme

Full QML theme with animated scanlines, corner brackets, glassmorphism auth panel, orbital clock glow, and power buttons.

### Install

```bash
# Clone anywhere
git clone <repo-url> night-city-theme
cd night-city-theme

# Install theme files
sudo bash sddm/apply_fix.sh

# Enable SDDM
sudo systemctl disable gdm.service   # or lightdm
sudo systemctl enable sddm.service
reboot
```

### Test without switching

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/night-city
```

## GDM Theme

CSS patch for GNOME Shell's lock screen — custom wallpaper, Orbitron/ChakraPetch fonts, cyan accent color, dark glass login dialog.

### Install

```bash
sudo bash gdm/install-gdm-theme.sh
sudo systemctl disable sddm.service
sudo systemctl enable gdm.service
reboot
```

### Re-apply after gnome-shell update

gnome-shell updates overwrite the theme. Run the install script again:

```bash
sudo bash gdm/install-gdm-theme.sh
```

### Restore stock GDM

```bash
sudo dnf reinstall gnome-shell
sudo rm -f /etc/dconf/db/gdm.d/01-cyber-accent
sudo dconf update
```

## Assets

| File | Source |
|------|--------|
| `assets/background.jpg` | Neon race car wallpaper (5760×3600) |
| `assets/fonts/Orbitron-Variable.ttf` | [Orbitron](https://fonts.google.com/specimen/Orbitron) — OFL |
| `assets/fonts/ChakraPetch-*.ttf` | [ChakraPetch](https://fonts.google.com/specimen/ChakraPetch) — OFL |

## Layout

```
night-city-theme/
├── assets/
│   ├── fonts/           # Shared TTF files
│   └── background.jpg
├── sddm/
│   ├── theme/           # 7 QML files + metadata.desktop
│   └── apply_fix.sh     # Installs to /usr/share/sddm/themes/night-city
├── gdm/
│   ├── gdm-dark.patch
│   ├── gdm-light.patch
│   ├── gnome-shell-theme.gresource.xml
│   └── install-gdm-theme.sh
└── README.md
```
