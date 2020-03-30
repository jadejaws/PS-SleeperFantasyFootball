$ModuleName = 'PS-SleeperFantasyFootball'
$ModuleFolderPath = "$PSScriptRoot\..\$ModuleName"


# remove and Import Module
# this is done to ensure the tests are run against the correct code
Get-Module $ModuleName | Remove-Module -Force
Import-Module "$ModuleFolderPath\$ModuleName.psm1" -Force


# run Pester Tests
Import-Module Pester -Force
Invoke-Pester "$PSScriptRoot\$ModuleName.Module.Tests.ps1"