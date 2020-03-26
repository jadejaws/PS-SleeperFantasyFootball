function Start-RosterExport {

    <#
        .SYNOPSIS
            Collects and exports to html format a report of a specified Sleeper league with values for ADP, last year draft result, keeper rounds and by team rosters.
            The html output will be placed in the output folder of this module.

        .DESCRIPTION
            This module is to facilitate an automatic ADP, Roster, Keeper, and Keeper Value report for a Sleeper Fantasy Football league.

        .PARAMETER league_id
            The league_id of the SLeeper league you are pulling from. This can be easily obtained by reviewing the API call output of the following:
            https://api.sleeper.app/v1/user/<user_id>/leagues/nfl/2019
            User id can be obtained through:
            https://api.sleeper.app/v1/user/<user_name>

        .PARAMETER draft_id
            The draft_id of the Sleeper league you are pulling from. There may be multiple drafts for a league. You can browse and locate a specific draft_id here:
            https://api.sleeper.app/v1/league/<league_id>/drafts

        .PARAMETER format
            The format of the fantasy league to retrieve ADP for. The 4 available options at this time are:
            half-ppr, standard, ppr, and dynasty.

        .PARAMETER teams
            The number of teams in the target league. This can change later round ADP results

        .PARAMETER ownerarray
            Array in the following format of owners to their draft position.
             $arr = @(
                    [PSCustomObject]@{Owner = "TomBrady";  DraftPosition = 5 }
                    [PSCustomObject]@{Owner = "LeveonBell"; DraftPosition = 6 }
            )

        .Example
            $arr = @(
                     [PSCustomObject]@{Owner = "TurfToe71";  DraftPosition = 7 }
                     [PSCustomObject]@{Owner = "Breakhislegs"; DraftPosition = 6 }
                     [PSCustomObject]@{Owner = "jmen11"; DraftPosition = 8 }
                     [PSCustomObject]@{Owner = "Topguny"; DraftPosition = 1 }
                     [PSCustomObject]@{Owner = "AsylumJokers"; DraftPosition = 12 }
                     [PSCustomObject]@{Owner = "HomerJSimpson"; DraftPosition = 3 }
                     [PSCustomObject]@{Owner = "BHize"; DraftPosition = 10 }
                     [PSCustomObject]@{Owner = "VTards"; DraftPosition = 4 }
                     [PSCustomObject]@{Owner = "TacoCorpEb"; DraftPosition = 1 }
                     [PSCustomObject]@{Owner = "Mrnix"; DraftPosition = 11 }
                     [PSCustomObject]@{Owner = "SouthsideBrawlers"; DraftPosition = 9 }
                     [PSCustomObject]@{Owner = "Jadejaws"; DraftPosition = 5 }
            )
            $draft_id = "448327943836397569"
            $league_id = "448327943836397568"

            Start-RosterExport -league_id $league_id -draft_id $draft_id -format standard -teams 12 -Verbose -ownerarray $arr

        .NOTES
            Author: Kevin McClure
    #>


    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$league_id,
        [Parameter(Mandatory = $True)]
        [string]$draft_id,
        [Parameter(Mandatory = $true)]
        [ValidateSet("standard", "ppr", "half-ppr", "dynasty")]
        [string]$format,
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 25)]
        [int]$teams,
        [Parameter(Mandatory = $false)]
        [psobject[]]$ownerarray
    )

    #Get Rosters from League
    $RostersArray = Get-Rosters -league_id $league_id

    #Get League Information
    $League = Get-League -league_id $league_id

    #Get Players from League
    $Players = Get-Players

    #Get Current ADP
    $ADP = Get-ADP -format $format -teams $teams

    #Get 2019 Draft position of player
    $Draft = Get-Draft -draft_id $draft_id

    $OwnerRosters = @()

    #Get each roster and export to array
    foreach ($owner in $RostersArray) {
        $ownerroster = ""
        $ownerhold = ""
        $ownerhold = Get-OwnerID -user_id $owner.owner_id
        $ownerroster = $RostersArray | Where-Object { $_.owner_id -eq $owner.owner_id }
        foreach ($player in $ownerroster.players) {
            $obj = @()
            $obj = "" | Select-Object Owner, Player, Team, Position, ADP, ADPRound, DraftedPosition, DraftedRound, KeeperPosition, KeeperRound, KeeperValue
            $PlayerHold = $players.$player
            $obj.owner = $ownerhold.display_name
            $OwnerDisplayName = $ownerhold.display_name
            $OwnerArrayHolder = $ownerarray | Where-Object { ($_.owner -like $OwnerDisplayName) }
            $OwnerDraftPosition = $OwnerArrayHolder.DraftPosition
            if ($PlayerHold.first_name -like "DeAndr*") {
                $PlayerHold.first_name = "DeAndre"
            }
            $obj.Player = $PlayerHold.first_name + " " + $PlayerHold.last_name

            #Some names will not match because of the variance between FFCalc and Sleeper. For now this will manually correct those variances.
            if ($obj.Player -like "*Patrick Mahomes*") {
                $obj.Player = "Pat Mahomes"
            }
            if ($obj.Player -like "*Marvin Jones*") {
                $obj.Player = "Marvin Jones"
            }
            if ($obj.Player -like "*Mohamed Sanu*") {
                $obj.Player = "Mohamed Sanu"
            }
            if ($obj.Player -like "*Todd Gurley*") {
                $obj.Player = "Todd Gurley"
            }
            if ($obj.Player -like "*John Ross*") {
                $obj.Player = "John Ross"
            }
            if ($obj.Player -like "*DK Metcalf*") {
                $obj.Player = "D.K. Metcalf"
            }
            if ($obj.Player -like "*Le'Veon Bell*") {
                $obj.Player = "Leveon Bell"
            }
            if ($obj.Player -like "*Allen Robinson*") {
                $obj.Player = "Allen Robinson"
            }
            if ($obj.Player -like "*Mark Ingram*") {
                $obj.Player = "Mark Ingram"
            }
            if ($obj.Player -like "*Odell Beckham*") {
                $obj.Player = "Odell Beckham Jr"
            }
            if ($obj.Player -like "*Melvin Gordon*") {
                $obj.Player = "Melvin Gordon"
            }
            if ($obj.Player -like "*DJ Chark*") {
                $obj.Player = "D.J. Chark"
            }
            if ($obj.Player -like "*Willie Snead*") {
                $obj.Player = "Willie Snead"
            }
            if ($obj.Player -like "*Will Fuller*") {
                $obj.Player = "Will Fuller"
            }



            $obj.Position = $PlayerHold.position
            $obj.team = $PlayerHold.team
            $ADPHold = $ADP | Where-Object { $_.name -like $obj.Player }
            $ADPValue = [math]::Round($ADPHold.adp_overall)
            if ($ADPValue -eq 0) {
                $ADPValue = 180
            }
            $obj.ADP = $ADPValue
            #Owner Draft Position doesnt matter here as we are looking up what round the pick was in.
            $ADPRound = Get-DraftPickDetails -draftpick $ADPValue -draftspot 1
            $obj.ADPRound = $ADPRound.DraftRound
            $DraftHold = $Draft | Where-Object { ($_.player_id -eq $playerhold.player_id) }
            $LYDDraftHold = $DraftHold.pick_no
            if (!$LYDDraftHold) {
                $LYDDraftHold = 180
            }

            $obj.DraftedPosition = $LYDDraftHold
            if ($obj.DraftedPosition -ge 180) {
                $obj.DraftedRound = "15th"
            }
            else {
                #Owner Draft Position doesnt matter here as we are looking up what round the pick was in.
                $DraftedRound = Get-DraftPickDetails -draftpick $LYDDraftHold -draftspot 1
                $obj.DraftedRound = $DraftedRound.DraftRound
            }

            if ($obj.DraftedPosition -le 24) {
                $obj.KeeperPosition = "NA"
                $obj.KeeperRound = "NA"
            }

            if ($obj.DraftedPosition -gt 24 -and $obj.DraftedPosition -le 48) {
                if ($ownerarray) {
                    $Draftpickno = $Obj.DraftedPosition - 24
                    $OwnerDraftSpot = $ownerDraftPosition -as [int]
                    $KeeperDetails = Get-DraftPickDetails -draftpick $draftpickno -draftspot $OwnerDraftSpot
                    $obj.KeeperPosition = $KeeperDetails.DraftPickNumber
                    $obj.KeeperRound = $KeeperDetails.DraftRound
                }
                else {
                    $obj.KeeperPosition = $Obj.DraftedPosition - 24
                    #We are not using owners so just set a draft position arbitrarily to determine round
                    $KeeperRound = Get-DraftPickDetails -draftpick $obj.KeeperPosition -draftspot 1
                    $obj.KeeperRound = $KeeperRound.DraftRound
                }
            }


            if ($obj.DraftedPosition -gt 48 -and $obj.DraftedPosition -le 96) {
                if ($ownerarray) {
                    $Draftpickno = $Obj.DraftedPosition - 36
                    $OwnerDraftSpot = $ownerDraftPosition -as [int]
                    $KeeperDetails = Get-DraftPickDetails -draftpick $draftpickno -draftspot $OwnerDraftSpot
                    $obj.KeeperPosition = $KeeperDetails.DraftPickNumber
                    $obj.KeeperRound = $KeeperDetails.DraftRound
                }
                else {
                    $obj.KeeperPosition = $Obj.DraftedPosition - 36
                    #We are not using owners so just set a draft position arbitrarily to determine round
                    $KeeperRound = Get-DraftPickDetails -draftpick $obj.KeeperPosition -draftspot 1
                    $obj.KeeperRound = $KeeperRound.DraftRound
                }
            }


            if ($obj.DraftedPosition -gt 96) {
                if ($ownerarray) {
                    $Draftpickno = $Obj.DraftedPosition - 48
                    $OwnerDraftSpot = $ownerDraftPosition -as [int]
                    $KeeperDetails = Get-DraftPickDetails -draftpick $draftpickno -draftspot $OwnerDraftSpot
                    $obj.KeeperPosition = $KeeperDetails.DraftPickNumber
                    $obj.KeeperRound = $KeeperDetails.DraftRound
                }
                else {
                    $obj.KeeperPosition = $Obj.DraftedPosition - 48
                    #We are not using owners so just set a draft position arbitrarily to determine round
                    $KeeperRound = Get-DraftPickDetails -draftpick $obj.KeeperPosition -draftspot 1
                    $obj.KeeperRound = $KeeperRound.DraftRound
                }
            }
            if ($obj.KeeperPosition -eq "NA") {
                $obj.KeeperValue = "NA"
            }
            else {
                $obj.KeeperValue = $obj.KeeperPosition - $ADPValue
            }

            $OwnerRosters += $obj
        }
    }
    Write-Verbose "Outputting HTML Report to output directory"
    $LeagueReportName = $league.name +"_League_Year_"+ $league.season + "_ADP_Value_Report.html"
    Set-HTMLReportTagging -ArrayInput $OwnerRosters -HTMLOutput $LeagueReportName
    $OwnerRosters
}
