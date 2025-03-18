# desktop-gnome.ks
#
# Customization for GNOME desktop.

%include desktop-base.ks

%packages

# desktop
appeditor
gnome-extensions-app
gnome-shell-extension-appindicator
gnome-shell-extension-dash-to-dock
gnome-shell-extension-gpaste
gnome-tweaks

# networking
firewall-config
NetworkManager-l2tp-gnome
transmission-gtk

# multimedia
gthumb
gimp
inkscape
vlc
brasero

# productivity
libreoffice-draw
file-roller-nautilus

# mobile integration
gnome-shell-extension-gsconnect
nautilus-gsconnect

# tools
gparted
seahorse
seahorse-nautilus

%end

%post

echo ""
echo "POST desktop-gnome ************************************"
echo ""

# Set default fonts for GNOME environment
cat > /etc/dconf/db/local.d/01-remix-gnome-fonts << EOF_FONTS
# Remix global font settings

[org/gnome/Characters]
font='Noto Sans 50'

[org/gnome/desktop/interface]
document-font-name='Noto Sans 11'
font-name='Noto Sans 11'
monospace-font-name='Noto Sans Mono Condensed 11'

[org/gnome/desktop/wm/preferences]
titlebar-font='Noto Sans 11'

[org/gnome/settings-daemon/plugins/xsettings]
antialiasing='rgba'
hinting='full'
EOF_FONTS

# Enable dash-to-dock, app & places menus
cat > /etc/dconf/db/local.d/01-remix-gnome-extensions << EOF_EXTENSIONS
# Remix global gnome extensions

[org/gnome/shell]
enabled-extensions=['appindicatorsupport@rgcjonas.gmail.com', 'GPaste@gnome-shell-extensions.gnome.org', 'dash-to-dock@micxgx.gmail.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com']

EOF_EXTENSIONS

# Update configuration
dbus-launch --exit-with-session dconf update

cat > /usr/local/sbin/firstboot_gnome.sh << 'GNOME_EOF'
#!/bin/bash
dnf remove -y gnome-initial-setup gnome-tour
GNOME_EOF
chmod +x /usr/local/sbin/firstboot_gnome.sh

%end
