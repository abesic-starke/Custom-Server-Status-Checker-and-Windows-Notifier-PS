# Ensure BurntToast module is installed, if not, install it
if (-not (Get-Module -ListAvailable -Name BurntToast)) {
    Install-Module -Name BurntToast -Force
}

Import-Module BurntToast

$server = "5.252.102.141"
$port = 26900
$interval = 10  # Interval in seconds
$previousStatus = $null

function Write-Color {
    param (
        [string]$Text,
        [System.ConsoleColor]$Color
    )
    $oldColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Output $Text
    $Host.UI.RawUI.ForegroundColor = $oldColor
}

function Test-TCPConnection {
    param (
        [string]$ComputerName,
        [int]$Port
    )

    $tcpConnection = Test-NetConnection -ComputerName $ComputerName -Port $Port
    $currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($tcpConnection.TcpTestSucceeded) {
        $latency = [math]::Round($tcpConnection.PingMsec, 2)
        if ($latency -lt 300) {
            $latencyColor = [System.ConsoleColor]::Green
        } elseif ($latency -lt 700) {
            $latencyColor = [System.ConsoleColor]::Yellow
        } else {
            $latencyColor = [System.ConsoleColor]::Red
        }

        Write-Color -Text "$currentTime - Server is OPEN. Latency: $latency ms" -Color Green
        Write-Color -Text "$currentTime - Latency: $latency ms" -Color $latencyColor

        if ($previousStatus -ne "OPEN") {
            # Show notification if the server status changes to OPEN
            New-BurntToastNotification -Text "Server Status", "Server is OPEN. Latency: $latency ms"
            $previousStatus = "OPEN"
        }
    } else {
        Write-Color -Text "$currentTime - Server is CLOSED." -Color Red
        $previousStatus = "CLOSED"
    }
}

# Interval checking loop
while ($true) {
    Test-TCPConnection -ComputerName $server -Port $port
    Start-Sleep -Seconds $interval
}
