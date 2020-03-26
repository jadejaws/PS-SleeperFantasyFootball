# **PS-SleeperFantasyFootball**



## **Purpose**

The PS-SleeperFantasyFootball module is responsible for interacting with Fantasy Football APIs for automated reporting.
Comment-based help is available for all commands

------------



### **Language**

PowerShell

------------



### **Requirements**

The Fantasy module requires the following:
PowerShell 5.0 +

------------



### **Commands**


**Invoke-RosterExport **
The purpose of this function is to automate the Start-vCenterAudit process. It uses a json configuration file to populate values.
The json file should be formatted like the following example:
{
    "LeagueValues": {
        "league_id": "448327943836397568",
        "draft_id": "448327943836397569",
        "format": "standard",
        "teams": 12,
        "OwnerDraftOrder": [
            {"Owner":"TurfToe71", "DraftOrder": "7"},
            {"Owner":"Breakhislegs","DraftOrder": "6"},
            {"Owner":"jmen11","DraftOrder": "8"},
            {"Owner":"Topguny","DraftOrder": "2"},
            {"Owner":"AsylumJokers","DraftOrder": "12"},
            {"Owner":"HomerJSimpson","DraftOrder": "3"},
            {"Owner":"BHize","DraftOrder": "10"},
            {"Owner":"VTards","DraftOrder": "4"},
            {"Owner":"TacoCorpEb","DraftOrder": "1"},
            {"Owner":"Mrnix","DraftOrder": "11"},
            {"Owner":"SouthsideBrawlers","DraftOrder": "9"},
            {"Owner":"Jadejaws","DraftOrder": "5"}
        ]
    }
}

```powershell

Invoke-RosterExport -ConfigFile "C:\Temp\Config.json"
```
**Start-RosterExport**
Collects and exports to html format a report of a specified Sleeper league with values for ADP, last year draft result, keeper rounds and by team rosters.
Interacts with Sleeper and FantasyFootballCalculator APIs to automatically determine values.


------------

```powershell

Start-RosterExport -league_id $league_id -draft_id $draft_id -format standard -teams 12 -Verbose -ownerarray $arr
```

### **Credit**

Author
- Kevin McClure

------------