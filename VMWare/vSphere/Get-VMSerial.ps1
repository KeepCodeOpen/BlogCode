<# This Script get's the BIOS serialnumber from a VM and reports it back to the variable $VMName.
It also fromates it in the correct way. #>

function Get-VMSerial {
    param(
        [Parameter(Mandatory)][string]$VMName,
        [Parameter(Mandatory)][string]$VIServer,
        [Parameter(Mandatory)][string]$VIUsername,
        [Parameter(Mandatory)][SecureString]$VIPassword
    )
    Connect-VIServer -Server $VIServer -User $VIUsername -Password $VIPassword

    $s = ((Get-VM -Name $VMName).ExtensionData.Config.Uuid).Replace("-", "")
    $Uuid = "VMware-"
    for ($i = 0; $i -lt $s.Length; $i += 2) {
        $Uuid += ("{0:x2}" -f [byte]("0x" + $s.Substring($i, 2)))
        if ($Uuid.Length -eq 30) { $Uuid += "-" } else { $Uuid += " " }
    }

    $Uuid.TrimEnd()

    Disconnect-VIServer -Server $VIServer -Force -Confirm:$false
}