# Update-AllPackages.ps1
# A PS script to update all packages using Winget

function Update-AllPackages {
    # Check if Winget is installed
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Error "Winget is not installed or not found in PATH."
        return
    }

    # Check if running as administrator
    $isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "For best results, run this command as Administrator." -ForegroundColor Yellow
    }

    # Update Winget source
    Write-Host "Updating Winget source..."
    winget source update

    # Upgrade all packages, automatically accepting prompts
    Write-Host "Upgrading all packages..."
    winget upgrade --all --accept-package-agreements --accept-source-agreements --silent
}

# Define an alias for ease of use
Set-Alias -Name upall -Value Update-AllPackages -Description "Updates all packages using Winget"

# Export the function and alias
Export-ModuleMember -Function Update-AllPackages -Alias upall
