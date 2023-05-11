function Invoke-WPFDerventioSettings {
  Write-Host "Setting up derventio preferences..."
  
  Write-Host "Creating DHT Folder..."
  $DHT = "$env:USERPROFILE\.DHT"
  if (!(Test-Path -Path $DHT)) {
    $DHTFolder = New-Item -Path $DHT -ItemType Directory
    $DHTFolder.attributes='Hidden'
  }

  Write-Host "Downloading wallpaper..."
  $bgurl = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/Background.jpg"
  $bgout = "$env:USERPROFILE\.DHT\Background.jpg"
  invoke-WebRequest -Uri $bgurl -OutFile $bgout

  Write-Host "Downloading Brave Config..."
  $braveurl = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/Brave.reg"
  $braveout = "c:\temp\Brave.reg"
  invoke-WebRequest -Uri $braveurl -OutFile $braveout

  Write-Host "Downloading Windows 11 Config..."
  $winurl = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/win11.reg"
  $winout = "c:\temp\win11.reg"
  invoke-WebRequest -Uri $winurl -OutFile $winout

  Write-Host "Setting Wallpaper..."
  Function Set-WallPaper {
    param (
        [parameter(Mandatory=$True)]
        [string]$Image,
        [parameter(Mandatory=$False)]
        [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
        [string]$Style
    )

    $WallpaperStyle = Switch ($Style) {
      
        "Fill" {"10"}
        "Fit" {"6"}
        "Stretch" {"2"}
        "Tile" {"0"}
        "Center" {"0"}
        "Span" {"22"}
      
    }

    If($Style -eq "Tile") {
    
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force | Out-Null
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force | Out-Null
    
    }
    Else {
    
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force | Out-Null
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force | Out-Null
    
    }

    Add-Type -TypeDefinition @"
    using System; 
    using System.Runtime.InteropServices;
      
    public class Params
    { 
        [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
        public static extern int SystemParametersInfo (Int32 uAction, 
                                                      Int32 uParam, 
                                                      String lpvParam, 
                                                      Int32 fuWinIni);
    }
"@ 
      
        $SPI_SETDESKWALLPAPER = 0x0014
        $UpdateIniFile = 0x01
        $SendChangeEvent = 0x02
      
        $fWinIni = $UpdateIniFile -bor $SendChangeEvent
      
        $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
    }
    
    Set-WallPaper -Image $bgout -Style Fill

    $regKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'

    if (!(Test-Path -Path $regKey)) {
      $null = New-Item -Path $regKey
    }

  New-ItemProperty -Path $regKey -Name LockScreenImageStatus -Value "1" -PropertyType DWORD -Force | Out-Null
  New-ItemProperty -Path $regKey -Name LockScreenImagePath -Value $bgout -PropertyType STRING -Force | Out-Null
  New-ItemProperty -Path $regKey -Name LockScreenImageUrl -Value $bgout -PropertyType STRING -Force | Out-Null

  Write-Host "Attempting to block Windows 11 upgrade..."
  reg import $winout

  Write-Host "Setting Brave policy..."
  reg import $braveout

  Write-Host "Updating group policy..."
  Invoke-GPUpdate
  
  Write-Host "Derventio Preferences Setup!"
}