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
	Else
	{
		Write-Host "Module $Name already Installed";
	}
}

# Install VSSetup module
Install-PSModule VSSetup;

# Install Build utils command
Install-PSModule BuildUtils;

# ----- RUN BUILD -----

$MSBuild = Get-LatestMsbuildLocation
Set-Alias msbuild $MSBuild

$Project = "$(Get-Location)/Build.proj";

Push-Location .\repositories;
msbuild $Project -m -maxcpucount:4;
Pop-Location;