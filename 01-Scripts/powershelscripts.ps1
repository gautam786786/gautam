Open your administrative level PowerShell prompt and type in the following.
Get-VirtualDisk | Where-Object {$_.IsManualAttach –eq $True}
This lists off your virtual disks where the IsManualAttach property is turned on and the disks will not auto-reattach on restart. You can see I have four of them for this demo box I use.
Now run the line again but include the following:
Get-VirtualDisk | Where-Object {$_.IsManualAttach –eq $True} | Set-VirtualDisk –IsManualAttach $False


$subscriptionId = ""        # Use Get-AzSubscription For ID 
$reportName = "gautam.csv"
Select-AzSubscription $subscriptionId
$report = @()
$vms = Get-AzVM
$publicIps = Get-AzPublicIpAddress 
$nics = Get-AzNetworkInterface | Where-Object{ $_.VirtualMachine -NE $null} 
foreach ($nic in $nics) { 
    $info = "" | Select-Object VmName, ResourceGroupName, Region, VirturalNetwork, Subnet, PrivateIpAddress, OsType, PublicIPAddress 
    $vm = $vms | Where-Object -Property Id -eq $nic.VirtualMachine.id 
    foreach($publicIp in $publicIps) { 
        if($nic.IpConfigurations.id -eq $publicIp.ipconfiguration.Id) {
            $info.PublicIPAddress = $publicIp.ipaddress
            } 
        } 
        $info.OsType = $vm.StorageProfile.OsDisk.OsType 
        $info.VMName = $vm.Name 
        $info.ResourceGroupName = $vm.ResourceGroupName 
        $info.Region = $vm.Location 
        $info.VirturalNetwork = $nic.IpConfigurations.subnet.Id.Split("/")[-3] 
        $info.Subnet = $nic.IpConfigurations.subnet.Id.Split("/")[-1] 
        $info.PrivateIpAddress = $nic.IpConfigurations.PrivateIpAddress 
        $report+=$info 
    } 
$report | Format-Table VmName                                                      # You can add extra parameters here if required 
$report | Export-CSV "$home/$reportName"

# Get all resources in the selected subscription

$result = "C:\Temp\subscription-resources.csv"
"SubscriptionName,SubscriptionId,Resource,Name,ResourceGroupName,ResourceId" `
| out-file $OutFilePath -encoding utf8
# Loop through the resources and add to the output file
ForEach ($resource in Get-AzResource)
{
     $AzureSubscription.Name + "," + `
         $AzureSubscription.SubscriptionId + "," + `
         $resource.ResourceType + "," + `
         $resource.Name + "," + `
         $resource.ResourceGroupName + "," + `
         $resource.ResourceId `
| out-file $result -encoding utf8 -append
}

doskey /HISTORY > history.txt
Test-NetConnection [Destination] -Port XXXX


Get AD Group Members:
Get-ADGroup 'GROUPNAME'| Get-ADGroupMember | Select Name | Sort Name | ft -AutoSize

Freespace 
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" 


User logged on
Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName 

Restart  a Service on remote pc 
Invoke-Command -ComputerName gautam01 {Restart-Service Spooler} 



Get-PSDrive -PSProvider FileSystem
 

All IP in use
Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true |
  Select-Object -ExpandProperty IPAddress 

Ping 
Get-CimInstance -Class Win32_PingStatus -Filter "Address='127.0.0.1'" |
  Format-Table -Property Address,ResponseTime,StatusCode -Autosize 


Ping Multiple IP
'127.0.0.1','localhost','research.microsoft.com' |
  ForEach-Object -Process {
    Get-CimInstance -Class Win32_PingStatus -Filter ("Address='$_'") |
      Select-Object -Property Address,ResponseTime,StatusCode
  } 

Output 
Get-Process | Out-File -FilePath C:\temp\processlist.txt 

Folders in a drive 
Get-ChildItem -Path C:\ -Force 

For every thing use 

Get-ChildItem -Path C:\ -Force -Recurse 


The following command finds all executables within the Program Files folder that were last modified after October 1, 2005 and which are neither smaller than 1 megabyte nor larger than 10 megabytes:

Get-ChildItem -Path $env:ProgramFiles -Recurse -Include *.exe | Where-Object -FilterScript {($_.LastWriteTime -gt '2005-10-01') -and ($_.Length -ge 1mb) -and ($_.Length -le 10mb)}
 



List VMs in a subscription ==	                  Get-AzVM
List VMs in a resource group == 	Get-AzVM -ResourceGroupName $myResourceGroup
Get information about a VM ==	Get-AzVM -ResourceGroupName $myResourceGroup -Name $myVM
Start a VM ==	                                    Start-AzVM -ResourceGroupName $myResourceGroup -Name $myVM
Stop a VM ==	                                    Stop-AzVM -ResourceGroupName $myResourceGroup -Name $myVM
Restart a running VM ==	                   Restart-AzVM -ResourceGroupName $myResourceGroup -Name $myVM
Delete a VM ==	                                    Remove-AzVM -ResourceGroupName $myResourceGroup -Name $myVM

•	Enter-PSSession -ComputerName RemoteServer -Port 5353 -Credential Domain\Username
•	Get-EventLog -LogName System -InstanceID c0ffee -Source “LSA“
•	Start-Process -FilePath “notepad” -Wait -WindowStyle Maximized
•	Restart-Computer -ComputerName “Server01”, “Server02”, “Server03”
•	Test-Connection -ComputerName “Server01” -Count 3 -Delay 2 -TTL 255 -BufferSize 256 -ThrottleLimit 32
•	Test-NetConnection [Destination] -Port XXXX

•	Get-Service | Where-Object {$_.Status -eq “Running”}

Turn off VM 
# Connecting to Azure using the AzureRunAsConnection.
$conn = Get-AutomationConnection -Name "AzureRunAsConnection"
$null = Connect-AzureRmAccount -ServicePrincipal -Tenant $conn.TenantId -ApplicationId $conn.ApplicationId -CertificateThumbprint $conn.CertificateThumbprint

# Keys & Values are case sensitive please be aware of that when modifying the script
$VMs = Get-AzureRMVm  |  Where {$_.Tags.Keys -contains "AutoShutdown" -and $_.Tags.Values -contains "7:00 PM"} | Select Name, ResourceGroupName, Tags
ForEach ($VM in $VMs)
{
     $VMStatus2 = Get-AzureRMVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Status |
    Select Name, ResourceGroupName, DisplayStatus, Tags
    $VMN=$VM.Name
    $VMRG=$VM.ResourceGroupName
        If ($VMStatus2 = "VM Running") 
            {
                Stop-AzureRMVM -Name $VMN -ResourceGroupName $VMRG -force
                "$VMN is Shutdown and Deallocated"
            }
                   
}

 

# Startup Virtual Machines for example, VM01,VM02,VM03 etc
$vms = $VmName.split(',')
foreach($vm in $vms) {
IF ($VmAction -eq "Startup") {
    Start-AzureRmVM -Name $Vm -ResourceGroupName $ResourceGroupName | Out-Null
    #Write-Output "VM $Vm in Resource Group $ResourceGroupName was started Successfully" 
    $objOut = [PSCustomObject]@{
    ResourceGroupName = $ResourceGroupName
    VMName = $Vm
    VMAction = $VmAction
    }
    Write-Output ( $objOut | ConvertTo-Json)
    }
}

# Shutdown Virtual Machines for example, VM01,VM02,VM03 etc
$vms = $VmName.split(',')
foreach($vm in $vms) {
IF ($VmAction -eq "Shutdown") {
    Stop-AzureRmVM -Name $Vm -ResourceGroupName $ResourceGroupName -Force | Out-Null
    #Write-Output "VM $Vm in Resource Group $ResourceGroupName was stopped Successfully"
    $objOut = [PSCustomObject]@{
    ResourceGroupName = $ResourceGroupName
    VMName = $Vm
    VMAction = $VmAction
    }
    Write-Output ( $objOut | ConvertTo-Json)
    }
}

Find all local disks on SERVER02 with less than 25% free space.
Param (
$Computername='localhost',
$MinimumPercentFree=100
)
#Convert minimum percent free
$minpercent = $MinimumPercentFree/100
Get-WmiObject –class Win32_LogicalDisk –computername $computername -filter "drivetype=3" |
Where { $_.FreeSpace / $_.Size –lt $minpercent } | Select –Property DeviceID,FreeSpace,Size 


param (
$computername = 'localhost',
$drivetype = 3
)
Get-WmiObject -class Win32_LogicalDisk -computername $computername `
-filter "drivetype=$drivetype" |
Sort-Object -property DeviceID |
Select-Object -property DeviceID,
@{name='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
@{name='Size(GB';expression={$_.Size / 1GB -as [int]}},
@{name='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}} 


[CmdletBinding()]
param (

[Parameter(Mandatory=$True)]
[string]$computername,
[int]$drivetype = 3
)
Get-WmiObject -class Win32_LogicalDisk -computername $computername `
-filter "drivetype=$drivetype" |
Sort-Object -property DeviceID |
Select-Object -property DeviceID,
@{name='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
@{name='Size(GB';expression={$_.Size / 1GB -as [int]}},
@{name='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}}
 

#Get the VM Details
$vm = Get-AzVM -ResourceGroupName 3 -Name VM01
Write-Output $vm 

#Get Data Disks
$datadisks = $vm.StorageProfile.DataDisks
Write-Output "The below Data Disks would be backed up -" 
Write-Output $datadisks 

#get Os Disks
$OsDisk = $vm.StorageProfile.OsDisk
Write-Output "The below OS Disks would be backed up -" 
Write-Output $OsDisk 

#Backup OS Disk
$snapshot =  New-AzSnapshotConfig -SourceUri $OsDisk.ManagedDisk.Id -Location EastUS -CreateOption copy  # Creates a configurable snapshot object.
$name ="OSDisk-" + $OsDisk.Name + $(get-date -f yyyy-MM-dd-HHmmss)
Write-Output "Backing up OS Disk Snaphot with name - " $name

New-AzSnapshot -ResourceGroupName 4 -SnapshotName $name -Snapshot $snapshot 

 if($datadisks.Count -gt 0)
 {
   foreach($dataDisk in $datadisks)
   {
    
    $name ="DataDisk-" + $dataDisk.Name + $(get-date -f yyyy-MM-dd-HHmmss)
    $snapshot =  New-AzSnapshotConfig -SourceUri $dataDisk.ManagedDisk.Id -Location EastUS -CreateOption copy 
    Write-Output "Backing up Data Disk Snaphot with name - " $name
    New-AzSnapshot -ResourceGroupName sana -SnapshotName $name -Snapshot $snapshot 
    
   }
 }


# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave –Scope Process

$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

# Wrap authentication in retry logic for transient network failures
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

Write-Output $logonAttempt

$AzureContext = Get-AzSubscription -SubscriptionId $connection.SubscriptionID

Write-Output $AzureContext

$targetVault = Get-AzRecoveryServicesVault -Name "RSV-RB-UKS-RECOVERYVAULT-DEV" -ResourceGroupName "RG-RB-UKS-RECOVERYVAULT-DEV" 
Write-Output $targetVault.ID

$namedContainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -FriendlyName "RB-BIR-MINTEST" -VaultId $targetVault.ID
$item = Get-AzRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM" -VaultId $targetVault.ID

$job = Backup-AzRecoveryServicesBackupItem -Item $item -VaultId $targetVault.ID 

Write-Output $job



# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave –Scope Process

$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

# Wrap authentication in retry logic for transient network failures
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

Write-Output $logonAttempt

$AzureContext = Get-AzSubscription -SubscriptionId $connection.SubscriptionID

Write-Output $AzureContext

#Get the VM Details
$vm = Get-AzVM -ResourceGroupName RG-RB-UKS-MINCORE -Name RB-BIR-MINCORE

Write-Output $vm 

#Get Data Disks
$datadisks = $vm.StorageProfile.DataDisks

Write-Output "The below Data Disks would be backed up -" 
Write-Output $datadisks 

#get Os Disks
$OsDisk = $vm.StorageProfile.OsDisk

Write-Output "The below OS Disks would be backed up -" 
Write-Output $$OsDisk 

#Backup OS Disk
$snapshot =  New-AzSnapshotConfig -SourceUri $OsDisk.ManagedDisk.Id -Location UKSouth -CreateOption copy 

$name ="OSDisk-" + $OsDisk.Name + $(get-date -f yyyy-MM-dd-HHmmss)

Write-Output "Backing up OS Disk Snaphot with name - " $name

New-AzSnapshot -ResourceGroupName RG-RB-UKS-HOURLYSNAPSHOT-PROD -SnapshotName $name -Snapshot $snapshot 

 if($datadisks.Count -gt 0)
 {
   foreach($dataDisk in $datadisks)
   {
    
    $name ="DataDisk-" + $dataDisk.Name + $(get-date -f yyyy-MM-dd-HHmmss)
     
    $snapshot =  New-AzSnapshotConfig -SourceUri $dataDisk.ManagedDisk.Id -Location UKSouth -CreateOption copy 

    Write-Output "Backing up Data Disk Snaphot with name - " $name
    
    New-AzSnapshot -ResourceGroupName RG-RB-UKS-HOURLYSNAPSHOT-PROD -SnapshotName $name -Snapshot $snapshot 
    
   }
 
 }





# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave –Scope Process

$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

# Wrap authentication in retry logic for transient network failures
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

Write-Output $logonAttempt

$AzureContext = Get-AzSubscription -SubscriptionId $connection.SubscriptionID

Write-Output $AzureContext

$targetVault = Get-AzRecoveryServicesVault -Name "RSV-RB-UKS-RECOVERYVAULT-DEV" -ResourceGroupName "RG-RB-UKS-RECOVERYVAULT-DEV" 
Write-Output $targetVault.ID

$namedContainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -FriendlyName "RB-BIR-MINTEST" -VaultId $targetVault.ID
$item = Get-AzRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM" -VaultId $targetVault.ID

$job = Backup-AzRecoveryServicesBackupItem -Item $item -VaultId $targetVault.ID 

Write-Output $job



Write-Host -NoNewline -ForegroundColor Green "Please enter the VM name you would like to remove:"
$VMName = Read-Host
$vm = Get-AzVm -Name $VMName
$RGName=$vm.ResourceGroupName
Write-Host -ForegroundColor Cyan 'Resource Group Name is identified as-' $RGName
$diagSa = [regex]::match($vm.DiagnosticsProfile.bootDiagnostics.storageUri, '^http[s]?://(.+?)\.').groups[1].value
Write-Host -ForegroundColor Cyan 'Marking Disks for deletion...'
$tags = @{"VMName"=$VMName; "Delete Ready"="Yes"}
$osDiskName = $vm.StorageProfile.OSDisk.Name
$datadisks = $vm.StorageProfile.DataDisks
$ResourceID= (Get-Azdisk -Name $osDiskName).id
New-AzTag -ResourceId $ResourceID -Tag $tags | Out-Null
if ($vm.StorageProfile.DataDisks.Count -gt 0) {
    foreach ($datadisks in $vm.StorageProfile.DataDisks){
    $datadiskname=$datadisks.name 
    $ResourceID= (Get-Azdisk -Name $datadiskname).id 
    New-AzTag -ResourceId $ResourceID -Tag $tags | Out-Null
    }
}
if ($vm.Name.Length -gt 9) {
    $i = 9
} else {
    $i = $vm.Name.Length - 1
}
$azResourceParams = @{
    'ResourceName' = $VMName
    'ResourceType' = 'Microsoft.Compute/virtualMachines'
    'ResourceGroupName' = $RGName
}
$vmResource = Get-AzResource @azResourceParams
$vmId = $vmResource.Properties.VmId
$diagContainerName = ('bootdiagnostics-{0}-{1}' -f $vm.Name.ToLower().Substring(0, $i), $vmId)
$diagSaRg = (Get-AzStorageAccount | where { $_.StorageAccountName -eq $diagSa }).ResourceGroupName
$saParams = @{
    'ResourceGroupName' = $diagSaRg
    'Name' = $diagSa
}
Write-Host -ForegroundColor Cyan 'Removing Boot Diagnostic disk..'
Get-AzStorageAccount @saParams | Get-AzStorageContainer | where {$_.Name-eq $diagContainerName} | Remove-AzStorageContainer -Force
Write-Host -ForegroundColor Cyan 'Removing Virtual Machine-' $VMName 'in Resource Group-' $RGName '...'
$null = $vm | Remove-AzVM -Force
Write-Host -ForegroundColor Cyan 'Removing Network Interface Cards, Public IP Address(s) used by the VM...'
foreach($nicUri in $vm.NetworkProfile.NetworkInterfaces.Id) {
    $nic = Get-AzNetworkInterface -ResourceGroupName $vm.ResourceGroupName -Name $nicUri.Split('/')[-1]
    Remove-AzNetworkInterface -Name $nic.Name -ResourceGroupName $vm.ResourceGroupName -Force
foreach($ipConfig in $nic.IpConfigurations) {
        if($ipConfig.PublicIpAddress -ne $null) {
            Remove-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName -Name $ipConfig.PublicIpAddress.Id.Split('/')[-1] -Force
        }
    }
}
Write-Host -ForegroundColor Cyan 'Removing OS disk and Data Disk(s) used by the VM..'
Get-AzResource -tag $tags | where{$_.resourcegroupname -eq $RGName}| Remove-AzResource -force | Out-Null
Write-Host -ForegroundColor Green 'Azure Virtual Machine-' $VMName 'and all the resources associated with the VM were removed sucesfully...'


also lads just a useful tip if you want to check windows events for a VM and its in azure just use Log analytics and write a simple query like:
 
Event
| where Computer == "VMRBUKSBIRWEB04"
| where EventID == 1074


Microsoft Azure: Get-AzSubscription Returns Token Error
Recently I changed my Azure login to use my organisational account rather than a Microsoft account for a particular subscription. Following this I found I was unable to access the subscription via PowerShell.

Running the cmdlet "Get-AzSubscription" (or "Get-AzureRmSubscription" if you use the older command set) returned the information for most of my subscriptions but threw the following warning for the subscription where my login had been changed;
WARNING: Unable to acquire token for tenant 'x''
After some investigation I found that my old credentials were cached in the context. Running the following cmdlet cleared this cache and allowed the subscription to be access via PowerShell again;
Clear-AzContext
(or Clear-AzureRmContext with the older cmdlets)

You can disable this auto-caching of tokens by using the following;
Disable-AzContextAutosave
(or Disable-AzureRmContextAutosave with the older cmdlets)

RB-HourlyDisk-Snapshot

#Get the VM Details
$vm = Get-AzVM -ResourceGroupName RG-RB-UKS-MINCORE -Name RB-BIR-MINCORE

Write-Output $vm 

#Get Data Disks
$datadisks = $vm.StorageProfile.DataDisks

Write-Output "The below Data Disks would be backed up -" 
Write-Output $datadisks 

#get Os Disks
$OsDisk = $vm.StorageProfile.OsDisk

Write-Output "The below OS Disks would be backed up -" 
Write-Output $$OsDisk 

#Backup OS Disk
$snapshot =  New-AzSnapshotConfig -SourceUri $OsDisk.ManagedDisk.Id -Location UKSouth -CreateOption copy 

$name ="OSDisk-" + $OsDisk.Name + $(get-date -f yyyy-MM-dd-HHmmss)

Write-Output "Backing up OS Disk Snaphot with name - " $name

New-AzSnapshot -ResourceGroupName RG-RB-UKS-HOURLYSNAPSHOT-PROD -SnapshotName $name -Snapshot $snapshot 

 if($datadisks.Count -gt 0)
 {
   foreach($dataDisk in $datadisks)
   {
    
    $name ="DataDisk-" + $dataDisk.Name + $(get-date -f yyyy-MM-dd-HHmmss)
     
    $snapshot =  New-AzSnapshotConfig -SourceUri $dataDisk.ManagedDisk.Id -Location UKSouth -CreateOption copy 

    Write-Output "Backing up Data Disk Snaphot with name - " $name
    
    New-AzSnapshot -ResourceGroupName RG-RB-UKS-HOURLYSNAPSHOT-PROD -SnapshotName $name -Snapshot $snapshot 
    
   }
 
 }



RB-HourlyBackup-RunBook
 Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave –Scope Process

$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

# Wrap authentication in retry logic for transient network failures
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

Write-Output $logonAttempt

$AzureContext = Get-AzSubscription -SubscriptionId $connection.SubscriptionID

Write-Output $AzureContext

$targetVault = Get-AzRecoveryServicesVault -Name "RSV-RB-UKS-RECOVERYVAULT-PROD" -ResourceGroupName "RG-RB-UKS-RECOVERYVAULT-PROD" 
Write-Output $targetVault.ID

$namedContainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -FriendlyName "RB-BIR-MINCORE" -VaultId $targetVault.ID
$item = Get-AzRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM" -VaultId $targetVault.ID

$job = Backup-AzRecoveryServicesBackupItem -Item $item -VaultId $targetVault.ID 

Write-Output $job


RB-Cleanup-Snapshots
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave –Scope Process

$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

# Wrap authentication in retry logic for transient network failures
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

Write-Output $logonAttempt

$AzureContext = Get-AzSubscription -SubscriptionId $connection.SubscriptionID

Write-Output $AzureContext

$resourceGroupName = "RG-RB-UKS-HOURLYSNAPSHOT-PROD"

$snapshots = Get-AzSnapshot -ResourceGroupName $resourceGroupName | Where-Object {$_.TimeCreated -lt (Get-Date).AddDays(-15)}

foreach($snapshot in $snapshots)
{
 Write-Output "Deleting Snapshot - "  $snapshot.Name " create at -" $snapshot.TimeCreated

Remove-AzSnapshot -ResourceGroupName $resourceGroupName -SnapshotName  $snapshot.Name
 
}


 

