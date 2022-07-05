Import-Module -Name ./core.psm1;

Install-BuildTools;
$Project = "$(Get-Location)/Build.proj";

Push-Location .\repositories;
& msbuild $Project -m -maxcpucount:4 2>&1;
Pop-Location;