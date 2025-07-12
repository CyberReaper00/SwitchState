# Requires PowerShell Core to be installed on Linux for /proc filesystem access.

# Get the PID of the DWM process.
# We use Get-Process with -Name "dwm" for exact matching.
# Filtering by Owner is important to ensure it's the current user's DWM.
# ErrorAction SilentlyContinue prevents errors if "dwm" process is not found.
$DWM_PID = $null
$DwmProcess = Get-Process -Name "dwm" -ErrorAction SilentlyContinue | Where-Object { $_.Owner -eq $env:USERNAME }
if ($DwmProcess) {
    $DWM_PID = $DwmProcess.Id
}

# Get all processes owned by the current user.
# $_.Owner property is available for processes in PowerShell Core on Linux.
$UserProcesses = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Owner -eq $env:USERNAME }

# --- Phase 1: Terminate processes gracefully (SIGTERM equivalent) ---
Write-Host "Attempting graceful termination of graphical applications (excluding DWM)..."
foreach ($Process in $UserProcesses) {
	$environPath = "/proc/$($Process.Id)/environ"
	Write-Host "`n----- Processing PID: $($Process.Id) ($($Process.ProcessName)) -----"
	Write-Host "Path: $environPath"

	# Check if the file exists to avoid errors for processes that might disappear
	if (Test-Path $environPath) {
		try {
			# Use [System.IO.File]::ReadAllBytes() to read the file content as raw bytes
			$envContentBytes = [System.IO.File]::ReadAllBytes($environPath)
			Write-Host "Content (Bytes): $($envContentBytes.Length) bytes"

			# $envContentBytes will be a byte array; printing it directly might show its type or individual bytes
			Write-Host "Content (Bytes): $($envContentBytes.Length) bytes"

			# To see the string content for debugging, you would convert it:
			# Note: Environ files are null-separated; a simple ASCII string conversion is needed for matching
			$envContentString = [System.Text.Encoding]::ASCII.GetString($envContentBytes) -replace "`0", ""
			Write-Host "Content (String part): $envContentString"

		} catch [System.UnauthorizedAccessException] {
			Write-Warning "Access denied to $environPath for process $($Process.Id) ($($Process.ProcessName))."

		} catch {
			Write-Warning "An error occurred while processing $environPath for process $($Process.Id) ($($Process.ProcessName)): $($_.Exception.Message)"

		}
	} else {
		Write-Host "Path: $environPath does not exist (process may have exited)."
	}
}

Write-Host "Waiting 5 seconds for processes to shut down..."
Start-Sleep -Seconds 5

# --- Phase 2: Force terminate any remaining processes (SIGKILL equivalent) ---
Write-Host "Attempting forceful termination of remaining graphical applications (excluding DWM)..."
# Re-get user processes as some might have terminated in Phase 1.
$UserProcesses = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Owner -eq $env:USERNAME }

foreach ($Process in $UserProcesses) {
    # Skip if the PID belongs to DWM and DWM was found.
    if ($DWM_PID -and $Process.Id -eq $DWM_PID) {
        continue
    }

    $environPath = "/proc/$($Process.Id)/environ"
    if (Test-Path $environPath) {
        $envContentBytes = Get-Content $environPath -Encoding Byte -Raw
        $envContentString = [System.Text.Encoding]::ASCII.GetString($envContentBytes)

        if ($envContentString -match "DISPLAY=") {
            Write-Host "  Forcefully stopping process $($Process.Id) ($($Process.ProcessName))..."
            # Stop-Process -Force sends a forceful termination signal (SIGKILL).
            Stop-Process -Id $Process.Id -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "Termination script completed."
