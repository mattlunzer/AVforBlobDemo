param($eventGridEvent, $TriggerMetadata)

# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent | ConvertTo-JSON | Out-String | Write-Host

#EventGrid variables
$scanResult = $eventGridEvent.data.scanResultType
$blobUri = $eventGridEvent.data.blobUri

#Parse blobUri variables using regex
#$blobUri = "[debuggin]"
$storageAccountName = (($blobUri -split "//")[1] -split "\.")[0]
$malwareContainerName = ($blobUri -split "/")[-2]
$malwareBlobName = ($blobUri -split "/")[-1]

# Set the container names
$quarantineContainerName = "quarantine"

# Create a new Azure storage context using the account details
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount -Verbose
$destinationStorageContext = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount -Verbose

# debugging
#$scanResult = "Malicious"

#copy to quarantine
if ($scanResult -eq "Malicious") {
    #write host
    Write-Host " BlobUri is $blobUri `n Storage account name is $storageAccountName `n malware container is $malwareContainerName `n blob is $malwareBlobName `n quarantine name is $quarantineContainerName `n scan result is $scanResult"

    # Get the malware blob
    Write-Host "`n get blob..."
    $malwareBlob = Get-AzStorageBlob -Context $storageContext -Container $malwareContainerName -Blob $malwareBlobName -IncludeTag -Verbose
    Write-Host `n $malwareBlob.Name

    # Copy the malware blob to the quarantine container
    #$quarantineBlobName = $malwareBlobName + ".quarantine"
    $quarantineBlobName = $malwareBlobName
    #Start-AzStorageBlobCopy -Context $storageContext -SrcContainer $malwareContainerName -SrcBlob $malwareBlob.Name -DestContainer $quarantineContainerName -DestBlob $malwareBlob.Name -Force
    Write-Host "`n $quarantineBlobName `n starting copy..."
    Copy-AzStorageBlob -Context $storageContext -SrcContainer $malwareContainerName -SrcBlob $malwareBlob.Name -DestContext $destinationStorageContext -DestContainer $quarantineContainerName -DestBlob $quarantineBlobName -Force -Verbose

    # Delete the malware blob from the malware container
    #$SourceMalwareBlob = Get-AzStorageBlob -Context $StorageContext -Container $MalwareContainerName -Blob $sourceMalwareBlobName -IncludeTag
    #Remove-AzStorageBlob -context $sourceStorageContext -Container malware -Blob eicar.com.txt -Force
    Write-Host "`n deleting source file..."
    Get-AzStorageBlob -Context $storageContext -Container $MalwareContainerName -Blob $malwareBlobName | Remove-AzStorageBlob -Verbose
}

else {
    # Ignore the blob
    Write-Output "Ignoring blob $blobUri"
}
