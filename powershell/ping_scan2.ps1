
$slice_size = 15
$subnet = "192.168.24"

$addresses = @()

foreach ($octet in 1 .. 255) 
{
$addr = "$subnet.$octet"
$addresses += $addr

if ($octet % $slice_size -eq 0) {

#write-host $addresses
Write-Progress -Activity "Ping scan of $subnet subnet" -status "Pinging [$addresses]" -PercentComplete (($octet/255)*100)
Test-Connection -ComputerName $addresses -TimeToLive 1
$addresses.Clear()

}

}
