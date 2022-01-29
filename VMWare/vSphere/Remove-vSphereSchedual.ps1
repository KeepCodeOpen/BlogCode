<# This script removes all scheduals for your selected VM, you can also use wildcard (*) to select all VM's that are staring with 
PersonalVDI* #>

function Remove-vSphereSchedual {
    param(
        [Parameter(Mandatory)][string]$VDIName,
        [Parameter(Mandatory)][string]$VIServer,
        [Parameter(Mandatory)][string]$VIUsername,
        [Parameter(Mandatory)][SecureString]$VIPassword
    )

    Connect-VIServer -Server $VIServer -User $VIUsername -Password $VIPassword

    $CollectVMs = Get-VM -name $VDIName

    foreach ($vm in $CollectVMs) {
        $vmObj = Get-VM -Name $vm
        $si = Get-View ServiceInstance
        $scheduledTaskManager = Get-View $si.Content.ScheduledTaskManager
        Get-View -Id $scheduledTaskManager.ScheduledTask |
        Where-Object { $vmObj.ExtensionData.MoRef -contains $_.Info.Entity } | ForEach-Object {
            $_.RemoveScheduledTask()
        }
    }

    Disconnect-VIServer -Server $VIServer -Force -Confirm:$false
}