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

Get-VMIP