Function Find-UserSession {
$Username = Read-Host "Enter username you want to search for"

$computers = Get-WmiObject -Namespace root\directory\ldap -Class ds_computer | select ds_cn #add Where-Object {} filter

foreach ($comp in $computers)
	{
	$Computer = $comp.ds_cn
	$ping = new-object System.Net.NetworkInformation.Ping
  	$Reply = $null
  	$Reply = $ping.send($Computer)
  	if($Reply.status -like 'Success'){
		#Get explorer.exe processes
		$proc = gwmi win32_process -computer $Computer -Filter "Name = 'explorer.exe'"
		#Search collection of processes for username
		ForEach ($p in $proc) {
	    	$temp = ($p.GetOwner()).User
	  		if ($temp -eq $Username){
			write-host -ForegroundColor Green "$Username is logged on $Computer"
		}
      }
    }
  }
}
