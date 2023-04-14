# Path and Storage Account Name
$file = 'c:\malware\eicar.com.txt'
$storageAccountName = ""

#If the file does not exist, create it.
if (-not(Test-Path -Path $file -PathType Leaf)) {
     try {
         $null = New-Item -ItemType File -Path $file -Force -ErrorAction Stop
         Write-Host "The file [$file] has been created."
     }
     catch {
         throw $_.Exception.Message
     }
 }
# If the file already exists, show the message and do nothing.
 else {
     Write-Host "A file with that name already exists."
 }

$eicar = "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"
$eicar | Out-File $file

#Connect to your Azure subscription
Connect-AzAccount

#get conntext object using Azure AD credentials
$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount

#Create a container object
$container = Get-AzStorageContainer -Name "upload" -Context $ctx

$containerName = "upload"

#Upload a single named file
Set-AzStorageBlobContent -File $file -Container $containerName -Context $ctx -Force