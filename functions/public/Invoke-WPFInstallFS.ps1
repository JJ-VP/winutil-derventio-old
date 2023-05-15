function Invoke-WPFInstallFS {

  $DHT = "c:\.DHT"
  if (!(Test-Path -Path $DHT)) {
    Write-Host "Creating DHT Folder..."
    $DHTFolder = New-Item -Path $DHT -ItemType Directory
    $DHTFolder.attributes='Hidden'
    Write-Host "Folder created..."
  }

  Write-Host "Downloading FreshService installer..."
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/agent.msi"
  $out = "$DHT\agent.msi"
  invoke-WebRequest -Uri $url -OutFile $out

  Write-Host "Installing FreshService..."
  Start-Process msiexec.exe -Wait -ArgumentList "/i `"$DHT\agent.msi`" /qn"

  Write-Host "FreshService instalation finished!"
}