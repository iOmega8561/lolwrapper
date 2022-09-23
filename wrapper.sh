#!/bin/bash
wrapper="`readlink -f "$0"`"
here="`dirname "$wrapper"`"

####################################################################
#FUNCTIONS

function shortcuts {
	
	mkdir -p $HOME/.local/share/applications/league
	
	tee $HOME/.local/share/applications/league/client.desktop <<- EOF
		[Desktop Entry]
		Name=League of Legends
		Exec=env WINEPREFIX=$WINEPREFIX $gamepath/lutris-ge-lol/bin/wine start /unix $WINEPREFIX/dosdevices/c:/Riot\ Games/Riot\ Client/RiotClientServices.exe --launch-product=league_of_legends --launch-patchline=live
		Type=Application
		StartupNotify=true
		Icon=$here/icons/client.png
		StartupWMClass=leagueclientux.exe
		Actions=winecfg
		
		[Desktop Action winecfg]
		Name=Configure
		Name[it]=Configura
		Exec=env WINEPREFIX=$WINEPREFIX $gamepath/lutris-ge-lol/bin/winecfg
	EOF
	
	tee $HOME/.local/share/applications/league/game.desktop <<- EOF
		[Desktop Entry]
		Name=League of Legends
		Exec=env WINEPREFIX=$WINEPREFIX $gamepath/lutris-ge-lol/bin/wine start /unix $WINEPREFIX/dosdevices/c:/Riot\ Games/League\ of\ Legends/League\ of \Legends.exe
		Type=Application
		StartupNotify=true
		Icon=$here/icons/game.png
		NoDisplay=true
		StartupWMClass=league of legends.exe
	EOF
}

####################################################################
#MAIN LOGIC

zenity --question \
	--no-wrap \
	--name="League of Legends" \
	--title="League of Legends" \
	--text="Do you really want to install League of Legends?"

if [ "$?" = 1 ]; then
	exit
fi

zenity --warning \
	--name="League of Legends" \
	--title="League of Legends" \
	--text="Make sure to select an empty folder or create a new one, everything will be deleted otherwise. Install wine dependencies and x86 vulkan libraries, otherwise the game will just crash."

gamepath=$(zenity --file-selection --directory --save --name="League of Legends")

if ! [ -d "$gamepath" ]; then
	exit
fi

(

#######################################################################
#CLEAN GAME PATH

echo "10" ; sleep 1
echo "# Deleting everything under $gamepath"
rm -fr $gamepath
mkdir $gamepath
sleep 1

#######################################################################
#DOWNLOAD WINE

echo "20" ; sleep 1
echo "# Retrieving wine lutris-ge-lol-7.0-5"
$here/bin/wget https://github.com/GloriousEggroll/wine-ge-custom/releases/download/7.0-GE-5-LoL/wine-lutris-ge-lol-7.0-5-x86_64.tar.xz -O $gamepath/lutris-ge-lol.tar.xz
cd $gamepath
$here/bin/tar -Jxvf lutris-ge-lol.tar.xz
rm lutris-ge-lol.tar.xz
mv lutris-ge-lol-7.0-5-x86_64 lutris-ge-lol
sleep 3

#######################################################################
#DOWNLOAD DXVK

echo "20" ; sleep 1
echo "# Retrieving dxvk runtime libraries"
$here/bin/wget https://github.com/doitsujin/dxvk/releases/download/v1.10.3/dxvk-1.10.3.tar.gz -O $gamepath/dxvk.tar.gz
cd $gamepath
$here/bin/tar -xvf dxvk.tar.gz
rm dxvk.tar.gz
mv dxvk-1.10.3 dxvk
sleep 3

#######################################################################
#SET ENV

echo "40" ; sleep 1
echo "# Setting environment variables\n"
export WINEPREFIX="$gamepath/prefix"
export WINEARCH="win64"
export PATH="$gamepath/lutris-ge-lol/bin:$PATH"
sleep 2

#######################################################################
#WINE PREFIX

echo "50" ; sleep 1
echo "# Creating wine prefix...\n"
wineboot
sleep 10

echo "60" ; sleep 1
echo "# Installing dxvk libraries" ; sleep 1
$gamepath/dxvk/setup_dxvk.sh install
sleep 1

#######################################################################
#GAME INSTALLER

echo "75" ; sleep 1
echo "# Retrieving League of Legends installer\n"
$here/bin/wget --directory-prefix=$gamepath https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.euw.exe
sleep 1

echo "90" ; sleep 1
echo "# Creating desktop shortcuts\n"
shortcuts
sleep 1

echo "100" ; sleep 1
echo "# Started League of Legends installer"
wine start /unix $gamepath/live.euw.exe
sleep 1

) |
zenity --progress \
	--name="League of Legends" \
	--title="League of Legends" \
	--text="Starting setup" \
	--percentage=0

if [ "$?" = -1 ] ; then
    zenity --error \
        --text="Installation aborted"
fi
