function Get-CronFromSchedule {
    [CmdletBinding()]
    param (
        # InputSchedule
        [Parameter(mandatory=$true)]
        [array]
        $InputSchedule
    )
    
    begin {
        $weekdays =[ordered]@{
            'Sunday' = 64
            'Monday' = 1
            'Tuesday' = 2
            'Wednesday' = 4
            'Thursday' = 8
            'Friday' = 16
            'Saturday' = 32
        }
        
        $schedulehour = $null
        $scheduleminute = $null
        $scheduledaysofweek = @()
    }
    
    process {
        foreach ($schedule in $InputSchedule) {
            if ($schedule.daysToBuild -eq 'all') {
                $bitvalue = ($weekdays.Values | Measure-Object -Sum).Sum
            }elseif ($schedule.daysToBuild -in $weekdays.Keys) {
                $bitvalue = $weekdays[$schedule.daysToBuild]
            }else{
                $bitvalue = $schedule.daysToBuild
            }

            if ($bitvalue -gt 0) {
                $weekdays.getenumerator() | ForEach-Object{
                    if($_.value -band $bitvalue){
                        # $_.key
                        $targetdayofweekint = $($weekdays.keys).indexOf($_.key)
                        $currentdayofweekint = (Get-date).DayOfWeek.value__
                        
                        $targetdate = (Get-Date).AddDays($currentdayofweekint + ($targetdayofweekint - $currentdayofweekint)).ToString('yyyy-MM-dd')
                        $targettime = (Get-Date -Hour $schedule.startHours -Minute $schedule.startMinutes ).ToString('HH:mm:ss')
                        
                        $datetimetoconvert = Get-Date -Date "$targetdate $targettime" 

                        $datetimetoconvertsingle = (Get-Date -Hour $schedule.startHours -Minute $schedule.startMinutes ).AddDays($currentdayofweekint + ($targetdayofweekint - $currentdayofweekint)).ToString('yyyy-MM-dd HH:mm:ss')
                        
                        $SourceTimezone = [System.TimeZoneInfo]::FindSystemTimeZoneById($schedule.timezoneid)
                        $utcdatetimeobject = [System.TimeZoneInfo]::ConvertTimeToUtc($datetimetoconvert, $SourceTimezone)
                        # $utcdatetimeobject
                
                        $schedulehour = $utcdatetimeobject.Hour
                        $scheduleminute = $utcdatetimeobject.Minute
                        $scheduledaysofweek += $utcdatetimeobject.DayOfWeek.value__
                        # $($weekdays.keys).indexOf("Saturday") 
                        # $utcdatetimeobject.DayOfWeek.value__
                        #### timezone "India Standard Time" +5:30
                    }
                }
                
                $CRON = "$scheduleminute $schedulehour * * $($scheduledaysofweek -join ',')"
                return $CRON
            }
        }
    }
    
    end {
        
    }
}