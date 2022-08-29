#!/bin/bash

hash chdman 2>/dev/null || { echo >&2 "This requires chdman. Please install it. Debian/ubuntu: apt install mame-tools. Redhat: yum install mame-tools. SUSE: zypper install mame-tools. Arch: pacman -S mame-tools."; exit 1; }

#Get Params
while getopts i:o: option
 do
 case "${option}"
 in
 i) IN=${OPTARG};;
 o) OUT=${OPTARG};;
 esac
done

echo "in: $IN"
echo "out: $OUT"

if [ ! -f "$IN" ] && [ ! -d "$IN" ]; then
    echo "$IN does not exist. Please check for typos and permissions"
    exit 1
fi

if [[ ! -e "$OUT" ]]; then
    mkdir "$OUT"
elif [[ ! -d "$OUT" ]]; then
    echo "$OUT already exists but is not a directory" 1>&2
    exit 1
fi

function Extract-Rar {
    #1 is rar file with full path $2 is working folder.
    hash unrar 2>/dev/null || { echo >&2 "This requires unrar. Please install it. Debian/ubuntu: apt install unrar. Redhat: yum install unrar. SUSE: zypper install unrar. Arch: pacman -S unrar"; exit 1; }
    if [ ! -d "$2" ]; then
        mkdir "$2"
    fi
    unrar e "$1" "$2"
    Route-File "$2"
}

function Extract-Zip {
    #1 is rar file with full path $2 is working folder.
    hash unzip 2>/dev/null || { echo >&2 "This requires unzip. Please install it. Debian/ubuntu: apt install unzip. Redhat: yum install unzip. SUSE: zypper install unzip. Arch: pacman -S unzip"; exit 1; }
    unzip "$1" -d "$2"
    Route-File "$2"
}

function Got-Folder {
    #$1 is the folder
    ls "$1" | while read LINE
    do
    #Route-File -file "$folder\$file" -out $out
        Route-File "$1/$LINE"
    done
}

function Got-File {
    #$1 is the file with path 
    local BASENAME="$(basename "$1")"
    local FILENOEXT="${BASENAME%.*}"
    local EXT="${BASENAME##*.}"
    local WORKDIRECTORY=$(echo "$PWD/workfolder")
    local EXTLOWER="${EXT,,}"

    if [ "$EXTLOWER" = 'rar' ]; then
        Extract-Rar "$1" "$WORKDIRECTORY"
        Route-File "$WORKDIRECTORY" 
    elif [ "$EXTLOWER" = "zip" ]; then
        echo "unzip"
        unzip "$1" -d "$WORKDIRECTORY"
        #foreach ($e in $extractedfiles) {
        #    if ($e -is [string]) {
        #        Route-File -file "$workfolder\$e" -out $out
        #    }
        Route-File "$WORKDIRECTORY"       
    elif [ "$EXTLOWER" = "cue" ]; then
        echo "GOT A CUE"
        echo "chdman createcd -i "$1"  -o $OUT/$FILENOEXT.chd -f"
        chdman createcd -i "$1"  -o "$OUT/$FILENOEXT.chd" -f
        rm -rf "$WORKDIRECTORY"
    else
        echo "Ignoring $1"
    fi
}

function Route-File {
    #$1 is the file/folder being routed.
    if [ -f "$1" ]; then
        Got-File "$1"
        return
    elif [ -d "$1" ]; then
        Got-Folder "$1"
        return
    fi
    echo "$1 is not a file or folder. Skipping it."
}

#This is main()
Route-File "$IN"