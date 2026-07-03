# SDDM Night City Theme

Cyberpunk/anime login theme for **SDDM** (QML).

Full QML theme with animated scanlines, corner brackets, glassmorphism auth panel, orbital clock glow, and power buttons.

## Install

```bash
# Clone anywhere
git clone <repo-url> sddm-night-city-theme
cd sddm-night-city-theme

# Install theme files
sudo bash sddm/apply_fix.sh

# Enable SDDM
sudo systemctl disable gdm.service   # or lightdm
sudo systemctl enable sddm.service
reboot
```

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

## Layout

```
sddm-night-city-theme/
├── assets/
│   ├── fonts/           # Shared TTF files
│   └── background.jpg
├── sddm/
│   ├── theme/           # 7 QML files + metadata.desktop
│   └── apply_fix.sh     # Installs to /usr/share/sddm/themes/night-city
├── README.md
└── .gitignore
```
