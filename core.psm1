$PSDefaultParameterValues['*:Verbose'] = $true;
Function Remove-Folder {
	Param (
		[String] $FolderName
	)
	If (Test-Path $FolderName) {
		Remove-Item $FolderName -Recurse -Force | Out-Null;
	}
}
Export-ModuleMember -Function Remove-Folder;

Function New-Folder {
	Param (
		[String] $FolderName
	)
	If (-Not (Test-Path $FolderName)) {
		New-Item -Path . -Name $FolderName -ItemType "directory" | Out-Null;
	}
}
Export-ModuleMember -Function New-Folder;

Function Test-CommandExists {
	Param (
		[String]$command
	)
	$oldPreference = $ErrorActionPreference
	$ErrorActionPreference = 'stop';

	Try {
		If (Get-Command $command) {
			Return $True;
		}
	}
	Catch {
		Return $False;
	}
	Finally {
		$ErrorActionPreference = $oldPreference;
	}
}
Export-ModuleMember -Function Test-CommandExists;

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
Export-ModuleMember -Function Install-PSModule;

Function Get-NuGet {
	Param ()
	If (-Not (Test-CommandExists nuget)) {
		If (-Not (Test-Path -Path "./nuget.exe" -PathType Leaf)) {
			$nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe";
			Invoke-WebRequest $nugetUrl -OutFile $destination;
		}
		$destination = "$(get-Location)/nuget.exe";
		Set-Alias nuget "$destination" -Scope Global -Force;
	}
}
Export-ModuleMember -Function Get-NuGet;

Function Install-BuildTools {
	Param ()
	# Install VSSetup module
	Install-PSModule VSSetup;

	# Install Build utils command
	Install-PSModule BuildUtils;

	Set-Alias msbuild $(Get-LatestMsbuildLocation) -Scope Global -Force;
	Get-NuGet;
}
Export-ModuleMember -Function Install-BuildTools;