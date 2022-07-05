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
		Write-Host "Copying $($Repository.Name) to common build directory...";
		Foreach ($Element in Get-ChildItem -Path "$BuildDir") {
			Copy-Item -Path $Element.FullName -Destination "$CommonBuild" -Force -Recurse;
		}
	}
}

Foreach ($Artifact in Get-ChildItem -Path "./build" -Directory -Exclude "${ModpackName}/Centrifuge*")
{
	Write-Host "Adding $($Artifact.Name) to merged mod artifact...";

	Foreach ($Element in Get-ChildItem -Path "$Artifact") {
		Copy-Item -Path $Element.FullName -Destination "./modpack" -Force -Recurse;
	}
}

$MergedName = "All Mods";

Move-Item -Path "./modpack" -Destination "./build/${MergedName}";

Write-Host "Compressing combined mod artifact...";

Foreach ($Element in Get-ChildItem -Path "./build/${MergedName}") {
	Write-Host "Adding ${$Element.Name} to combined archive...";
	Compress-Archive -Path $Element.FullName -DestinationPath "./build/${MergedName}.zip" -Update -CompressionLevel Optimal;
}