#$idle = 1000
$idle = (5 * ( 60 * 1000 ))
$br_low = "10%"
$br_high = "100%"
$state = "normal"
$power_state = $null
$exclude_instances = @("vlc", "crx_agimnkijcaahngcdmfeangaknmldooml")

function idle_time {
    return [int](xprintidle)
}

function is_connected {
    $ac_path = "/sys/class/power_supply/AC/online"
    if (Test-Path $ac_path) {
	$status = Get-Content $ac_path
	return ($status -eq "1")
    }
    return $false
}

function get_focus {
    $win_id = (xdotool getwindowfocus).Trim()
    if (-not $win_id) {return ""}

    $wm_class = xprop -id $win_id | Where-Object { $_ -like '*WM_CLASS*' }
    $inst = ($wm_class -split '"')[1]
    return $inst
}

while ($true) {
    $idle_ms = idle_time
    $current_instance = get_focus

    Write-Host "Idle: $idle_ms, State: $state, Focused: $current_instance"

    $exclude = $false
    foreach ($instance in $exclude_instances) {
	if ($current_instance -like "*$instance*") {
	    $exclude = $true
	    break
	}
    }

    if ($idle_ms -ge $idle -and $state -eq "normal" -and -not $exclude) {
	brightnessctl set $br_low
	$state = "dimmed"
    }

    if ($idle_ms -lt $idle -and $state -eq "dimmed") {
	brightnessctl set $br_high
	$state = "normal"
    }

    if ($state -eq "normal") {
        Start-Sleep -Seconds 10
    } elseif ($state -eq "dimmed") {
        Start-Sleep -Milliseconds 100
    }

    if (-not (is_connected)) {
        xsetroot -name "[          NOT CHARGING          ]"
        Start-Sleep -Milliseconds 500
        continue
    }
}
