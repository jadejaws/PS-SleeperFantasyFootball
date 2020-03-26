
Function Get-Rosters {
    <#
        .SYNOPSIS
        Gets rosters from the Sleeper Database and pulls to a local array. This array is used for reference throughout this module.

        .DESCRIPTION
        This script is an internal function to retrieve an array for use with the rest of the functions in this module. The data pulled from the
        Sleeper Database for the league_id specified

        .PARAMETER league_id
        The specific id of the league you are querying. Instructions on obtaining this are in Start-RosterExport.

        .EXAMPLE
        Get-Rosters -league_id 45621232156

        .NOTES
        Author: Kevin McClure
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [string]$league_id
    )


    # error variables
    [int]$ExitCode = $null


    try {
        Write-Verbose "Retrieving Rosters from league:$league_id from Sleeper"
        $RostersURI = "https://api.sleeper.app/v1/league/$league_id/rosters"
        $Rosters = Invoke-RestMethod -Uri $RostersURI -Method GET -UseBasicParsing
        $RostersArray = @()
        $RostersArray = $Rosters | Select-Object players, owner_id
        $RostersArray
    }

    catch {
        $CaughtException = $_
        Write-Verbose "Error - Building Object failed"
        Write-Verbose $CaughtException
        $ExitCode = 1
    }
}