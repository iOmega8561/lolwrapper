#!/bin/bash
wrapper="`readlink -f "$0"`"
here="`dirname "$wrapper"`"

export WINEPREFIX="$here/prefix"

export PATH="$here/lutris-ge-lol/bin:$PATH"

if [ $1 ] && [ $1 == "launch" ]; then

    exec wine start /unix $WINEPREFIX/dosdevices/c:/Riot\ Games/Riot\ Client/RiotClientServices.exe --launch-product=league_of_legends --launch-patchline=live

elif [ $1 ] && [ $1 == "winecfg" ]; then

    exec winecfg

elif [ $1 ] && [ $1 == "delcache" ]; then

    rm -r $WINEPREFIX/dosdevices/c:/Riot\ Games/Riot\ Client/UX/GPUCache
    rm $WINEPREFIX/dosdevices/c:/Riot\ Games/League\ of\ Legends/LeagueClientUxRender.dxvk-cache
    rm $WINEPREFIX/dosdevices/c:/Riot\ Games/League\ of\ Legends/Game/League\ of\ Legends.dxvk-cache

fi