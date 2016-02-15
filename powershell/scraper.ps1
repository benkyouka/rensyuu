$base = "http://forum.scanlover.com/showthread.php"
#New-Item -Path "0.html" -ItemType File

 $topics ="91648","91586","91585","91649","91706"


foreach ($topic in $topics) {
 ## fetch the first page, get the # of pages out of it
 $uri = "$base`?t=$topic&page=1"
 $response = Invoke-WebRequest -Uri $uri -SessionVariable session

 $links = $response.Links | where-object {  $_.href -Match "showthread`.php" -And $_.href -Match "t=$topic" -And $_.href -Match "page=\d+$" }

 $lastpage=1
 foreach ($link in $links)
 {
  if ($link.href -Match "\d+$")
  {
      if ($matches[0] -gt $lastpage)
     {
        $lastpage = $matches[0];
     }
  }
 }

 foreach ($page in 1 .. $lastpage) {
 $uri = "$base`?t=$topic&page=$page"
 echo $uri
 $response = Invoke-WebRequest -Uri $uri
 $response.Content > "$topic`_$page.html"
 Start-Sleep 15
 }
 }