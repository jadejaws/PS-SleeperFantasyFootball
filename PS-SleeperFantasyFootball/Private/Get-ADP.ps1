Function Get-ADP {
    <#
        .SYNOPSIS
        This is an internal function to pull a list of the top 180 players Average Draft Position into an array.

        .DESCRIPTION
        This function uses the free to use source of fantasy football calculator to pull.

        .PARAMETER format
            The format of the fantasy league to retrieve ADP for. The 4 available options at this time are:
            half-ppr, standard, ppr, and dynasty.

        .PARAMETER teams
            The number of teams in the target league. This can change later round ADP results.

        .EXAMPLE
        Get-ADP -format standard -teams 12

        .NOTES
        Author: Kevin McClure
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("standard", "ppr", "half-ppr", "dynasty")]
        [string]$format,
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 25)]
        [int]$teams

    )


    # error variables
    [int]$ExitCode = $null


    try {
        Write-Verbose "Query Fantasy Football Calculator for $format scoring in a $teams team league "
        $ADPURI = "https://fantasyfootballcalculator.com/adp_xml.php?format=$format&teams=$teams"
        $doc = New-Object System.Xml.XmlDocument
        $doc.Load("$ADPURI")
        $ADPArray = $doc.root.adp_data.player
        $PlayerADPInfo = $AdPArray | Select-Object adp_overall, name -unique
        $PlayerADPInfo
        $ExitCode = 0
    }

    catch {
        $CaughtException = $_
        Write-Verbose "Error - Polling for ADP Data"
        Write-Verbose $CaughtException
        $ExitCode = 1
    }

}