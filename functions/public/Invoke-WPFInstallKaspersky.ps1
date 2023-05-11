function Invoke-WPFInstallKaspersky {
  Write-Host "Downloading Kaspersky installer..."
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/kes_win.msi"
  $out = "c:\temp\kes_win.msi"
  invoke-WebRequest -Uri $url -OutFile $out

  Write-Host "Downloading required files..."
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/kes.cab"
  $out = "c:\temp\kes.cab"
  invoke-WebRequest -Uri $url -OutFile $out
  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/bases.cab"
  $out = "c:\temp\bases.cab"
  invoke-WebRequest -Uri $url -OutFile $out

  Write-Host "Installing..."
  Start-Process msiexec.exe -Wait -ArgumentList "/i c:\temp\kes_win.msi EULA=1 PRIVACYPOLICY=1 KSN=1 ALLOWREBOOT=0 /qn"

  Write-Host "Kaspersky instalation finished!"
}