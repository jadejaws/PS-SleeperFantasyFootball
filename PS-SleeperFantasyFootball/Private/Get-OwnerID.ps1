function Get-OwnerID {

    <#
        .SYNOPSIS
        Gets Owner information from the Sleeper Database and pulls to a local array. This array is used for reference throughout this module.

        .DESCRIPTION
        This script is an internal function to retrieve an array for use with the rest of the functions in this module. This function queries for the owner_id
        information of a specific owner. This is used for readable data for the owner

        .PARAMETER owner_id
        The specific id of the user/owner you are querying. This is automatically retrieves from league info.

        .EXAMPLE
        Get-OwnerID -user_id 45621232156

        .NOTES
        Author: Kevin McClure
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$user_id
    )
    # error variables
    [int]$ExitCode = $null

    try {
        Write-Verbose "Querying Sleeper app for User:$user_id"
        $OwnersURI = "https://api.sleeper.app/v1/user/$user_id"
        $Owner = Invoke-RestMethod $OwnersURI -Method GET -UseBasicParsing
        $Owner
        $ExitCode = 0
    }
    catch {
        $CaughtException = $_
        Write-Verbose "Error - Building Object failed"
        Write-Verbose $CaughtException
        $ExitCode = 1
    }

}
