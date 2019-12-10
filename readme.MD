# CueToChd

This script will assist you in converting many .CUE / BIN files into .CHD files for MAME or Libretro use. I have tested with my Sega CD backups. But this should work with any Saturn, PC Engine / TG16, Neo Geo CD, Dreamcast, etc backup. You may use this to convert one file, or many folders of files. Supports the actual raw .CUE .BIN files as well as zip, 7z and rar archives.

## Getting Started

Once you have this repository on your computer, open PowerShell, enter the repository root folder and run:
.\cuetochd.ps1 -in "Where your .CUE files are" -out "Where you want your CHD files to be saved"

### Windows
Windows script comes with all the binaries you need. No need to install anything else.

parameters:
-in is your input file or folder. It can be a folder, .cue file or an archive. Recommended enclosing with double quotes.
-out is the folder that you want your .CHDs to be saved to. Recommended enclosing with double quotes.

Example 1: Convert a whole folder
```
C:\src\CueToChd> .\cuetochd.ps1 -in "D:\backups\Sega CD" -out "D:\CHD\Sega CD\CHD"
```
Example 2: Convert one file that is archived with rar.
```
C:\src\CueToChd> .\cuetochd.ps1 -in "D:\backups\Sega CD\MyGame.rar" -out "D:\CHD\Sega CD"
```
Example 3: Convert a folder but use your temp folder as the output folder.
```
C:\src\CueToChd> .\cuetochd.ps1 -in "D:\backups\Sega CD" -out $env:TEMP
```

### Linux
No binaries are included with linux. You must install unrar, mame-tools and unzip.
Linux "only" supports rar and zip archives. I didn't test with 7z, gz, etc.

parameters:
-i is your input file or folder. It can be a folder, .cue file or an archive. Recommended enclosing with single quotes.
-o is the folder that you want your .CHDs to be saved to. Recommended enclosing with single quotes.

Example 1: Convert a whole folder
```
#/src/cuetochd> ./cuetochd.ps1 -i '/mnt/roms/Sega CD' -o 'D:\CHD\Sega CD/CHD'
```
Example 2: Convert one file that is archived with rar.
```
#/src/cuetochd> ./cuetochd.ps1 -i '/mnt/roms/Sega CD/MyGame.rar' -o 'D:\CHD\Sega CD/CHD'
```
### All OSes
This script must be run from the root of it's own directory.

The quotes are necessary because of the spaces in the folder or file names.

It's recommended that the in and out folders are different.

Don't put forward slashes at the end of your folder or file names. It will probably still work. But ...

It should work. If not, let me know. Be nice. Remember, they are only games.

### Prerequisites

This only works with 64bit operating systems because it's packaged with the 64bit version of 7z.exe and chdman.exe.

I haven't tested every possible scenario. There might be a few bugs here. Works fine for me though.

### Folder Structure

cuetochd.ps1 - The PowerShell script.
cuetochd.sh - The bash script.
readme.MD - This file.
workfolder\ - Where archives are temporarily extracted. They are deleted when the CHD is created.
bin\ - Where chdman.exe and 7z.exe are.

## Built With

* [VSCode](https://code.visualstudio.com/) - My IDE
* [7zip](https://www.7-zip.org/) - To uncompress archives
* [chdman](https://github.com/mamedev/mame/blob/master/src/tools/chdman.cpp) - MAME tool to convert formats.


## License

This project uses the same license as 7zip and updated license that MAME uses. This seemed like the simplest thing to do? Regardless, if you use this code, give this repository create, please. - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* MAME
* Libretro
* 7zip
