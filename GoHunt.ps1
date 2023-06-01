Function Find-UserSession {
    [cmdletbinding()]
    param(
        [parameter(mandatory)]
        [string]$Username
    )

    $computers = Get-WmiObject -Namespace root\directory\ldap -Class ds_computer | Where-Object {$_.DS_operatingSystem -eq 'Windows 10 Enterprise' -and $_.DS_lastLogonTimestamp -le ((Get-Date).AddHours(-24)).Ticks} | select ds_cn 

    foreach ($comp in $computers) {
        $Computer = $comp.ds_cn
        Write-Verbose "Try to access $computer"
        #Get explorer.exe processes
        $proc = gwmi win32_process -computer $Computer -Filter "Name = 'explorer.exe'" -ErrorAction SilentlyContinue 
        
        #Search collection of processes for username
        ForEach ($p in $proc) {
            $temp = ($p.GetOwner()).User
            if ($temp -eq $Username) {
                write-host -ForegroundColor Green "$Username is logged on $Computer"
            }
        }
    }
}
