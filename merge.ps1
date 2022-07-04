Import-Module -Name ./core.psm1;

# Reset build folders if it exists
Remove-Folder("build");
Remove-Folder("modpack");
New-Folder("build");
New-Folder("modpack");

$CommonBuild = "$(Get-Location)/build";

Foreach ($Repository in Get-ChildItem -Path "./repositories" -Directory)
{
	$BuildDir = "$($Repository.FullName)\Build";

	If (Test-Path -Path $BuildDir) {
        Get-ChildItem -Path "$BuildDir" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination "$CommonBuild" -Force -Recurse;
        }
    }
}


Foreach ($Artifact in Get-ChildItem -Path "./build" -Directory -Exclude "${ModpackName}/Centrifuge*")
{
	Write-Output $Artifact;

    Get-ChildItem -Path "$Artifact" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "./modpack" -Force -Recurse;
    }
}

$MergedName = "Distance All Mods";

Move-Item -Path "./modpack" -Destination "./build/${MergedName}";

Get-ChildItem -Path "./build/${MergedName}" | ForEach-Object {
    Compress-Archive -Path $_.FullName -DestinationPath "./build/${MergedName}.zip" -Update -CompressionLevel Optimal;
}