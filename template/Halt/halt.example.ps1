function halt {
  param (
    [string]$port
  )

  Get-Process -Id (Get-NetTCPConnection -LocalPort $port -State Listen).OwningProcess | Stop-Process
  
}