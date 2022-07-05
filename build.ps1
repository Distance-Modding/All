Import-Module -Name ./core.psm1;

Function Install-PSModule {
	Param (
		[String] $Name
	)
	If (-Not $(Get-Module -ListAvailable -Name PowerShellGet)) {
		Write-Host "Setting up module PowerShellGet...";
		Find-Module -Name PowerShellGet | Install-Module;
	}

	If (-Not $(Get-Module -ListAvailable -Name $Name)) {
		Write-Host "Installing module $Name...";
		Install-Module $Name -Scope CurrentUser -Force;
	}
	Else {
		Write-Host "Module $Name already Installed";
	}
}

# Install VSSetup module
Install-PSModule VSSetup;

# Install Build utils command
Install-PSModule BuildUtils;

./get-nuget.ps1;

# ----- RUN BUILD -----

Set-Alias msbuild $(Get-LatestMsbuildLocation);

$Project = "$(Get-Location)/Build.proj";

Push-Location .\repositories;
& msbuild $Project -m -maxcpucount:4 2>&1;
Pop-Location;