function Invoke-WPFInstallVPN {

  $DHT = "c:\.DHT"
  if (!(Test-Path -Path $DHT)) {
    Write-Host "Creating DHT Folder..."
    $DHTFolder = New-Item -Path $DHT -ItemType Directory
    $DHTFolder.attributes='Hidden'
    Write-Host "Folder created..."
  }

  $url = "https://github.com/JJ-VP/winutil-derventio/raw/main/data/rootca.crt"
  $out = "$DHT\rootca.crt"
  invoke-WebRequest -Uri $url -OutFile $out
  Import-Certificate -FilePath $out -CertStoreLocation cert:\LocalMachine\root
  
  function PrintError ($message) {
    Write-Host $message -ForegroundColor Red -BackgroundColor Black
  }
  
  function SetIPSecConfiguration () {
    Set-VpnConnectionIPsecConfiguration -ConnectionName 'Derventio' -AuthenticationTransformConstants 'SHA256128' -CipherTransformConstants 'AES256' -DHGroup 'Group14' -EncryptionMethod 'AES256' -IntegrityCheckMethod 'SHA256' -PfsGroup 'None' -Force
  }
  
  function AddVPNConnection () {
    try {
      Add-VpnConnection -Name 'Derventio' -ServerAddress '195.99.210.194' -TunnelType 'IKEv2' -EncryptionLevel 'Required' -AuthenticationMethod Eap -RememberCredential
      SetIPSecConfiguration
      Write-Host "Created the 'Derventio' VPN connection"
    }   catch {
      PrintError "Error in creating the 'Derventio' VPN connection!" 
      PrintError $_.Exception.Message
    }
  }
  
  function UpdateVPNConnection () {
    try {
      Set-VpnConnection -Name 'Derventio' -ServerAddress '195.99.210.194' -TunnelType 'IKEv2' -EncryptionLevel 'Required' -AuthenticationMethod Eap     -WarningAction SilentlyContinue
      SetIPSecConfiguration
      Write-Host "Updated the 'Derventio' VPN connection"
    }   catch {
      PrintError "Error in updating the 'Derventio' VPN connection!" 
      PrintError $_.Exception.Message
    }
  }
  
  $vpn = Get-VpnConnection -Name 'Derventio' -ErrorAction SilentlyContinue
  if ($vpn -and ($vpn.Name -eq 'Derventio')) {
    PrintError "A VPN connection with the name 'Derventio' is already configured on your system."
    $message = "Do you want to update the existing 'Derventio' VPN connection?"
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Updates the 'Derventio' VPN connection."
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Exit without updating."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $result = $host.ui.PromptForChoice('', $message, $options, 0)
    switch ($result) {
      0 {UpdateVPNConnection}
      1 {PrintError "The existing �Derventio� VPN connection was not updated. Remove or rename the existing VPN connection and run the script again."}
    }
  } else {
    AddVPNConnection
  }
  Write-Host "Derventio VPN Installed!"
}