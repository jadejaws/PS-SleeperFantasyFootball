Function Get-Draft {
    <#
        .SYNOPSIS
        This is an internal function to pull a draft that already took place in Sleeper into an array.

        .DESCRIPTION
        This function polls the Sleeper app API to retrieve draft results from a draft that has already taken place.
        Draft ID can be obtained by following the process defined in Start-RosterExport.

        .PARAMETER draft_id
        The specific id of the draft you are querying. A league can have multiple draft ids so query the api to ensure the correct result

        .EXAMPLE
        Get-Draft -draft_id 45622156

        .NOTES
        Author: Kevin McClure
    #>
    [CmdletBinding()]
    Param(
        [string]$draft_id
    )

    # error variables
    [int]$ExitCode = $null


    try {
        Write-Verbose "Querying sleeper.app for Draft:$draft_id"
        $DraftURI = "https://api.sleeper.app/v1/draft/$draft_id/picks"
        $Draft = Invoke-RestMethod $DraftURI -Method GET -UseBasicParsing
        $Draft
        $ExitCode = 0
    }

    catch {
        $CaughtException = $_
        Write-Verbose "Error - Unable to retrieve draft specified"
        Write-Verbose $CaughtException
        $ExitCode = 1
    }

}