Function Remove-Folder {
    Param (
        [String] $FolderName
    )
    If (Test-Path $FolderName) {
        Remove-Item $FolderName -Recurse -Force | Out-Null;
    }
}

Function New-Folder {
    Param (
        [String] $FolderName
    )
    If (-Not (Test-Path $FolderName)) {
        New-Item -Path . -Name $FolderName -ItemType "directory" | Out-Null;
    }
}

Export-ModuleMember -Function Remove-Folder;
Export-ModuleMember -Function New-Folder;