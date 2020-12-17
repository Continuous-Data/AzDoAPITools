function Get-CronFromSchedule {
    [CmdletBinding()]
    param (
        # InputSchedule
        [Parameter(mandatory=$true)]
        [array]
        $InputSchedules
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
        foreach ($schedule in $InputSchedules) {
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

                        $targetdayofweekint = $($weekdays.keys).indexOf($_.key)
                        $currentdayofweekint = (Get-date).DayOfWeek.value__

                        $datetimetoconvert = Get-Date -Date (Get-Date -Hour $schedule.startHours -Minute $schedule.startMinutes -Second 00).AddDays($targetdayofweekint - $currentdayofweekint).ToString('yyyy-MM-dd HH:mm:ss')
                        
                        $SourceTimezone = [System.TimeZoneInfo]::FindSystemTimeZoneById($schedule.timezoneid)
                        
                        if($SourceTimezone.SupportsDaylightSavingTime -eq $true -and $datetimetoconvert.IsDaylightSavingTime() -eq $true){
                            $datetimetoconvert = $datetimetoconvert.AddHours(1)
                        }

                        $utcdatetimeobject = [System.TimeZoneInfo]::ConvertTimeToUtc($datetimetoconvert, $SourceTimezone)

                
                        $schedulehour = $utcdatetimeobject.Hour
                        $scheduleminute = $utcdatetimeobject.Minute
                        $scheduledaysofweek += $utcdatetimeobject.DayOfWeek.value__
                    }
                }
                
                $CRON = "$scheduleminute $schedulehour * * $($scheduledaysofweek -join ',')"
                return $CRON
            }
        }
    }

    end{

    }
}