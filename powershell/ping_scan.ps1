foreach ($octet in 2 .. 70) 
{
$subnet = "192.168.1"
$addr = "$subnet.$octet"
Write-Progress -Activity "Ping scan of $subnet subnet" -status "Pinging [$addr]" -PercentComplete (($octet/255)*100)
if (Test-Connection -ComputerName $addr -Quiet -TimeToLive 1)
{
write-host "$addr is pingable"
}
}
