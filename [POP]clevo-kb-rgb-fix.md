# Clevo RGB Keyboard Backlight Control (Pop OS)

## System

- Laptop: Clevo NL5xNU (barebones)
- OS: Pop OS 24.04
- Kernel: 6.17.9-76061709-generic
- Desktop: COSMIC

## Status

Keyboard backlight works out of box. Pop OS kernel has built-in Clevo/Tuxedo support.
Device path: `/sys/class/leds/rgb:kbd_backlight`

## Installation

### 1. Install brightnessctl

```bash
sudo apt install brightnessctl
```

### 2. Set user permissions

```bash
sudo bash -c 'cat > /etc/udev/rules.d/90-backlight.rules << EOF
SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*:kbd_backlight", RUN+="/bin/chmod 0666 /sys/class/leds/%k/brightness"
EOF'
```

### 3. Set brightness persistence on boot

```bash
sudo bash -c 'cat > /etc/udev/rules.d/99-kbd-backlight.rules << EOF
ACTION=="add", SUBSYSTEM=="leds", KERNEL=="rgb:kbd_backlight", ATTR{brightness}="255"
EOF'
```

### 4. Reload udev

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### 5. Configure COSMIC keybindings

Settings → Keyboard → Custom Shortcuts → Add:

**Brightness Up:**

- Command: `brightnessctl -d rgb:kbd_backlight set +25`
- Bind to: CTRL+KP_Add (dedicated brightness key on kb)

**Brightness Down:**

- Command: `brightnessctl -d rgb:kbd_backlight set 25-`
- Bind to: CTRL+KP_Subtract (dedicated brightness key on kb)

## Manual Control

```bash
# Set brightness (0-255)
brightnessctl -d rgb:kbd_backlight set 255
brightnessctl -d rgb:kbd_backlight set 128
brightnessctl -d rgb:kbd_backlight set 0

# Increment/decrement
brightnessctl -d rgb:kbd_backlight set +25
brightnessctl -d rgb:kbd_backlight set 25-
```

## Notes

- Hardware Fn keys cycle RGB colors (firmware-level, bypass OS)
- Hardware Fn keys do NOT control brightness (no keycodes sent to OS)
- Brightness control requires custom keybindings or manual commands
- DKMS driver build not required - kernel support already present
- Brightness persists across reboots at maximum (255)
