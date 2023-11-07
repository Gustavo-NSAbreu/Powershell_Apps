$teleportDirectories = @{
    "directory_name" = "C:\directory\path";
  }
  function to {
  param (
      [string]$d
  )

  if ($teleportDirectories.ContainsKey($d)) {
      Set-Location -Path $teleportDirectories[$d]
  } else {
      Write-Host "Directory '$d' not found in predefined directories."
  }
}