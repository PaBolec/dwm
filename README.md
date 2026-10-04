# Moje Dotfiles (DWM Setup)

Minimalistyczne i wydajne środowisko oknowe oparte na **dwm** oraz **dwmblocks-async**. Przetestowane na dystrybucji Arch Linux. Zawiera gotowe skróty klawiszowe pod klawisz ALT , przezroczystość paska, przerwy między oknami oraz wyłączoną akcelerację myszy.

## Wymagane aplikacje (Zainstaluj przed uruchomieniem)

Przed odpaleniem instalatora upewnij się, że masz w systemie zainstalowane wszystkie niezbędne pakiety, narzędzia oraz czcionki potrzebne do poprawnego wyświetlania ikon:

```bash
sudo pacman -S git base-devel xorg-server xorg-xinit xorg-xset rootlessxorg xorg-xinput libx11 libxft libxinerama freetype2 ttf-font-awesome ttf-jetbrains-mono-nerd firefox discord spotify-launcher kitty fastfetch
```

*Dla przezroczystości i animacji okien zainstaluj swój kompozytor (np. `picom-pijulius` z AUR).*

## Instrukcja Instalacji (Na nowym PC)

Instalacja całego środowiska sprowadza się do pobrania tego repozytorium i uruchomienia gotowego skryptu, który automatycznie rozrzuci konfiguracje i skompiluje programy suckless:

```bash
# 1. Pobierz repozytorium dotfiles
git clone https://github.com ~/dots

# 2. Wejdź do folderu
cd ~/dots

# 3. Uruchom automatyczny instalator
./install.sh
```

## Po instalacji (~/.xinitrc)

Aby środowisko uruchamiało się poprawnie komendą `startx` razem z kompozytorem i paskiem statusu, Twój plik `~/.xinitrc` powinien kończyć się następującymi liniami:

```bash
# Uruchomienie kompozytora okien w tle
picom --backend glx &

# Uruchomienie paska statusu w tle
dwmblocks &

# Uruchomienie głównego menedżera okien (musi być na samym końcu!)
exec /usr/local/bin/dwm
```
