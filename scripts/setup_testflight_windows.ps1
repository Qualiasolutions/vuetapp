# ===============================================================================
# Vuet TestFlight Setup Script for Windows
# ===============================================================================
# This script helps set up GitHub repository secrets and provides instructions
# for preparing TestFlight deployment from Windows using GitHub Actions.
#
# Author: Factory AI Assistant
# Date: June 1, 2025
# ===============================================================================

param(
    [switch]$Help,
    [switch]$SetupSecrets,
    [switch]$CheckStatus,
    [switch]$TriggerDeploy,
    [SecureString]$AppSpecificPassword,
    [string]$CertificatePath = "",
    [string]$ProvisioningProfilePath = ""
)

# Colors for output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Cyan"

function Write-ColoredOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-ColoredOutput "=== $Title ===" $Blue
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-ColoredOutput "✓ $Message" $Green
}

function Write-Error {
    param([string]$Message)
    Write-ColoredOutput "✗ ERROR: $Message" $Red
}

function Write-Warning {
    param([string]$Message)
    Write-ColoredOutput "⚠ WARNING: $Message" $Yellow
}

function Write-Info {
    param([string]$Message)
    Write-ColoredOutput "ℹ $Message"
}

function Show-Help {
    Write-Section "Vuet TestFlight Setup for Windows"
    
    Write-Host "This script helps you prepare your Flutter app for TestFlight deployment using GitHub Actions."
    Write-Host ""
    Write-Host "USAGE:"
    Write-Host "  .\setup_testflight_windows.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "OPTIONS:"
    Write-Host "  -Help                    Show this help message"
    Write-Host "  -SetupSecrets           Guide through GitHub secrets setup"
    Write-Host "  -CheckStatus            Check deployment status"
    Write-Host "  -TriggerDeploy          Trigger manual deployment"
    Write-Host ""
    Write-Host "PARAMETERS:"
    Write-Host "  -AppSpecificPassword    Your Apple app-specific password"
    Write-Host "  -CertificatePath        Path to your .p12 certificate file"
    Write-Host "  -ProvisioningProfilePath Path to your .mobileprovision file"
    Write-Host ""
    Write-Host "EXAMPLES:"
    Write-Host "  .\setup_testflight_windows.ps1 -SetupSecrets"
    Write-Host "  .\setup_testflight_windows.ps1 -TriggerDeploy"
    Write-Host ""
}

function Test-Prerequisites {
    Write-Section "Checking Prerequisites"
    
    $allGood = $true
    
    # Check if git is installed
    try {
        $gitVersion = git --version
        Write-Success "Git found: $gitVersion"
    } catch {
        Write-Error "Git is not installed. Please install Git for Windows."
        $allGood = $false
    }
    
    # Check if we're in a git repository
    try {
        $gitRemote = git remote -v 2>$null
        if ($gitRemote) {
            Write-Success "Git repository detected"
            Write-Info "Remote: $($gitRemote | Select-Object -First 1)"
        } else {
            Write-Warning "No git remote found. Make sure this is pushed to GitHub."
        }
    } catch {
        Write-Error "Not in a git repository"
        $allGood = $false
    }
    
    # Check if GitHub CLI is installed (optional but helpful)
    try {
        $ghVersion = gh --version 2>$null
        Write-Success "GitHub CLI found: $($ghVersion | Select-Object -First 1)"
    } catch {
        Write-Warning "GitHub CLI not found. Install it for easier secret management: https://cli.github.com/"
    }
    
    # Check if workflow file exists
    if (Test-Path ".github/workflows/ios_testflight.yml") {
        Write-Success "GitHub Actions workflow file found"
    } else {
        Write-Error "GitHub Actions workflow file not found at .github/workflows/ios_testflight.yml"
        $allGood = $false
    }
    
    return $allGood
}

function Show-SecretsSetup {
    Write-Section "GitHub Repository Secrets Setup"
    
    Write-Info "You need to add these secrets to your GitHub repository:"
    Write-Host ""
    
    $secrets = @(
        @{Name="APPLE_ID"; Description="Your Apple Developer account email"; Example="p_ferraby@yahoo.com"}
        @{Name="APPLE_PASSWORD"; Description="App-specific password from appleid.apple.com"; Example="xxxx-xxxx-xxxx-xxxx"}
        @{Name="BUILD_CERTIFICATE_BASE64"; Description="Base64 encoded .p12 certificate"; Example="Base64 string"}
        @{Name="P12_PASSWORD"; Description="Password for your .p12 certificate"; Example="your_cert_password"}
        @{Name="BUILD_PROVISION_PROFILE_BASE64"; Description="Base64 encoded .mobileprovision file"; Example="Base64 string"}
        @{Name="KEYCHAIN_PASSWORD"; Description="Temporary keychain password (can be any string)"; Example="temp_keychain_pass"}
        @{Name="SUPABASE_URL"; Description="Your Supabase project URL"; Example="https://xxx.supabase.co"}
        @{Name="SUPABASE_ANON_KEY"; Description="Your Supabase anonymous key"; Example="eyJhbGci..."}
    )
    
    foreach ($secret in $secrets) {
        Write-Host "• " -NoNewline -ForegroundColor Yellow
        Write-Host "$($secret.Name)" -ForegroundColor White -NoNewline
        Write-Host " - $($secret.Description)" -ForegroundColor Gray
        Write-Host "  Example: " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($secret.Example)" -ForegroundColor DarkGray
        Write-Host ""
    }
    
    Write-Section "How to Add Secrets"
    Write-Host "Method 1: Using GitHub Web Interface"
    Write-Host "1. Go to your repository on GitHub"
    Write-Host "2. Click Settings > Secrets and variables > Actions"
    Write-Host "3. Click 'New repository secret'"
    Write-Host "4. Add each secret listed above"
    Write-Host ""
    
    Write-Host "Method 2: Using GitHub CLI (if installed)"
    Write-Host "Run these commands after replacing the values:"
    Write-Host ""
    Write-ColoredOutput "gh secret set APPLE_ID --body `"p_ferraby@yahoo.com`"" $Yellow
    Write-ColoredOutput "gh secret set APPLE_PASSWORD --body `"your-app-specific-password`"" $Yellow
    Write-Host "... (continue for all secrets)"
    Write-Host ""
    
    Write-Section "Certificate and Provisioning Profile Setup"
    Write-Host "To get BASE64 encoded certificate and provisioning profile:"
    Write-Host ""
    Write-Host "1. Export your iOS Distribution Certificate as .p12 from Keychain Access (macOS)"
    Write-Host "2. Download your App Store provisioning profile from Apple Developer portal"
    Write-Host "3. Convert to Base64:"
    Write-Host ""
    Write-ColoredOutput "# For certificate (run on macOS or use online converter):" $Yellow
    Write-ColoredOutput "base64 -i YourCertificate.p12 | pbcopy" $Yellow
    Write-Host ""
    Write-ColoredOutput "# For provisioning profile:" $Yellow
    Write-ColoredOutput "base64 -i YourProfile.mobileprovision | pbcopy" $Yellow
    Write-Host ""
    Write-Warning "If you don't have a Mac, you can use online Base64 converters (ensure they're secure)"
}

function Convert-ToBase64 {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return $null
    }
    
    try {
        $bytes = [System.IO.File]::ReadAllBytes($FilePath)
        $base64 = [System.Convert]::ToBase64String($bytes)
        return $base64
    } catch {
        Write-Error "Failed to convert file to Base64: $_"
        return $null
    }
}

function Set-GitHubSecret {
    param([string]$Name, [string]$Value)
    
    try {
        # Try using GitHub CLI first
        gh secret set $Name --body $Value 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Secret '$Name' set successfully"
            return $true
        }
    } catch {
        # Fall back to instructions
    }
    
    Write-Warning "Please manually add this secret to GitHub:"
    Write-Host "Name: $Name"
    Write-Host "Value: $Value"
    Write-Host ""
    return $false
}

function Invoke-SetupSecrets {
    Write-Section "Interactive Secrets Setup"
    
    if (-not (Test-Prerequisites)) {
        Write-Error "Prerequisites not met. Please fix the issues above."
        return
    }
    
    # Apple ID
    $appleId = Read-Host "Enter your Apple ID (email)"
    if ($appleId) {
        Set-GitHubSecret "APPLE_ID" $appleId
    }
    
    # App-specific password
    if ($AppSpecificPassword) {
        $appPassword = $AppSpecificPassword
    } else {
        $appPassword = Read-Host "Enter your app-specific password" -AsSecureString
        $appPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($appPassword))
    }
    if ($appPassword) {
        Set-GitHubSecret "APPLE_PASSWORD" $appPassword
    }
    
    # Certificate
    if ($CertificatePath) {
        $certPath = $CertificatePath
    } else {
        $certPath = Read-Host "Enter path to your .p12 certificate file (or press Enter to skip)"
    }
    if ($certPath -and (Test-Path $certPath)) {
        $certBase64 = Convert-ToBase64 $certPath
        if ($certBase64) {
            Set-GitHubSecret "BUILD_CERTIFICATE_BASE64" $certBase64
            
            $certPassword = Read-Host "Enter certificate password" -AsSecureString
            $certPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($certPassword))
            Set-GitHubSecret "P12_PASSWORD" $certPassword
        }
    }
    
    # Provisioning profile
    if ($ProvisioningProfilePath) {
        $profilePath = $ProvisioningProfilePath
    } else {
        $profilePath = Read-Host "Enter path to your .mobileprovision file (or press Enter to skip)"
    }
    if ($profilePath -and (Test-Path $profilePath)) {
        $profileBase64 = Convert-ToBase64 $profilePath
        if ($profileBase64) {
            Set-GitHubSecret "BUILD_PROVISION_PROFILE_BASE64" $profileBase64
        }
    }
    
    # Other secrets
    $keychainPassword = Read-Host "Enter a temporary keychain password (any string)"
    if ($keychainPassword) {
        Set-GitHubSecret "KEYCHAIN_PASSWORD" $keychainPassword
    }
    
    $supabaseUrl = Read-Host "Enter your Supabase URL (or press Enter to skip)"
    if ($supabaseUrl) {
        Set-GitHubSecret "SUPABASE_URL" $supabaseUrl
    }
    
    $supabaseKey = Read-Host "Enter your Supabase anon key (or press Enter to skip)"
    if ($supabaseKey) {
        Set-GitHubSecret "SUPABASE_ANON_KEY" $supabaseKey
    }
    
    Write-Success "Secrets setup completed!"
    Write-Info "You can now trigger a deployment by pushing to main branch or running: .\setup_testflight_windows.ps1 -TriggerDeploy"
}

function Invoke-TriggerDeploy {
    Write-Section "Triggering TestFlight Deployment"
    
    try {
        # Try using GitHub CLI to trigger workflow
        gh workflow run "iOS TestFlight Deployment" --field deploy_to_testflight=true 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Deployment triggered successfully!"
            Write-Info "Check the Actions tab in your GitHub repository for progress."
        } else {
            throw "GitHub CLI failed"
        }
    } catch {
        Write-Warning "Could not trigger deployment automatically. Manual options:"
        Write-Host "1. Push changes to main branch:"
        Write-ColoredOutput "   git add ." $Yellow
        Write-ColoredOutput "   git commit -m `"Trigger TestFlight deployment`"" $Yellow
        Write-ColoredOutput "   git push origin main" $Yellow
        Write-Host ""
        Write-Host "2. Or go to GitHub Actions tab and manually run 'iOS TestFlight Deployment' workflow"
    }
}

function Invoke-CheckStatus {
    Write-Section "Checking Deployment Status"
    
    try {
        $runs = gh run list --workflow="iOS TestFlight Deployment" --limit=5 --json=status,conclusion,createdAt,url 2>$null
        if ($LASTEXITCODE -eq 0) {
            $runsObj = $runs | ConvertFrom-Json
            Write-Host "Recent workflow runs:"
            foreach ($run in $runsObj) {
                $status = $run.status
                $conclusion = $run.conclusion
                $date = $run.createdAt
                $url = $run.url
                
                $statusColor = switch ($conclusion) {
                    "success" { $Green }
                    "failure" { $Red }
                    "cancelled" { $Yellow }
                    default { "White" }
                }
                
                Write-Host "• " -NoNewline
                Write-ColoredOutput "$status/$conclusion" $statusColor -NoNewline
                Write-Host " - $date"
                Write-Host "  URL: $url"
            }
        } else {
            throw "GitHub CLI failed"
        }
    } catch {
        Write-Warning "Could not check status automatically."
        Write-Info "Please check the Actions tab in your GitHub repository."
    }
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

if ($SetupSecrets) {
    Invoke-SetupSecrets
    exit 0
}

if ($CheckStatus) {
    Invoke-CheckStatus
    exit 0
}

if ($TriggerDeploy) {
    Invoke-TriggerDeploy
    exit 0
}

# Default: Show help and setup information
Write-Section "Vuet TestFlight Setup for Windows"
Write-Info "Use -Help to see all available options"
Write-Host ""

if (-not (Test-Prerequisites)) {
    Write-Host ""
    Write-Error "Some prerequisites are missing. Please fix them before proceeding."
    exit 1
}

Write-Host "Quick start:"
Write-Host "1. Run: " -NoNewline
Write-ColoredOutput ".\setup_testflight_windows.ps1 -SetupSecrets" $Yellow
Write-Host "2. Then: " -NoNewline  
Write-ColoredOutput ".\setup_testflight_windows.ps1 -TriggerDeploy" $Yellow
Write-Host ""

Show-SecretsSetup
