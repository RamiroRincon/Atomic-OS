#!/usr/bin/env bash
set -ouex pipefail

echo "Applying custom system defaults for KDE Plasma..."

# ----------------------------------
# 1. FIX POWER PROFILE (System-Wide)
# ----------------------------------
# Kept identical as this is a system-level service (Tuned)
mkdir -p /etc/tuned
echo "throughput-performance" > /etc/tuned/active_profile

# ----------------------------------
# 2. KDE GLOBAL DEFAULTS (kdeglobals)
# ----------------------------------
# Controls Theme (Dark Mode), Fonts, and Icons
mkdir -p /etc/xdg
cat <<EOF > /etc/xdg/kdeglobals
[General]
ColorScheme=BreezeDark
font=SF Pro Display,11,-1,5,50,0,0,0,0,0
fixed=SF Mono,10,-1,5,50,0,0,0,0,0
smallestReadableFont=SF Pro Text,8,-1,5,50,0,0,0,0,0
toolBarFont=SF Pro Display,10,-1,5,50,0,0,0,0,0
menuFont=SF Pro Display,10,-1,5,50,0,0,0,0,0
windowTitleFont=SF Pro Display,11,-1,5,75,0,0,0,0,0

[KDE]
ShowNotificationsOnExternalScreens=true
EOF

# ----------------------------------
# 3. WINDOW MANAGER (kwinrc)
# ----------------------------------
# Controls Workspaces, Window Buttons, and Placement
cat <<EOF > /etc/xdg/kwinrc
[Desktops]
Number=2
Rows=1

[Windows]
CenterByDefaultForce=true

[org.kde.kdecoration2]
ButtonsOnLeft=XIA
ButtonsOnRight=
EOF
# Note: IAX in KDE syntax stands for: I(Min), A(Max), X(Close)

# ----------------------------------
# 4. FILE MANAGER (dolphinrc)
# ----------------------------------
# Replaces Nautilus settings
cat <<EOF > /etc/xdg/dolphinrc
[DetailsMode]
PreviewSize=16

[MainWindow]
InvertSelection=false

[Settings]
DefaultViewMode=1
# 1 = List View, 0 = Icons, 2 = Compact
EOF

# ----------------------------------
# 5. INPUT DEVICES (kcminputrc)
# ----------------------------------
# Controls Mouse & Touchpad
cat <<EOF > /etc/xdg/kcminputrc
[Mouse]
AccelerationProfile=1
# 1 = Flat profile
NaturalScroll=false

[Libinput][1267][12377][ELAN0501:00 04F3:3059 Touchpad]
TapToClick=true
EOF

# ----------------------------------
# 6. EMOJI FONT CONFIGURATION
# ----------------------------------
# Kept identical as fontconfig is desktop-agnostic
echo "Configuring Apple Color Emoji as system default..."
mkdir -p /etc/fonts/local.conf.d

cat <<EOF > /etc/fonts/local.conf.d/99-apple-emoji.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="pattern">
    <test qual="any" name="family"><string>emoji</string></test>
    <edit name="family" mode="assign" binding="same"><string>Apple Color Emoji</string></edit>
  </match>
</fontconfig>
EOF

# ----------------------------------
# 7. CLEANUP & PERMISSIONS
# ----------------------------------
# Ensure all files in /etc/xdg are readable
chmod -R 644 /etc/xdg/*