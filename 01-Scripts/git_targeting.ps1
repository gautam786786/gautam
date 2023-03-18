[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $sana="gautam_code"
)

write-host "Comparing GIT "
$gitdiffs = git diff $(git merge-base --octopus remotes/origin/master) --name-only --pretty=""

$baseFiles = $gitdiffs | Where-Object {$_.StartsWith($sana)}
If ($baseFiles) {
  $baseHit = $true
  write-host "Chnages found"
 $gautam = ($baseFiles | Foreach-object {
    $imgPath = ($_.Replace("$sana/","")).Split("/")
    If ($imgPath.Count -gt 1) {
      $out = "base/"+$imgPath[0]
      Write-Output $out
    }
  } | Select-Object -Unique ) -join ";"
  write-host "Updates have been made to the base images:$gautam"
  write-host "##vso[task.setvariable variable=GIT_BASE_IMAGES;isOutput=true]$baseImages"
} else {
  write-host "No changes found for base image(s)"
  $baseHit = $false
}


If ((@($baseHit,$hardenedHit,$extendedHit) | Where-Object {$_ -eq $true}).Count -gt 1 -and !$allowMultistage) {
  write-error "."
}
