[CmdletBinding()]
param (
  [string]$subscriptionName="Visual Studio Professional Subscription",
  [string[]]$vmFilters=@("gautam1","gautam11"),
  [int]$avZone= 1,
  [string]$mode="deallocate",
  [switch]$apply
)

$ErrorActionPreference = "Stop"

# write-host "Setting subscription to: $subscriptionName"
az account set -s $subscriptionName

write-host "Getting list of VM's in Availability Zone $avZone"
$zoneVMs = az vm list -d | ConvertFrom-Json | Where-Object {$_.zones -contains $avZone}

$matchedVMs = @()

# Get list of VM's that match the filter and then display their details
write-host "Finding VM's that match the filters"
foreach ($vm in $zoneVMs) {
  if ($vmFilters | ForEach-Object {$vm -match $} | Where-Object {$ -eq $true}) {
    $matchedVMs += $vm
  }
}

$matchedVMs | Select-Object name, resourceGroup, powerState, location, zones | Format-Table -auto

# Prompt to confirm the script should run in apply mode
# if ($apply) {
#   If ((Read-Host -Prompt "This script has been run in 'apply' mode type 'CHANGEPOWERSTATE' to power off the relevant VM's") -ceq "CHANGEPOWERSTATE") {
#     Write-host "Continuing on with $mode"
#   } else {
#     exit
#   }
# }

# Loop through each filter (so processed in order) and power down the VM.
foreach ($filter in $vmFilters){
  switch ($mode) {
    "deallocate" {
      $pretask = "Deallocating"
      $posttask = "deallocated"
      $vm_state = "running"
    }
    "start" {
      $pretask = "Starting"
      $posttask = "running"
      $vm_state = "deallocated"
    }
  }
  Write-Host "$pretask VMs with filter: $filter"
  $filteredVMs = $zoneVMs | Where-Object {$.name -match $filter -and $.powerState -eq "VM $vm_state"}
  $filteredVMs | ForEach-Object {
    if ($apply) {
      write-host "$(Get-Date): $pretask VM: $($_.id)"
      az vm $mode --ids $_.id
      write-host "$(Get-Date): VM $posttask"
    } else {
      Write-Host "$(Get-Date): Would have run 'az vm $mode' against: $($_.id )"
    }
  }
  if ($apply) {
    Read-Host -Prompt "Press enter to continue onto next vm filter"
  }
}

Write-Host "Evacuation script complete"