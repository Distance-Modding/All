If (-Not (Test-Path -Path "./nuget.exe" -PathType Leaf)) {
    $nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
    $destination = "$(get-Location)/nuget.exe"
    Invoke-WebRequest $nugetUrl -OutFile $destination
    Set-Alias nuget $destination -Scope Global -Force
}