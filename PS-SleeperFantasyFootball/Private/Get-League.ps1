function Get-League {

    <#
        .SYNOPSIS
        Gets league information from the Sleeper Database and pulls to a local array. This array is used for reference throughout this module.

        .DESCRIPTION
        This script is an internal function to retrieve an array for use with the rest of the functions in this module. This function queries for the owner_id
        information of a specific league.

        .PARAMETER owner_id
        The specific id of the league you are querying. This is automatically retrieves from league info.

        .EXAMPLE
        Get-League -league_id 45621232156

        .NOTES
        Author: Kevin McClure
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$league_id
    )
    # error variables
    [int]$ExitCode = $null

    try {
        Write-Verbose "Querying Sleeper app for League:$league_id"
        $LeagueURI = "https://api.sleeper.app/v1/league/$league_id"
        $League = Invoke-RestMethod $LeagueURI -Method GET -UseBasicParsing
        $League
        $ExitCode = 0
    }
    catch {
        $CaughtException = $_
        Write-Verbose "Error - Building Object failed"
        Write-Verbose $CaughtException
        $ExitCode = 1
    }

}
