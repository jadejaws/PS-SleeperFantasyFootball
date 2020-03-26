<#
    .SYNOPSIS
    Invoke a Roster Export from a valid json configuration file. The invoke function is for scheduled automation of the Start-RosterExport function.

    .DESCRIPTION
    The purpose of this function is to automate the Start-vCenterAudit process. It uses a json configuration file to populate values.

    .NOTES
    Author: Kevin McClure

    .PARAMETER ConfigFile
    The json formatted configuration file to pull from.

    .EXAMPLE
    Invoke-RosterExport -ConfigFile "C:\Temp\Config.json"

#>

function Invoke-RosterExport () {
    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory = $True)]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf })]
        [ValidatePattern( '\.json$' )]
        [string]$ConfigFile


    )

    Write-Verbose "Importing configuration file"
    try {
        $Config = Get-Content $configFile | ConvertFrom-Json
    }

    catch {
        $CaughtException = $_
        Write-Verbose $CaughtException
        Write-Verbose 'Error importing json file. Check source config.'
    }

    Write-Verbose "Importing Required Values"
    try {
        $leagueid = $Config.LeagueValues.league_id
        $draftid = $Config.LeagueValues.draft_id
        $format = $Config.LeagueValues.format
        $teams = $Config.LeagueValues.teams
        $InvokeRosterExportSplat = @{

            league_id = $leagueid
            draft_id  = $draftid
            format    = $format
            teams     = $teams
            Verbose   = $true
        }
    }

    catch {
        $CaughtException = $_
        Write-Verbose $CaughtException
        Write-Verbose 'Error importing json file. Check source config.'
    }

    if ($Config.LeagueValues.OwnerDraftOrder) {
        Write-Verbose "Importing Owners and Draft order from json"
        try {
            #Create Object Array and import
            $OwnerArray = @()
            Write-Verbose "Creating Object Array from $($Config.LeagueValues.OwnerDraftOrder)"
            foreach ($ownerrecord in  $Config.LeagueValues.OwnerDraftOrder) {
                $PSObject = New-Object PSObject -Property @{
                    Owner         = $ownerrecord.Owner
                    DraftPosition = $ownerrecord.DraftOrder
                }
                $OwnerArray += $PSObject
            }
            $InvokeRosterExportSplat.OwnerArray = $OwnerArray
        }
        catch {
            $CaughtException = $_
            Write-Verbose $CaughtException
            Write-Verbose 'Error importing owner array from json. Check format of owner records.'
        }

    }
    try {
        Write-Verbose "Starting RosterExport with options specified"
        Start-RosterExport @InvokeRosterExportSplat
    }
    catch {
        $CaughtException = $_
        Write-Verbose $CaughtException
        Write-Verbose 'Error Starting Roster Export.'
    }

}
