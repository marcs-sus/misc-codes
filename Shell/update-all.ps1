function Update-AllPackages {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Keep newly created shortcuts instead of removing them")]
        [Alias("k", "keep-shortcuts")]
        [switch]$KeepShortcuts,
        
        [Parameter(HelpMessage = "Show detailed output during the update process")]
        [Alias("d", "detail")]
        [switch]$Detailed,

        [Parameter(HelpMessage = "Force update of all packages")]
        [Alias("f", "force-update")]
        [switch]$ForceUpdate
    )

    Write-Host "Starting package update process..." -ForegroundColor Cyan
    $startTime = Get-Date

    # Get Desktop path and existing shortcuts
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $preUpdateShortcuts = Get-ChildItem -Path $desktopPath -Filter *.lnk -File | Select-Object -ExpandProperty FullName
    
    if ($Detailed) {
        Write-Host "Found $($preUpdateShortcuts.Count) existing desktop shortcuts." -ForegroundColor Gray
    }

    # Winget command parameters with improved options
    $wingetParams = @(
        'upgrade',
        '--all',
        '--silent',
        '--include-unknown',
        '--ignore-warnings',
        '--disable-interactivity',
        '--accept-package-agreements',
        '--accept-source-agreements'
    )

    # Add optional parameters if requested
    if ($Detailed) {
        $wingetParams += '--verbose'
    }
    if ($ForceUpdate) {
        $wingetParams += '--force'
        Write-Host "Forcing update of all packages" -ForegroundColor Yellow
    }

    # Verify if Winget is available in the system PATH
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Error "Winget is not installed or not in your PATH. Please install Winget and try again."
        return
    }

    Write-Host "Running Winget upgrade for all packages..." -ForegroundColor Green
    try {
        # Execute Winget with parameters
        $startWinget = Get-Date
        & winget $wingetParams
        $endWinget = Get-Date
        $wingetDuration = $endWinget - $startWinget
        Write-Host "Winget execution completed in $($wingetDuration.Minutes)m $($wingetDuration.Seconds)s" -ForegroundColor Green
        $wingetSuccess = $true
    }
    catch {
        Write-Error "Error while running Winget: $_"
        $wingetSuccess = $false
    }

    if ($wingetSuccess -and -not $KeepShortcuts) {
        # Allow time for any potential desktop shortcuts to be created
        $waitTime = 5
        Write-Host "Waiting for potential shortcuts to be created..." -ForegroundColor Gray
        Start-Sleep -Seconds $waitTime

        # Get list of desktop shortcuts after the update
        $postUpdateShortcuts = Get-ChildItem -Path $desktopPath -Filter *.lnk -File | Select-Object -ExpandProperty FullName

        # Identify shortcuts that were not present before the update
        $newShortcuts = Compare-Object -ReferenceObject $preUpdateShortcuts -DifferenceObject $postUpdateShortcuts |
        Where-Object { $_.SideIndicator -eq '=>' } |
        ForEach-Object { $_.InputObject }

        if ($newShortcuts) {
            Write-Host "Removing $($newShortcuts.Count) new desktop shortcut(s)..." -ForegroundColor Yellow
            foreach ($shortcut in $newShortcuts) {
                try {
                    $shortcutName = Split-Path -Path $shortcut -Leaf
                    Remove-Item -Path $shortcut -Force -ErrorAction Stop
                    Write-Host "Removed: $shortcutName" -ForegroundColor Yellow
                }
                catch {
                    Write-Warning "Could not remove shortcut: $shortcutName. Error: $_"
                }
            }
        }
        else {
            Write-Host "No new desktop shortcuts found after updates." -ForegroundColor Green
        }
    }
    
    $endTime = Get-Date
    $duration = $endTime - $startTime
    Write-Host "Update process complete. Duration: $($duration.Minutes)m $($duration.Seconds)s" -ForegroundColor Cyan
}

# Define an alias for ease of use
Set-Alias -Name upall -Value Update-AllPackages -Description "Updates all packages using Winget and removes unwanted shortcuts"

# Export the function and alias if this script is imported as a module
Export-ModuleMember -Function Update-AllPackages -Alias upall
