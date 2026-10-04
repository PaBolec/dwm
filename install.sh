#!/bin/bash
echo "Uruchamiam automatyczna instalacje Twojego srodowiska..."

# 1. Kopiowanie konfiguracji do ~/.config
mkdir -p ~/.config
echo "Kopiuje pliki konfiguracyjne (picom, kitty, fastfetch)..."
cp -r config/picom ~/.config/
cp -r config/kitty ~/.config/
cp -r config/fastfetch ~/.config/

# 2. Kopiowanie konfiguracji myszy (czulosc i brak akceleracji)
echo "Konfiguruje czysta czulosc myszy (profil Flat)..."
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp 50-mouse-acceleration.conf /etc/X11/xorg.conf.d/

# 3. Kompilacja i instalacja DWM
echo "Kompiluje i instaluje DWM..."
cd dwm
sudo make clean install
cd ..

# 4. Kompilacja i instalacja DWMBLOCKS
echo "Kompiluje i instaluje DWMBLOCKS..."
cd dwmblocks
sudo make clean install
cd ..

echo "Wszystko gotowe, chud'dzie! Pamietaj o dodaniu 'dwmblocks &' i 'picom &' do swojego ~/.xinitrc"

