$Server   = IP_OF_TFTP_SERVER
$Username = SWITCH_USER
$Password = SWITCH_PASSWORD
$DATE = Get-Date
$SCRIPT_LOCATION = LOCATION_OF_SCRIPT
$SCRIPT_BACKUP = SCRIPT_IN_REPO

Set-Location LOCATION_OF_SCRIPT


#Using Solar Winds as TFTP Server
$ServiceName = 'SolarWinds TFTP Server'
$arrService = Get-Service -Name $ServiceName

#If Server Service not running, send log.
while ($arrService.Status -ne 'Running')
{
    write-host "TFTP Server is Not Running! Aborting Script!! (Start the TPTP Server)"
    "The Backup Script DID NOT RUN on $DATE (TFTP Server is Not Running! Aborting Script!! (Start the TPTP Server))" | Out-File -FilePath LOCATION_AND_FILE_NAME -Append
    exit 99
}

#Import CSV of switches
$SwitchList = Import-Csv .\switchlist.csv | sort NodeName 

#Parse through csv.
foreach ($Switch in $SwitchList)
{
	$FilePath = "Configs/" + $Switch.Building + "/" 
	$FileName = $Switch.IPAddress + ".txt"

#If tftp dest exists, run kitty with params. Else, create tftp dest folder and then run kitty
	if ((Test-Path \\$Server\c$\automated-network-backups\$Filepath) -eq $false){New-Item -ItemType Directory -Name $Switch.Building -Path \\$Server\c$\automated-network-backups\Configs\}
	.\kitty.exe $Switch.IPAddress -ssh -v -l $Username -pw $Password -cmd "en \n Copy running-config startup-config \ny \n Copy Startup-Config tftp://$Server/$Filepath$FileName \ny \nlogout"
	sleep -Seconds 2
}
 
 #Copy Script into Git Repo
 if (!(Test-Path $SCRIPT_LOCATION) -eq $false)
 {
    cp $SCRIPT_LOCATION $SCRIPT_BACKUP -Recurse
 }
 
 "SUCCESSFUL!!! The Backup Script RAN on $DATE" | Out-File -FilePath LOCATION_AND_FILE_NAME -Append