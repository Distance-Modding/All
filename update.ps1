Import-Module -Name ./core.psm1;
Install-BuildTools;

Push-Location $(Get-Location);

$PackageList = Get-Content ./nuget-update-packages.txt;

Foreach ($Solution in Get-ChildItem -Path "./repositories" -File -Recurse -Filter "*.sln") {
	Write-Host "Updating dependencies for $($Solution.Name)...";
	Set-Location $Solution.Directory;
	
	# NuGet verbosity levels https://github.com/NuGet/Home/issues/8089#issuecomment-940929461
	& nuget restore $Solution -Verbosity detailed 2>&1;

	Foreach ($Package in $PackageList) {
		Write-Host "- ${Package}";
		& nuget update $Solution -Id $Package -Verbosity detailed 2>&1;
	}
}

Pop-Location;