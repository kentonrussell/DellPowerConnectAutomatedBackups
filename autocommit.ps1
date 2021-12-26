
$REPO_LOCATION = REPO_LOCATION #location of git repo
$INDEX_LOCK = "REPO_LOCATION/.git/index.lock" #location of lock on git repo

Set-Location "C:\"

if ((Test-Path $INDEX_LOCK) -eq $true){rm $INDEX_LOCK}

if ((Test-Path $REPO_LOCATION) -eq $true){ Set-Location $REPO_LOCATION }

if ((Test-Path $REPO_LOCATION) -eq $false)
    { 
        git clone #REPO_LOCATION with user token for auth
        Set-Location $REPO_LOCATION 
    }

if ((Test-Path $REPO_LOCATION) -eq $true){ Set-Location $REPO_LOCATION }


if ((Test-Path $INDEX_LOCK) -eq $true){rm $INDEX_LOCK}

git status

git add Configs/*

git add Logs/*

git add Scritps/*

git commit -m "Committed by backupscript"

git push -f




