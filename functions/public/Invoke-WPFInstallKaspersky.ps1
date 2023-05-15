function Invoke-WPFInstallKaspersky {

  $DHT = "c:\.DHT"
  if (!(Test-Path -Path $DHT)) {
    Write-Host "Creating DHT Folder..."
    $DHTFolder = New-Item -Path $DHT -ItemType Directory
    $DHTFolder.attributes='Hidden'
    Write-Host "Folder created..."
  }

  Write-Host "Downloading Kaspersky installer..."
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/kes_win.msi"
  $out = "$DHT\kes_win.msi"
  invoke-WebRequest -Uri $url -OutFile $out

  Write-Host "Downloading required files..."
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/bases.cab"
  $out = "$DHT\bases.cab"
  invoke-WebRequest -Uri $url -OutFile $out
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/kes.cab"
  $out = "$DHT\kes.cab"
  invoke-WebRequest -Uri $url -OutFile $out
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/aes56.cab"
  $out = "$DHT\aes56.cab"
  invoke-WebRequest -Uri $url -OutFile $out

  Write-Host "Installing..."
  Start-Process msiexec.exe -Wait -ArgumentList "/a `"$DHT\kes_win.msi`" EULA=1 PRIVACYPOLICY=1 KSN=1 ALLOWREBOOT=0 /qn"

  Write-Host "Kaspersky instalation finished!"
}