#!/bin/bash
set -e

# zawsze odpalaj z folderu repo, niezaleznie skad wywolany
cd "$(dirname "$(readlink -f "$0")")"

if [ "$EUID" -eq 0 ]; then
    echo "Nie odpalaj tego jako root, skrypt sam uzyje sudo."
    exit 1
fi

if ! command -v pacman >/dev/null; then
    echo "To dziala tylko na Arch / CachyOS (pacman)."
    exit 1
fi

# 1. Pakiety z repo
echo "Instaluje wymagane pakiety..."
PKGS=(
    git base-devel pkgconf
    xorg-server xorg-xinit xorg-xset xorg-xinput
    libx11 libxft libxinerama libxcb xcb-util freetype2 fontconfig
    ttf-font-awesome ttf-jetbrains-mono-nerd
    firefox discord spotify-launcher kitty fastfetch
)
sudo pacman -S --needed --noconfirm "${PKGS[@]}"

# 2. yay (AUR helper)
if ! command -v yay >/dev/null; then
    echo "Instaluje yay..."
    # na CachyOS yay jest w repo, na zwyklym Archu budujemy z AUR
    if ! sudo pacman -S --needed --noconfirm yay; then
        tmp=$(mktemp -d)
        git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
        (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi
fi

# 3. Picom (fork pijulius z AUR dla animacji, fallback na zwykly picom)
if ! command -v picom >/dev/null; then
    echo "Instaluje picom..."
    yay -S --needed --noconfirm picom-pijulius-git || sudo pacman -S --needed --noconfirm picom
fi

# 4. Konfiguracje do ~/.config
echo "Kopiuje pliki konfiguracyjne (picom, kitty, fastfetch)..."
mkdir -p ~/.config
cp -r config/picom ~/.config/
cp -r config/kitty ~/.config/
cp -r config/fastfetch ~/.config/

# 5. Mysz bez akceleracji
echo "Konfiguruje mysz (profil Flat)..."
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp 50-mouse-acceleration.conf /etc/X11/xorg.conf.d/

# 6. Kompilacja dwm i dwmblocks
echo "Kompiluje i instaluje DWM..."
(cd dwm && sudo make clean install)

echo "Kompiluje i instaluje DWMBLOCKS..."
(cd dwmblocks && sudo make clean install)

# 7. Skrypt startowy sesji (picom + dwmblocks + dwm)
echo "Tworze skrypt sesji i wpis dla SDDM..."
sudo tee /usr/local/bin/dwm-session >/dev/null <<'EOF'
#!/bin/sh
picom --backend glx &
dwmblocks &
exec /usr/local/bin/dwm
EOF
sudo chmod +x /usr/local/bin/dwm-session

sudo mkdir -p /usr/share/xsessions
sudo tee /usr/share/xsessions/dwm.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=dwm
Comment=dwm window manager
Exec=/usr/local/bin/dwm-session
Type=Application
EOF

# 8. ~/.xinitrc (dla startx z TTY), nie nadpisuje istniejacego
if [ -f ~/.xinitrc ]; then
    echo "~/.xinitrc juz istnieje, zrobilem backup do ~/.xinitrc.bak i nadpisalem."
    cp ~/.xinitrc ~/.xinitrc.bak
fi
cat > ~/.xinitrc <<'EOF'
#!/bin/sh
exec /usr/local/bin/dwm-session
EOF
chmod +x ~/.xinitrc

# 9. Ly display manager (zastepuje SDDM/GDM/LightDM)
echo "Instaluje i wlaczam Ly..."
sudo pacman -S --needed --noconfirm ly

for dm in sddm gdm lightdm lxdm plasmalogin; do
    if systemctl list-unit-files "$dm.service" 2>/dev/null | grep -q "$dm.service"; then
        sudo systemctl disable "$dm.service" || true
    fi
done

# nowsze Ly uzywa szablonu ly@ttyN.service, starsze ly.service
if systemctl list-unit-files 'ly@.service' 2>/dev/null | grep -q 'ly@.service'; then
    sudo systemctl disable getty@tty2.service || true
    sudo systemctl enable ly@tty2.service
else
    sudo systemctl disable getty@tty2.service || true
    sudo systemctl enable ly.service
fi

echo
echo "Gotowe. Zrestartuj PC, Ly pokaze sie na tty2."
echo "W Ly strzalkami lewo/prawo wybierasz sesje (dwm, Plasma itd.)."
echo "Gdyby cos nie dzialalo, Ctrl+Alt+F3 daje zwykly TTY."
