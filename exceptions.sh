#!/usr/bin/env bash
# Useful variables:
# ${gameName}           Name of the game as it appears on GOG.com
# ${tmpdir}/${gameName} Where the game files got extracted, before install
# ${gameID}             Each product has an ID number, not usually visible to the end user
# ${romdir}             Folder that has rom folders for different emulators
# ${dosboxdir}          ${romdir}/pc
# ${scummvmdir}         ${romdir}/scummvm


exceptionList=(
1435827232 #Ultimate DOOM, The
1207658753 #Teenagent
)

1435827232_exception() { #Ultimate DOOM, The
    sudo apt install zip
    mkdir -p "${romdir}/ports/doom"
    cp "${tmpdir}/${gameName}/DOOM.WAD" "${romdir}/ports/doom/"
    cat <<'_EOF_' >> "${romdir}/ports/Ultimate Doom.sh"
#!/usr/bin/env bash
# This file is borrowed from https://raw.githubusercontent.com/crcerror/launch-doom-packs-RP/6479af76bf7909711245763a1c7e707f852d56b2/DOOM%20-%201.sh
path="/home/pi/RetroPie/roms/ports/doom"
wadfile="DOOM.WAD"
if ! [[ -e "${path}/$wadfile" ]]; then
echo "Error! ${path}/$wadfile not found!"
echo "Please resolve problem in script or install file!"
sleep 10
exit
fi
if [[ -e "${path}/savegames_${wadfile%.*}.zip" ]]; then
unzip -qq -o "${path}/savegames_${wadfile%.*}.zip" -d "$path"
fi
"/opt/retropie/supplementary/runcommand/runcommand.sh" 0 _PORT_ "doom" "${path}/$wadfile"
cd "$path" && zip -mj "savegames_${wadfile%.*}.zip" prbmsav?.dsg
_EOF_
    chmod +x "${romdir}/ports/Ultimate Doom.sh"
    if dialog --backtitle "${title}" --yesno "${gameName} has been installed to ${romdir}/ports/doom.\nSelect yes to build libretro PrBoom, to use as the engine.\nSelect No to skip build." 22 77; then
        sudo "${HOME}/RetroPie-Setup/retropie_packages.sh" lr-prboom sources
        sudo "${HOME}/RetroPie-Setup/retropie_packages.sh" lr-prboom build
        sudo "${HOME}/RetroPie-Setup/retropie_packages.sh" lr-prboom install
    fi
    dialog --backtitle "${title}" --msgbox "${gameName} is installed to work with PrBoom, with seperated savgame.\n\nMake sure to enable lr-prboom as your DOOM engine, in the runcommand." 22 77
}

1207658753_exception() { #Teenagent
    mv -f "${tmpdir}/${gameName}" "${scummvmdir}/${gameName}.svm"
    echo "teenagent" > "${scummvmdir}/${gameName}.svm/teenagent.svm"
    dialog \
        --backtitle "${title}" \
        --msgbox "${gameName} Has been installed to ${scummvmdir}\n\nYou need to open up ScummVM and add the game manually." \
        22 77
}