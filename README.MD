# Quick instructions

## Environment Setup
1. git clone https://github.com/mattlunzer/AVforBlobDemo
2. cd ./AVforBlobDemo/
3. New-AzResourceGroup -Name [YOUR RG] -Location eastus
4. New-AzResourceGroupDeployment -ResourceGroupName [YOUR RG] -TemplateFile .\main.bicep

## Lab
### ADFC
1. Enable and or upgrade the new Defender for storage plan on an Azure subsription or a specific storage account --> https://learn.microsoft.com/en-us/azure/storage/common/azure-defender-storage-configure?tabs=enable-storage-account#set-up-microsoft-defender-for-storage
2. Configure settings (storage level settings)
- Override Defender for Storage Subscription-leve settings
- Set limit of GB scanned per month
- Send scan results to Log Analytics
- Send scan results to Event-Grid Topic

### Event Grid 
2. Review the Event Grid System Topic, Event Subscription

(Event grid system topics --> https://learn.microsoft.com/en-us/azure/event-grid/system-topics)

### Azure Functions
3. Assign MI role assignment "storage blob data owner" to the resource group (https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/qs-configure-portal-windows-vm). Add your user account too.
4. Create a new Function (https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal)
- Develop in portal
- Azure event grid trigger
5. copy maliciousBlobCopyDelete.ps1 to the function portal editor
6. Edit function App files, uncomment # 'Az' = '9.* in requirements.psd1

### Configure Function as Event Grid Subscription
7. Create Event Grid Subscdription
- name
- Endpoint type [Azure function]
- Endpoint [Your function]
8. click filters...Add new filter
- key = subject
- operate = String does not contain
- value quarantine
create...

### Test
7. edit 