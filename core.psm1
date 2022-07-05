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