Import-Module -Name ./core.psm1;

# Reset download folder if it exists
Remove-Folder("repositories");
New-Folder("repositories");

Foreach ($RepositoryName in Get-Content .\repositories.txt) {
    $RepositoryUrl = "https://github.com/Distance-Modding/${RepositoryName}.git";
    $Destination = "./repositories/${RepositoryName}";
    
    # Clone mod repository in repositories/
    git clone --recurse-submodules -j8 $RepositoryUrl $Destination;
}