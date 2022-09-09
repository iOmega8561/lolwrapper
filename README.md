# LoL Wrapper
A simple setup wrapper for League of Legends. This interactive script uses zenity, and will automatically retrieve the correct wine and dxvk versions from their urls. It will also create desktop shortcuts.
## Note
For the League of Legends to work, obviously the correct dependencies need to be installed on the host system. Wine x86 libraries and Vulkan drivers are a must. For Arch Linux users, the following packages should do the trick.

lib32-freetype lib32-gnutls lib32-libxrandr lib32-mesa-utils lib32-pipewire are required to make wine actually work and display something

samba is required for ntlm auth
for some reason gnu-netcat also needs to be installed

These are essentialy video drivers
for amd cards install vulkan-radeon and lib32-vulkan-radeon
for nvidia cards install nvidia (or nvidia-dkms) and lib32-nvidia-utils
for intel igpu install vulkan-inter and lib32-vulkan-intel