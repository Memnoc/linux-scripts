# Enabling RGB Keyboard on Clevo NL5xNU (Arch Linux)

## Problem

Clevo NL5xNU laptops with RGB keyboards don't work out of the box on Linux. The standard tuxedo-drivers package has a compatibility whitelist that excludes barebones Clevo models.

## Solution

Use the `clevo-drivers-dkms-git` package from AUR, which has the compatibility check disabled.

## Prerequisites
```bash
sudo pacman -S linux-headers base-devel git dkms dmidecode
```

Install an AUR helper if you don't have one:
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
```

## Installation
```bash
yay -S clevo-drivers-dkms-git
```

Load the module:
```bash
sudo modprobe tuxedo_keyboard
```

Verify it worked:
```bash
ls /sys/class/leds/ | grep kbd
```

You should see `rgb:kbd_backlight`.

## Test brightness control
```bash
# Turn on (max brightness)
echo 255 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness

# Half brightness
echo 128 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness

# Low brightness
echo 50 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness
```

## Persist brightness on boot

Create a udev rule:
```bash
sudo nano /etc/udev/rules.d/99-kbd-backlight.rules
```

Add:
```
ACTION=="add", SUBSYSTEM=="leds", KERNEL=="rgb:kbd_backlight", ATTR{brightness}="255"
```

## Hyprland keybindings (optional)

Install brightnessctl:
```bash
sudo pacman -S brightnessctl
```

Add to `~/.config/hypr/hyprland.conf`:
```
bind = , XF86KbdBrightnessUp, exec, brightnessctl -d rgb:kbd_backlight set +25
bind = , XF86KbdBrightnessDown, exec, brightnessctl -d rgb:kbd_backlight set 25-
bind = , XF86KbdLightOnOff, exec, brightnessctl -d rgb:kbd_backlight set 0
```

Reload config:
```bash
hyprctl reload
```

## Notes

- Color cycling works via Fn keys out of the box
- The module loads automatically after DKMS installation
- Tested on NL5xNU with kernel 6.17.8
