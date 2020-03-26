
function Get-Players {
    <#
        .SYNOPSIS
        Gets players from the Sleeper Database and pulls to a local array. This array is used for reference throughout this module.

        .DESCRIPTION
        This script is an internal function to retrieve an array for use with the rest of the functions in this module. The data pulled from the
        Sleeper Database is used throughout other functions.

        .EXAMPLE
        Get-Players

        .NOTES
        Author: Kevin McClure
    #>
    [CmdletBinding()]
    Param(
    )


    # error variables
    [int]$ExitCode = $null


    try {
        Write-Verbose "Querying for Player Database from Sleeper App API. This may take a while..."
        $PlayersURI = "https://api.sleeper.app/v1/players/nfl"
        $Players = Invoke-RestMethod $PlayersURI -Method GET -UseBasicParsing
        $Players
    }

    catch {
        $CaughtException = $_
        Write-Verbose "Error - Retrieving Player Array from Sleeper API failed"
        Write-Verbose $CaughtException
        $ExitCode = 1
    }
}