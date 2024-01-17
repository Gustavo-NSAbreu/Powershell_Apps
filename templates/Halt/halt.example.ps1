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
                try {
                    $listeningProcesses = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction Stop
                    $listeningProcesses | ForEach-Object { Stop-Process -Id $_.OwningProcess }
                    Write-Host "Application on port $p has stopped successfully."
                } catch {
                    Write-Host "Error getting TCP connections: No process found listening on port $p."
                }
            }
            'n' {
                if ($haltDictionary.ContainsKey($n)) {
                    $processName = $haltDictionary[$n]
                    $runningProcesses = Get-Process -Name $processName -ErrorAction SilentlyContinue

                    if ($null -eq $runningProcesses) {
                        Write-Host "$processName has no running processes."
                        return
                    }

                    Stop-Process -Name $processName
                    Start-Sleep -Seconds 2

                    $runningProcesses = Get-Process -Name $processName -ErrorAction SilentlyContinue

                    if ($null -ne $runningProcesses) {
                        Write-Host "Error stopping $processName."
                    } else {
                        Write-Host "$processName has stopped successfully."
                    }
                } else {
                    Write-Host "$n was not found in predefined applications."
                }
            }
        }
    }
}
