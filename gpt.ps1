# Get all the running VMs in the Hyper-V environment
$vms = Get-VM | Where-Object {$_.State -eq "Running"}

# Get the host file path
$hostFile = "$env:windir\system32\drivers\etc\hosts"

# Loop through each running VM
foreach ($vm in $vms) {
    # Get the IP address of the VM
    $ipAddress = (Get-VMNetworkAdapter -VMName $vm.Name).IPAddresses[0]

    # Check if the IP address already exists in the host file
    $entryExists = Select-String -Path $hostFile -Pattern $ipAddress

    # If the entry does not exist, add it to the host file
    if (!$entryExists) {
        # Get the hostname of the VM
        $hostName = $vm.Name
        # Add the entry to the host file
        Add-Content -Path $hostFile -Value "$ipAddress $hostName"
    } 
    # If the entry exists, edit it in the host file
    else {
        # Get the line number of the entry
        $lineNumber = $entryExists.LineNumber
        # Read the host file into an array
        $lines = Get-Content -Path $hostFile
        # Update the hostname in the entry
        $lines[$lineNumber - 1] = "$ipAddress $hostName"
        # Write the updated array back to the host file
        Set-Content -Path $hostFile -Value $lines
    }
}
