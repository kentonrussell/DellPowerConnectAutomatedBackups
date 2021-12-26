# Dell PowerConnect Automated Backups
Written By: Kenton Russell <br />
Last Moddified: 12/26/2021 <br />
Two scripts were created. <br />
One script was created to backup all switch configurations and the other script was created to commit/push the repository to gitlab. <br />
**Disclaimer**  <br />
Ideally this should be run with rsa key and not username and password. You must migrate your environment for only key authentication as Dell 6248 does now allow for both username/password and key authentication.
# Hosts 
Windows Host Machine needed <br />
# Scripts
autobackups.ps1 <br />
autocommit.ps1 <br />
# Dependencies
switchlist.csv <br />
Service Account (windows)  : To Run Task on Win Server <br />
Service Account (gitlab) : To push and pull from git <br />
Task: AutoBackup <br />
Task: AutoCommit <br />

# Local Repository (and TFTP ROOT)
Set TFTP root as your git repo

# autobackups.ps1
The backup script was named autobackups.ps1. This script loops through the csv switchlist.csv and ssh's into the IP address using kitty.exe. <br /> Within the script there are commands seperated by \n (a carriage return). These commands run in sequence and are as followed:
1. login to switch using username and password
2. Copy running-config startup-config
3. Copy running-config to tftp://$Server/$TFTP_ROOT/*
4. Log out of switch

The script then writes a completed log to the local repository in */Logs <br />
<br />
If the TFTP server is not running, the script writes a Failed-Backup log to the local repository in */Logs. Additionally, the script will exit early and not go through the ssh sessions because there is not a valid TFTP root.

# autocommit.ps1
The commit script was named autocommit.ps1. This script navigates to the local repository. It then adds, commits, and pushes. <br />
This local repository can be treated as the most up to date and current repository because svc-netbackups is the only account that should be changing the repository.  <br /> <br />
IF YOU NEED TO MAKE AN EDIT TO A CONFIGURATION FILE, DO IT ON THE SERVER SIDE. NOT THE GITLAB SIDE!!! <br />

# How to Manually Run Backups and commit
If you need to run the backup script and commit script manually, you can do so in Task Scheduler.
1. Navigate to RoyalServer.ncc.lan
2. Navigate to Task Scheduler
3. Run AutoBackup
4. Wait 6 minutes for AutoBackup to finish running (it will say script has completed, but trust me, its still working)
5. Run AutoCommit

# How To Add a Switch
1. Navigate to switchlist.csv 
2. Append Building, Nodename, and IP address to the csv
3. RDP to your Win Server **as windows service account that runs task**
4. Navigate to Kitty.exe
5. Login to the switch using the IP inserted into the csv.
6. Accept the RSA fingerprint.
7. Run AutoBackup Task in Task Scheduler
8. Run the AutoCommit Task in Task Scheduler
9. Ensure New Backup Exists in Gitlab Repo

# How to Start TFTP server
If you see a failure in Logs/Failed_Backups that means that the TFTP server is not running! <br />
1. Login to Windows Server
2. Start SolarWindsTftp Server
3. Navigate to  File > Configure
4. Select Start (TFTP Service)
5. Run AutoBackup Task in Task Scheduler 
