$summonDirectories = @{
  "app" = "C:\app\path";
}

function summon {
param (
    [string]$d
)

if ($summonDirectories.ContainsKey($d)) {
    Start-Process $summonDirectories[$d]
} else {
    Write-Host "Directory '$d' not found in predefined directories."
}
}