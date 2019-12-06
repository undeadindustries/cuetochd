<# Created by: UndeadIndustries.
   https://github.com/undeadindustries
   License: GNU Lesser General Public License v3.0
  use  $env:TEMP if you want to use your Windows temp folder.
#>
Param([string]$in = "", [string]$out = "")
Write-Host "In: $in"
Write-Host "Out: $out"

#Check if the input exists.
If (!(Test-Path -Path $in)) {
    Write-Host "Exiting: $in does not exist."
    Exit 1
}

#Check if the output exists. Attempt to create it.
If (!(Test-Path -Path $out)) {
    If (!(New-Item -ItemType directory -Path $out)) {
        Write-Host "Exiting: $out does not exist."
        Exit 1
    }
}

#Check if cdman is there.
If (!(Test-Path ((Get-Location).ToString() + '\bin\chdman.exe') )) {
    Write-Host "Can't find chdman. Be sure you are running this script from it's root folder."
    Exit 1
} 

#Decompress archive and return the resulting files.
Function ExtractFiles {
    Param([string]$archive, [string]$out)
    If (!(Test-Path ((Get-Location).ToString() + '\bin\7z.exe'))) {
        Write-Host "Can't find 7zip. Be sure you are running this script from it's root folder."
        Exit 0
    }

    $7zip = new-object System.Diagnostics.Process
    $7zip.StartInfo.Filename = (Get-Location).ToString() + '\bin\7z.exe'
    Write-Host "Running 7zip  e ""$archive"" -o""$out"" -y"
    $7zip.StartInfo.Arguments = " e ""$archive"" -o""$out"" -y"
    $7zip.StartInfo.UseShellExecute = $false
    $7zip.start()
    $7zip.WaitForExit()

    Return (Get-ChildItem -Path $out -Name)
}

#Convert a CUE to CHD.
Function CUEtoCHD {
    Param([string]$cuefile, [string]$out)
    $cuefilenopath = Split-Path $cuefile -leaf
    $cuefilebase = $cuefilenopath.Substring(0, $cuefilenopath.Length - 4)
    $chdman = new-object System.Diagnostics.Process
    $chdman.StartInfo.Filename = (Get-Location).ToString() + '\bin\chdman.exe'
    Write-Host "Running chdman.exe  createcd -i ""$cuefile""  -o ""$out\$cuefilebase.chd"" -f"
    $chdman.StartInfo.Arguments = " createcd -i ""$cuefile""  -o ""$out\$cuefilebase.chd"" -f"
    $chdman.StartInfo.UseShellExecute = $false
    $chdman.start()
    $chdman.WaitForExit()
}

#Spin through all the files in a folder then route them.
Function Got-Folder {
    Param([string]$folder, [string]$out)
    $files = Get-ChildItem -Path $folder -Name
    Foreach ($file In $files) {
        Route-File -file "$folder\$file" -out $out
    }
}

#Decide what to do with each file type.
Function Got-File {
    Param([string]$file, [string]$out)
    $fileObject = Get-Item $file
    $filenoextension = $fileObject.BaseName
    $ext = $fileObject.Extension
    $workfolder = ((Get-Location).ToString() + '\workfolder\' + $filenoextension)
    #If archive
    If ($ext.ToLower() -eq ".rar" -OR $ext.ToLower() -eq ".zip" -OR $ext.ToLower() -eq ".7z") {
        $extractedfiles = ExtractFiles -archive $file  -out $workfolder
        foreach ($e in $extractedfiles) {
            if ($e -is [string]) {
                Route-File -file "$workfolder\$e" -out $out
            }
        }
    }
    ElseIf ($ext.ToLower() -eq ".cue") {
        CUEtoCHD -cuefile "$workfolder\$e" -out $out
    }
    ElseIf ($ext.ToLower() -eq ".bin") {
        #Skip bin files.
    }
    Else {
        Write-Host "Skipping $file. We don't know what to do with that type."
    }
}

#If folder, send to folder function. If file, send to file function.
Function Route-File {
    Param([string]$file, [string]$out)
    If (Test-Path -Path $file -PathType Container) {
        Got-Folder -folder $file -out $out
    }
    Else { # This should probably be an ElseIf (is file)...
        Got-File -file $file -out $out
    }
}

#Consider this as Main()
Route-File -file $in -out $out
Exit 0
