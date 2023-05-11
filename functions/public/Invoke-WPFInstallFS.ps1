function Invoke-WPFInstallFS {
  Write-Host "Downloading FreshService installer..."
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/agent.msi"
  $out = "c:\temp\agent.msi"
  invoke-WebRequest -Uri $url -OutFile $out
  Start-Process msiexec.exe -Wait -ArgumentList "/i c:\temp\agent.msi"
  Write-Host "FreshService instalation finished!"
}