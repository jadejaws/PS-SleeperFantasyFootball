Function Get-DraftPickDetails {
    <#
        .SYNOPSIS
        This is an internal function to pull a draft that already took place in Sleeper into an array.

        .DESCRIPTION
        This function polls the Sleeper app API to retrieve draft results from a draft that has already taken place.
        Draft ID can be obtained by following the process defined in Start-RosterExport.

        .PARAMETER draftspot
        The draft postion of that specific owner. For Example if team RedPlayers drafts in the 3rd spot in the first round this number is 3.

        .PARAMETER draftpick
        The pick which the owner is drafting. Used to determine which pick they have by owner. This is the pick that the keeper would fall into.

        .EXAMPLE
        Get-OwnerDraftSpot -draftspot 3 -draftpick 123

        .NOTES
        Author: Kevin McClure
    #>
    [CmdletBinding()]
    Param(
        [int]$draftspot,
        [int]$draftpick
    )

    # error variables
    [int]$ExitCode = $null


    #Define Picks by Round
    $1Pick = @(1, 24, 25, 48, 49, 72, 73, 96, 97, 120, 121, 144, 145, 168, 169)
    $2Pick = @(2, 23, 26, 47, 50, 71, 74, 95, 98, 119, 122, 143, 146, 167, 170)
    $3Pick = @(3, 22, 27, 46, 51, 70, 75, 94, 99, 118, 123, 142, 147, 166, 171)
    $4Pick = @(4, 21, 28, 45, 52, 69, 76, 93, 100, 117, 124, 141, 148, 165, 172)
    $5Pick = @(5, 20, 29, 44, 53, 68, 77, 92, 101, 116, 125, 140, 149, 164, 173)
    $6Pick = @(6, 19, 30, 43, 54, 67, 78, 91, 102, 115, 123, 139, 150, 163, 174)
    $7Pick = @(7, 18, 31, 42, 55, 66, 79, 90, 103, 114, 127, 138, 151, 162, 175)
    $8Pick = @(8, 17, 32, 41, 56, 65, 80, 89, 104, 113, 128, 137, 152, 161, 176)
    $9Pick = @(9, 16, 33, 40, 57, 64, 81, 88, 105, 112, 129, 136, 153, 160, 177)
    $10Pick = @(10, 15, 34, 39, 58, 63, 82, 87, 106, 111, 130, 135, 154, 159, 178)
    $11Pick = @(11, 14, 35, 38, 59, 62, 83, 86, 107, 110, 131, 134, 155, 158, 179)
    $12Pick = @(12, 13, 36, 37, 60, 61, 84, 85, 108, 109, 132, 133, 156, 157, 180)


    try {
        $var = Get-Variable $draftspot"Pick"

        Write-Verbose "Determining keeper pick based on Pick No: $draftpick for Owner Draft Position: $draftspot"
        if ($draftpick -le 12) {
            $Draft_Round = "1st"
            $Draft_PickNumber = $var.value[0]
        }

        elseif ($draftpick -gt 12 -and $draftpick -le 24) {
            $Draft_Round = "2nd"
            $Draft_PickNumber = $var.value[1]
        }

        elseif ($draftpick -gt 24 -and $draftpick -le 36) {
            $Draft_Round = "3rd"
            $Draft_PickNumber = $var.value[2]
        }

        elseif ($draftpick -gt 36 -and $draftpick -le 48) {
            $Draft_Round = "4th"
            $Draft_PickNumber = $var.value[3]
        }

        elseif ($draftpick -gt 48 -and $draftpick -le 60) {
            $Draft_Round = "5th"
            $Draft_PickNumber = $var.value[4]
        }

        elseif ($draftpick -gt 60 -and $draftpick -le 72) {
            $Draft_Round = "6th"
            $Draft_PickNumber = $var.value[5]
        }

        elseif ($draftpick -gt 72 -and $draftpick -le 84) {
            $Draft_Round = "7th"
            $Draft_PickNumber = $var.value[6]
        }

        elseif ($draftpick -gt 84 -and $draftpick -le 96) {
            $Draft_Round = "8th"
            $Draft_PickNumber = $var.value[7]
        }

        elseif ($draftpick -gt 96 -and $draftpick -le 108) {
            $Draft_Round = "9th"
            $Draft_PickNumber = $var.value[8]
        }

        elseif ($draftpick -gt 108 -and $draftpick -le 120) {
            $Draft_Round = "10th"
            $Draft_PickNumber = $var.value[9]
        }

        elseif ($draftpick -gt 120 -and $draftpick -le 132) {
            $Draft_Round = "11th"
            $Draft_PickNumber = $var.value[10]
        }

        elseif ($draftpick -gt 132 -and $draftpick -le 144) {
            $Draft_Round = "12th"
            $Draft_PickNumber = $var.value[11]
        }

        elseif ($draftpick -gt 144 -and $draftpick -le 156) {
            $Draft_Round = "13th"
            $Draft_PickNumber = $var.value[12]
        }

        elseif ($draftpick -gt 156 -and $draftpick -le 168) {
            $Draft_Round = "14th"
            $Draft_PickNumber = $var.value[13]
        }

        elseif ($draftpick -gt 168 -and $draftpick -le 180) {
            $Draft_Round = "15th"
            $Draft_PickNumber = $var.value[14]
        }

        else {
            Write-Verbose "Invalid number passed"
        }
        Write-Verbose "Keeper pick determined to be $draft_Picknumber in the $Draft_Round Round"
        $ReturnObject = New-Object PSObject -Property @{
            DraftRound       = $Draft_Round
            DraftPickNumber  = $Draft_PickNumber

        }
    }

    catch {
        $CaughtException = $_
        Write-Verbose "Error - Unable to retrieve draft pick details"
        Write-Verbose $CaughtException
        $ExitCode = 1
    }
$ReturnObject

}