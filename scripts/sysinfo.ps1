xset s off
xset -dpms
xset s noblank

while ($true) {
    $wifi = (nmcli -t -f active,ssid dev wifi | grep '^yes' | ForEach-Object {
		($_ -split ':')[1]
	    })
    if ($wifi -eq $null) {
	$wifi = "N\A"
    }

    try {
	$day = Get-Date -Format "dddd"
	$date = Get-Date -Format "dd-MM-yy"
	$time = Get-Date -Format "hh:mm:ss tt"
    } catch {
	$day = "N\A"
	$date = "N\A"
        $time = "N\A"
    }

    $status = "  ╠═══╣ $wifi ╠═╣ $day ▊ $date ▊ $time ╠═══╣ "
    xsetroot -name $status

    Start-Sleep -Seconds 1
} 
