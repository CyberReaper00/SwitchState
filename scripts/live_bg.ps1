
# --- Configuration ---
$VideoPath = "/home/nixos/Downloads/live-bridge.mp4" # Path to your video file

# --- Kill any potentially conflicting processes ---
Write-Host "Attempting to kill existing mpv and xwinwrap processes..."
try {
    # Use pkill for simplicity as it's a common Linux utility
    & pkill mpv 2>&1 | Out-Null
    & pkill xwinwrap 2>&1 | Out-Null
    Write-Host "Cleaned up old processes (if any were running)."
}
catch {
    Write-Warning "Could not kill processes. They might not be running or pkill is not available."
}

# --- Step 1: Launch mpv (it will create its own window) ---
Write-Host "Launching mpv in the background..."
# mpv options:
# --no-border: Removes window decorations
# --loop: Loops the video indefinitely
# --no-audio: No audio output from the video
# --no-osc: Disables on-screen controls
# --no-input-default-bindings: Ignores default keyboard/mouse input bindings for mpv
# --vo=x11: Forces X11 video output (can sometimes help with driver issues, but often auto is fine)
# & : Runs the command in the background
try {
    $mpvProcess = Start-Process -FilePath "mpv" -ArgumentList "--no-border", "--loop", "--no-audio", "--no-osc", "--no-input-default-bindings", "--vo=x11", $VideoPath -PassThru -NoNewWindow
    $MPV_PID = $mpvProcess.Id
    Write-Host "mpv launched with PID: $MPV_PID"
}
catch {
    Write-Error "Failed to launch mpv. Please ensure mpv is installed and in your PATH."
    exit 1
}

# --- Step 2: Find the mpv window ID using xdotool ---
Write-Host "Waiting for mpv to create its window..."
Start-Sleep -Seconds 1 # Give mpv a moment to create its window

$MPV_WID = ""
$retries = 10
while (-not $MPV_WID -and $retries -gt 0) {
    # Search for the mpv window by its PID and class name
    # tail -1 is used to get the latest (usually the one just launched)
    try {
        $MPV_WID = (& xdotool search --pid "$MPV_PID" --class "mpv" | Select-Object -Last 1).Trim()
    }
    catch {
        Write-Warning "xdotool search failed. Ensure xdotool is installed and in your PATH. Error: $($_.Exception.Message)"
    }
    if (-not $MPV_WID) {
        Write-Host "mpv window not found yet, retrying in 0.5 seconds... ($retries retries left)"
        Start-Sleep -Milliseconds 500
        $retries--
    }
}

if (-not $MPV_WID) {
    Write-Error "Could not find mpv window with PID $MPV_PID after multiple retries. Aborting."
    Stop-Process -Id $MPV_PID -Force -ErrorAction SilentlyContinue # Kill mpv if its window wasn't found
    exit 1
}

Write-Host "Found mpv window ID: $MPV_WID"

# --- Step 3: Use xdotool to configure the mpv window as a background ---
Write-Host "Configuring mpv window as desktop background..."

try {
    # Unmap the window temporarily to avoid flicker during resize/move
    & xdotool windowunmap "$MPV_WID"

    # Set the window size to fullscreen (100% width, 100% height)
    & xdotool windowsize "$MPV_WID" 100% 100%

    # Move the window to the top-left corner (0,0)
    & xdotool windowmove "$MPV_WID" 0 0

    # Map the window back (make it visible)
    & xdotool windowmap "$MPV_WID"

    # Set the window type to Desktop
    # This tells the window manager to treat it as a background window.
    # Note: "ATOM" and "_NET_WM_WINDOW_TYPE_DESKTOP" are X11 specific.
    & xdotool windowtype "$MPV_WID" "ATOM" "_NET_WM_WINDOW_TYPE_DESKTOP"

    # Lower the window to the bottom of the window stack
    & xdotool windowlower "$MPV_WID"

    # Make it sticky (visible on all virtual desktops/workspaces)
    & xdotool windowstick "$MPV_WID" on

    # Set window properties to hide it from taskbars/pagers and remove urgency hints
    # --state withdrawn can sometimes help keep it hidden from taskbar/pager
    & xdotool set_window --urgency off --skip-taskbar --skip-pager --state withdrawn "$MPV_WID"

    Write-Host "Background video setup complete."
    Write-Host "You may need to restart your window manager (DWM) or raise other application windows if they appear behind the video."
}
catch {
    Write-Error "An error occurred while configuring the mpv window with xdotool: $($_.Exception.Message)"
    Stop-Process -Id $MPV_PID -Force -ErrorAction SilentlyContinue
    exit 1
}
