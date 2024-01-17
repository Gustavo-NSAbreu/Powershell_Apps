$haltDictionary = @{
  'app1' = 'Application 1';
}

function halt {
    [CmdletBinding(DefaultParameterSetName='p')]
    param (
        [Parameter(ParameterSetName='p', Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [int]$p,

        [Parameter(ParameterSetName='n', Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [string]$n
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'p' {
                Get-Process -Id (Get-NetTCPConnection -LocalPort $p -State Listen).OwningProcess | Stop-Process
                Write-Host "Application on port $p has stopped successfully."
            }
            'n' {
                if ($haltDictionary.ContainsKey($n)) {
                    Stop-Process -Name $haltDictionary[$n]
                    Write-Host "$haltDictionary[$n] has stopped successfully."
                } else {
                    Write-Host "$n was not found in predefined applications."
                }
            }
        }
    }
}
