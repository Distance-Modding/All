Import-Module -Name ./core.psm1;

./get-nuget.ps1;

Push-Location $(Get-Location);

$UpdatePackages = Get-Content ./nuget-update-packages.txt;

Foreach ($Solution in Get-ChildItem -Path "./repositories" -File -Recurse -Filter "*.sln") {
	Write-Output $Solution.Name;
	Set-Location $Solution.Directory;
	nuget restore $Solution;

	Foreach ($Package in $UpdatePackages) {
		nuget update $Solution -Id $Package
	}
}

Pop-Location;