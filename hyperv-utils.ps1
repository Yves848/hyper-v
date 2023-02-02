Import-Module Hyper-V

class vmIP {
  [string]$name
  [string]$ip 

  vmip(
    [string]$name,
    [string]$ip
  ){
    $this.ip = $ip
    $this.name = $name
  }
}

function Get-VMIP {
  [Microsoft.HyperV.PowerShell.VirtualMachine[]]$vms = @()
  $vms = Get-VM
  [vmIP[]]$ips = @()
  foreach($vm in $vms) {
    [Microsoft.HyperV.PowerShell.VMNetworkAdapter[]]$network = $vm.NetworkAdapters
    $ip = $network.IPAddresses[0]
    $name = $vm.Name
    #Write-Host ('Name : {0} IP : {1}' -f ($name,$ip)) 
    $vmIP = [vmIp]::new($name,$ip)
    $ips += $vmIP
  }
  return $vmIP
}

function Update-Hosts {
  [vmip[]]$IPS = Get-VMIP
  $hosts = Get-Content C:\Windows\System32\drivers\etc\hosts
  $newhosts = 'hosts2'
  Remove-Item -Path $newhosts -ErrorAction Ignore
  foreach($line in $hosts) {
    if (-not ([string]$line).StartsWith('#') -and -not $line.Trim() -eq '') {
      $ip,$name = $line -split " "
      Write-Host ('Name : {0} IP : {1}' -f ($name,$ip))
      $index = $IPS.IndexOf($name)

    }
    $line | Out-File $newhosts -Append
  }
  
}

Update-Hosts
Get-VMIP