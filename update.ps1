Import-Module -Name ./core.psm1;

Push-Location $(Get-Location);

# Install VSSetup module
Install-PSModule VSSetup;

# Install Build utils command
Install-PSModule BuildUtils;

./get-nuget.ps1;

Foreach ($Solution in Get-ChildItem -Path "./repositories" -File -Recurse -Filter "*.sln") {
	Write-Output "Updating dependencies for $Solution.Name...";
	Set-Location $Solution.Directory;

	# NuGet verbosity levels https://github.com/NuGet/Home/issues/8089#issuecomment-940929461
	& nuget restore $Solution -Verbosity detailed 2>&1;

	Foreach ($Package in Get-Content ./nuget-update-packages.txt) {
		Write-Host "- ${Package}";
		& nuget update $Solution -Id $Package -Verbosity detailed 2>&1;
	}
}

Pop-Location;