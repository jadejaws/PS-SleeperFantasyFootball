$ModuleName = 'VMPurge'
$ModuleFolderPath = "$PSScriptRoot\..\$ModuleName"
Write-Host $ModuleFolderPath -ForegroundColor Green

Describe "$ModuleName Module Tests" {

    Context 'Module Setup' {

        It "has the appropriate root module of $ModuleName.psm1" {

            "$ModuleFolderPath\$ModuleName.psm1" | Should -Exist
        }


        It "has the manifest file of $ModuleName.psd1 and contains reference to $ModuleName.psm1" {

            "$ModuleFolderPath\$ModuleName.psd1" | Should -Exist
            "$ModuleFolderPath\$ModuleName.psd1" | Should -FileContentMatch "$ModuleName.psm1"
        }
    }
}



Describe "$ModuleName Function Tests" {

    $FunctionList = [System.Collections.ArrayList]::New()
    [void] $FunctionList.Add([PSCustomObject] @{Name = 'Invoke-VMPurge'; Type = 'Public'})
    [void] $FunctionList.Add([PSCustomObject] @{Name = 'Connect-vCenter'; Type = 'Private'})
    [void] $FunctionList.Add([PSCustomObject] @{Name = 'Disconnect-vCenter'; Type = 'Private'})
    [void] $FunctionList.Add([PSCustomObject] @{Name = 'Get-FolderVMs'; Type = 'Private'})
    [void] $FunctionList.Add([PSCustomObject] @{Name = 'Remove-VMs'; Type = 'Private'})




    foreach ($Function in $FunctionList) {

        $FunctionName = $Function.Name
        $FunctionFolderPath = "$ModuleFolderPath\$($Function.Type)"
        #$FunctionFolderPath = "$PSScriptRoot\..\$ModuleName\$($Function.Type)"
        Write-Host $FunctionFolderPath -ForegroundColor Blue
        Write-Host $FunctionName -ForegroundColor Magenta
        Context "$FunctionName Function Setup" {

            It "$FunctionName.ps1 should exist" {

                "$FunctionFolderPath\$FunctionName.ps1" | Should -Exist
            }


            It "$FunctionName.ps1 should contain a SYNOPSIS" {

                "$FunctionFolderPath\$FunctionName.ps1" | Should -FileContentMatch '.SYNOPSIS'
            }


            It "$FunctionName.ps1 should contain the advanced function keywords" {

                "$FunctionFolderPath\$FunctionName.ps1" | Should -FileContentMatch 'CmdletBinding'
                "$FunctionFolderPath\$FunctionName.ps1" | Should -FileContentMatch 'Param'
            }


            It "$FunctionName.ps1 should contain Add-LogEntry" {

                "$FunctionFolderPath\$FunctionName.ps1" | Should -FileContentMatch 'Add-LogEntry'
            }


            It "$FunctionName.ps1 should contain valid PowerShell code" {

                $ScriptContent = Get-Content -Path "$FunctionFolderPath\$FunctionName.ps1" -ErrorAction Stop

                $Errors = $null
                [System.Management.Automation.PSParser]::Tokenize($ScriptContent, [ref]$Errors)

                $Errors.Count | Should -Be 0
            }


            It "$FunctionName.ps1 should pass the ScriptAnalyzer" {

                # create exclusion list
                $ExcludeRuleList = [System.Collections.ArrayList]::New()
                [void] $ExcludeRuleList.Add('PSUseShouldProcessForStateChangingFunctions')

                # setting custom exclusions for Get-StoredCredential
                if ($FunctionName -eq 'Get-StoredCredential') {

                    # there's no way to workaround using the string as plain text
                    [void] $ExcludeRuleList.Add('PSAvoidUsingConvertToSecureStringWithPlainText')
                }

                $InvokeScriptOutput = Invoke-ScriptAnalyzer -Path "$FunctionFolderPath\$FunctionName.ps1" -ExcludeRule $ExcludeRuleList

                $InvokeScriptOutput | Should -BeNullOrEmpty


                # create exclusion list
                $ExcludeRuleList = [System.Collections.ArrayList]::New()
                [void] $ExcludeRuleList.Add('PSUseShouldProcessForStateChangingFunctions')

            }
        } # Context "$FunctionName Function Setup"


        # Tests for each function have not yet been written
        <#
        $TestsFolderPath = "$PSScriptRoot\..\Tests"
        Context "$FunctionName has tests" {

            It "$FunctionName.Tests.ps1 should exist" {

                "$TestsFolderPath\$FunctionName.Tests.ps1" | Should Exist
            }
        }
        #>
    } # foreach ($Function in $FunctionList)


    Context "Ensure Function Count" {

        It "function count should match FunctionList count" {

            $FunctionCount = (Get-ChildItem -Path "$ModuleFolderPath\Private" -Recurse -Filter *.ps1).Count +
            (Get-ChildItem -Path "$ModuleFolderPath\Public" -Recurse -Filter *.ps1).Count

            $FunctionCount | Should -Be $FunctionList.Count
        }
    }

} # Describe "$ModuleName Function Tests"