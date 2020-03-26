<#
.SYNOPSIS
Formats a html file with color code tagging from an array input
.DESCRIPTION
The purpose of this script is to format HTML from an input array.
.NOTES
Author: Kevin McClure
.PARAMETER ArrayInput
Input of the report to transform to HTML.
.PARAMETER HTMLOutput
The name of the html file to export.
.EXAMPLE
Set-HTMLReportTagging -EmailInput $Array -HTMLOutput $HTMLOutput
#>

Function Set-HTMLReportTagging () {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [array]$ArrayInput,
        [Parameter(Mandatory = $True)]
        [string]$HTMLOutput
    )
$TempTitle = $HTMLOutput.Split(".")[0]
$Title = $TempTitle.Replace("_"," ")
    #Define Style of HTML Output
    $Style = @"
<title>$Title</title>
<h1><center>$Title<center></h1>
<style>
body { background-color:#FFFFFF;
font-family:Arial;
font-size:16pt; }
td, th { border:1px solid black;
border-collapse:collapse; }
th { color:black;
background-color:#8DB4E2; }
th {
    background: #8DB4E2;
    position: sticky;
    top: 0;
    box-shadow: 0 4px 4px 1px rgba(0, 0, 0, 0.4);
  }
table, tr, td, th { padding: 2px; margin: 0px }
table { width:100%;margin-left:5px; margin-bottom:20px;}
.bad {color: Red ; back-ground-color: Red}
.good {color: #178B1E }
.warning {color: #F3DC1B }
.critical {color: #F3351B}
.notice {color: #F3DC1B }
.other {color: #3386FF }
.tealoffwhite { background: #B8F5F7 }
.tealoffwhitebold { background: #B8F5F7 ; font-weight: bold;}
.teal { background: #80C2C4 }
.tealbold { background: #80C2C4 ; font-weight: bold;}
.lime { background: #95F995 }
.limebold { background: #95F995 ; font-weight: bold;}
.sand { background: #F6E4A5 }
.sandbold { background: #F6E4A5 ; font-weight: bold; }
.sea { background: #4EC9CD }
.seabold { background: #4EC9CD ; font-weight: bold; }
.sky  { background: #DDA8F4 }
.skybold  { background: #DDA8F4 ; font-weight: bold; }
.rose { background: #B3B6F5 }
.rosebold { background: #B3B6F5 ; font-weight: bold;}
.gray { background: #BCC3CA }
.graybold { background: #BCC3CA ; font-weight: bold;}
.darkgray { background: #B6AEB2}
.darkgraybold { background: #B6AEB2 ; font-weight: bold;}
.peach { background: #FDBB8F }
.peachbold { background: #FDBB8F ; font-weight: bold;}
.purple { background: #B3B6F5 }
.purplebold { background: #B3B6F5 ; font-weight: bold;}
.white {background: #FAF8F8}
.whitebold {background: #FAF8F8; font-weight: bold;}
</style>
<br>
"@
#Old formatting. Kept for reference
    #tr:nth-child(odd) {background-color:#d3d3d3;}
    #tr:nth-child(even) {background-color:white;}

    #Set variables
    $curloc = Get-Location
    Set-Location -Path $PSScriptRoot
    Set-Location -Path ..\Output
    $outloc = Get-Location
    $HTMLFile = "$outloc\$HTMLOutput"
    New-Item $HTMLFile -type file -force | out-null
    $UniqueOwner = @()

    $script:html = @()
    [xml]$script:html = $ArrayInput | Select-Object Owner, Player, Team, Position, ADP, ADPRound, DraftedPosition, DraftedRound, KeeperPosition, KeeperRound, KeeperValue | ConvertTo-Html -Fragment

    #Capture Each unique owner
    Write-Verbose "Capture Each Unique Owner"
    1..($script:html.table.tr.count - 1) | ForEach-Object {
        $tdowner = $script:html.table.tr[$_].td[0]
        $UniqueOwner += $tdowner
    }
    $UniqueOwner = $UniqueOwner | Sort-Object | Get-Unique
    $BackgroundColors = @("tealoffwhite", "teal", "lime", "sand", "sea", "sky", "rose","darkgray","gray", "peach", "purple", "white")
    Write-Verbose "Background Color Array: $BackgroundColors"

    #Loop through each owner and set a unique background color
    Write-Verbose "Array of Unique Owners: $UniqueOwner"
    $i = 0
    $owneradparray = @()
    foreach ($owner in $UniqueOwner) {
        $ownerbgcolor = $BackgroundColors[$i]
        1..($script:html.table.tr.count - 1) | ForEach-Object {
            $class = $script:html.CreateAttribute("class")
            $td = $script:html.table.tr[$_]
            #$owneradparray += $script:html.table.tr[$_].td[9]
            if ($owner -like $script:html.table.tr[$_].td[0]) {
                $class.value = "$ownerbgcolor"
                $td.attributes.append($class) | Out-Null
                $obj = @()
                $obj = "" | Select-Object Owner, Row, ADPValue, BGColor
                $obj.Owner = $owner
                $obj.BGColor = $ownerbgcolor
                $obj.Row = $_
                $obj.ADPValue = $script:html.table.tr[$_].td[10] -as [int16]
                if (!$obj.ADPValue) {
                    $obj.ADPValue = -180 -as [int16]
                }
                $owneradparray += $obj

            }
        }
        if ($i -eq 11) {
            $i = 0
        }
        else {
            $i = $i + 1
            $ownerbgcolor = ""

        }
    }

    #Bolds overall leader row in Keeper Value
    foreach ($owner in $UniqueOwner) {
        $class = $script:html.CreateAttribute("class")
        $Orderedadparray = $owneradparray | Where-Object { $_.Owner -like "*$owner*" } | Sort-Object -Property ADPValue -Descending
        $HighestADP = $Orderedadparray[0].ADPValue
        $HighestADPRow = $Orderedadparray[0].Row
        Write-Host "Owner:$owner highest value ADP is $HighestADP on Row:$HighestADPRow" -ForegroundColor DarkGreen
        $ADPHighBGColor = $Orderedadparray[0].BGColor + "bold"
        $class.value = "$ADPHighBGColor"
        $td = $script:html.table.tr[$HighestADPRow]
        $td.attributes.append($class) | Out-Null
    }

    #Bolds 2nd leader row in Keeper Value
    foreach ($owner in $UniqueOwner) {
        $class = $script:html.CreateAttribute("class")
        $Orderedadparray = $owneradparray | Where-Object { $_.Owner -like "*$owner*" } | Sort-Object -Property ADPValue -Descending
        $2ndHighestADP = $Orderedadparray[1].ADPValue
        $2ndHighestADPRow = $Orderedadparray[1].Row
        $ADPHighBGColor = $Orderedadparray[1].BGColor + "bold"
        $class.value = "$ADPHighBGColor"
        Write-Host "Owner:$owner 2nd highest value ADP is $2ndHighestADP on Row:$2ndHighestADPRow" -ForegroundColor DarkGreen
        $td = $script:html.table.tr[$2ndHighestADPRow]
        $td.attributes.append($class) | Out-Null
    }

    #Color codes positive, negative and NA in Keeper Value column.
    1..($script:html.table.tr.count - 1) | ForEach-Object {
        $td = $script:html.table.tr[$_]
        $class = $script:html.CreateAttribute("class")

        #set the class value based on the item value of ADP
        $adpvalue = $td.childnodes.item(10)."#text" -as [int]
        if ($adpvalue -ge 0) {
            $class.value = "good"
        }
        elseif ($td.childnodes.item(10)."#text" -ne "NA") {
            $class.value = "bad"
        }
        else {
            $class.value = "other"
        }

        $td.childnodes.item(10).attributes.append($class) | Out-Null
    }

    ConvertTo-HTML -Head $style -Body $script:html.InnerXml | Out-file $HTMLOutput -Append -Encoding "ASCII"
    #Get-Content $HTMLOutput | Set-Content $HTMLOutput -Encoding UTF8
    #Restore User location
    Set-Location $curloc
}
