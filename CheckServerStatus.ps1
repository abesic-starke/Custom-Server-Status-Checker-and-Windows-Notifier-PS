$server = "5.252.102.141"
$port = 26900

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
    if ($tcpConnection.TcpTestSucceeded) {
        $latency = [math]::Round($tcpConnection.PingMsec, 2)
        if ($latency -lt 300) {
            $latencyColor = [System.ConsoleColor]::Green
        } elseif ($latency -lt 700) {
            $latencyColor = [System.ConsoleColor]::Yellow
        } else {
            $latencyColor = [System.ConsoleColor]::Red
        }

        Write-Color -Text "Server is OPEN." -Color Green
        Write-Color -Text "Latency: $latency ms" -Color $latencyColor
    } else {
        Write-Color -Text "Server is CLOSED." -Color Red
    }
}

# Test TCP Connection
Test-TCPConnection -ComputerName $server -Port $port
