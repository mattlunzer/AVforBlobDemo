# Create-NewFile.ps1

# Full path of the file
$file = 'c:\malware2\eicar.com.txt'

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