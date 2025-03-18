function upall {
    Write-Host "Starting package update process..." -ForegroundColor Cyan

    # Get Desktop path and existing shortcuts
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $preUpdateShortcuts = Get-ChildItem -Path $desktopPath -Filter *.lnk -File | Select-Object -ExpandProperty FullName

    Write-Host "Running winget upgrade for all packages..." -ForegroundColor Green
    # Winget command to upgrade all packages
    winget upgrade --all -h --include-unknown --accept-package-agreements --accept-source-agreements

    # Allow time for any potential desktop shortcuts to be created
    Start-Sleep -Seconds 5

    # Get list of desktop shortcuts (post-update)
    $postUpdateShortcuts = Get-ChildItem -Path $desktopPath -Filter *.lnk -File | Select-Object -ExpandProperty FullName

    # Identify shortcuts that were not present before the update
    $newShortcuts = Compare-Object -ReferenceObject $preUpdateShortcuts -DifferenceObject $postUpdateShortcuts |
    Where-Object { $_.SideIndicator -eq '=>' } |
    ForEach-Object { $_.InputObject }

    if ($newShortcuts) {
        Write-Host "Removing $($newShortcuts.Count) new desktop shortcut(s)..." -ForegroundColor Yellow
        foreach ($shortcut in $newShortcuts) {
            try {
                Remove-Item -Path $shortcut -Force -ErrorAction Stop
                Write-Host "Removed: $shortcut"
            }
            catch {
                Write-Warning "Could not remove shortcut: $shortcut. Error: $_"
            }
        }
    }
    else {
        Write-Host "No new desktop shortcuts found after updates." -ForegroundColor Green
    }
    
    Write-Host "Update process complete." -ForegroundColor Cyan
}

upall
