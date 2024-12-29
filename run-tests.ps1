# Ensure the script exits on errors
$ErrorActionPreference = "Stop"

# Path to the adb executable
$adbPath = "adb"  # Assuming adb is added to your PATH. Replace with the full path if necessary.

# Test package configuration
$testPackage = "com.example.hedieaty_gift_app_viiix"        # Replace with your test package name
$testRunner = "androidx.test.runner.AndroidJUnitRunner"  # Default test runner
$apkPath = "build/app/outputs/flutter-apk/app-release.apk"       # Replace with the actual path to your test APK

# Logging setup
$logFile = "./test-log.txt"
Write-Output "Logging test results to $logFile..."
if (Test-Path $logFile) { Remove-Item $logFile }

# Ensure at least one device is connected
Write-Output "Checking for connected devices..."
$devices = & $adbPath devices | Select-String "device$" | ForEach-Object { ($_ -split "`t")[0] }

if (-not $devices) {
    Write-Error "No devices/emulators connected. Please connect a device and try again."
    Exit 1
}

# Output connected devices
Write-Output "Devices connected: $devices"
Write-Output "`nConnected devices: $devices" | Out-File -Append $logFile

# Install the test APK on each device
foreach ($device in $devices) {
    Write-Output "Installing test APK on device $device..."
    & $adbPath -s $device install -r $apkPath | Out-File -Append $logFile
    Write-Output "APK installed on $device." | Out-File -Append $logFile
}

# Run tests on each device
foreach ($device in $devices) {
    Write-Output "Running tests on device $device..."
    $testCommand = "$adbPath -s $device shell am instrument -w -r $testPackage/$testRunner"
    Write-Output "Executing: $testCommand"
    $testResults = & cmd /c $testCommand
    $testResults | Out-File -Append $logFile

    # Optional: Output to console
    Write-Output $testResults
}

# Pull logs for debugging (optional)
foreach ($device in $devices) {
    $logcatFile = "./logcat-$device.txt"
    Write-Output "Pulling logcat for $device to $logcatFile..."
    & $adbPath -s $device logcat -d > $logcatFile
}

Write-Output "`nTest execution completed. Results saved to $logFile and logcat files."
