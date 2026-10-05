# Moje Dotfiles (DWM Setup)

Minimalistyczne i wydajne środowisko oknowe oparte na **dwm** oraz **dwmblocks-async**. Przetestowane na Arch Linux / CachyOS. Zawiera gotowe skróty klawiszowe pod klawisz ALT, przezroczystość paska, przerwy między oknami oraz wyłączoną akcelerację myszy.

> dwm działa tylko na X11, więc instalator instaluje Xorg. Twój Wayland (np. Plasma) zostaje nietknięty, dwm startuje jako osobna sesja.

## Instalacja (na nowym PC)

```bash
git clone https://github.com/PaBolec/dwm.git ~/dots
cd dwm
chmod +x install.sh
./install.sh
```

Nie odpalaj jako root, skrypt sam użyje `sudo`. Wymaga Arch Linux lub pochodnej (pacman).

## Co robi instalator

1. Instaluje pakiety: `git base-devel xorg-server xorg-xinit xorg-xset xorg-xinput libx11 libxft libxinerama libxcb xcb-util freetype2 ttf-font-awesome ttf-jetbrains-mono-nerd firefox discord spotify-launcher kitty fastfetch`
2. Instaluje `yay` (z repo na CachyOS, z AUR na zwykłym Archu)
3. Instaluje `picom-pijulius-git` przez yay (fallback na zwykły `picom`)
4. Kopiuje configi `picom`, `kitty`, `fastfetch` do `~/.config`
5. Wrzuca `50-mouse-acceleration.conf` do `/etc/X11/xorg.conf.d/` (mysz bez akceleracji)
6. Kompiluje i instaluje `dwm` oraz `dwmblocks`
7. Tworzy `/usr/local/bin/dwm-session` (picom + dwmblocks + dwm) i wpis sesji `dwm`
8. Tworzy `~/.xinitrc` (stary zapisuje jako `~/.xinitrc.bak`)
9. Instaluje i włącza display manager **Ly** (wyłącza SDDM/GDM/LightDM jeśli były)

## Uruchamianie

Po restarcie Ly pojawi się na tty2. Strzałkami lewo/prawo wybierasz sesję (`dwm`, Plasma itd.).

Bez display managera możesz też odpalić dwm z TTY komendą:

```bash
startx
```

Gdyby Ly nie wstał, `Ctrl+Alt+F3` daje zwykły TTY.

## Ręczne ustawienia

Jeśli wolisz własny `~/.xinitrc`, powinien kończyć się tak:

```bash
picom --backend glx &
dwmblocks &
exec /usr/local/bin/dwm   # musi być na samym końcu
```
