# PowerShell script to prepare the Vuet App files for GitHub deployment

# Display current location for debugging
Write-Host "Current location: $PWD"

# Define directories
$SOURCE_DIR = "C:\Users\Mr Qualia\Desktop\V\Vuet-Supabase-Flutter\vuet_app"
$TARGET_DIR = "C:\Users\Mr Qualia\Desktop\V\Vuet-Supabase-Flutter\github_deploy"

Write-Host "=== Preparing Vuet App Files for GitHub Push ==="
Write-Host "Source directory: $SOURCE_DIR"
Write-Host "Target directory: $TARGET_DIR"

# Create target directory if it doesn't exist
if (-Not (Test-Path $TARGET_DIR)) {
    Write-Host "Creating $TARGET_DIR directory"
    New-Item -Path $TARGET_DIR -ItemType Directory -Force | Out-Null
} else {
    Write-Host "Cleaning $TARGET_DIR directory..."
    Remove-Item -Path "$TARGET_DIR\*" -Recurse -Force
}

# Copy necessary files for deployment
Write-Host "Copying essential files to $TARGET_DIR..."

# Core Flutter App
Copy-Item -Path "$SOURCE_DIR\lib" -Destination "$TARGET_DIR\lib" -Recurse -Force
Copy-Item -Path "$SOURCE_DIR\web" -Destination "$TARGET_DIR\web" -Recurse -Force
Copy-Item -Path "$SOURCE_DIR\pubspec.yaml" -Destination "$TARGET_DIR\" -Force
Copy-Item -Path "$SOURCE_DIR\pubspec.lock" -Destination "$TARGET_DIR\" -Force
Copy-Item -Path "$SOURCE_DIR\analysis_options.yaml" -Destination "$TARGET_DIR\" -Force

# GitHub and CI Files
New-Item -Path "$TARGET_DIR\.github\workflows" -ItemType Directory -Force | Out-Null
Copy-Item -Path "$SOURCE_DIR\.github\workflows\ci.yml" -Destination "$TARGET_DIR\.github\workflows\" -Force
Copy-Item -Path "$SOURCE_DIR\README.md" -Destination "$TARGET_DIR\" -Force

# Deployment Configuration
Copy-Item -Path "$SOURCE_DIR\vercel.json" -Destination "$TARGET_DIR\" -Force
New-Item -Path "$TARGET_DIR\scripts" -ItemType Directory -Force | Out-Null
Copy-Item -Path "$SOURCE_DIR\scripts\deploy.sh" -Destination "$TARGET_DIR\scripts\" -Force

# Copy assets directory if it exists
if (Test-Path "$SOURCE_DIR\assets") {
    Copy-Item -Path "$SOURCE_DIR\assets" -Destination "$TARGET_DIR\assets" -Recurse -Force
}

# Copy .env.example but not actual .env files
Copy-Item -Path "$SOURCE_DIR\.env.example" -Destination "$TARGET_DIR\" -Force

# Copy DEPLOYMENT_GUIDE.md
Copy-Item -Path "$SOURCE_DIR\DEPLOYMENT_GUIDE.md" -Destination "$TARGET_DIR\" -Force

# Copy .gitignore for GitHub
Copy-Item -Path "$SOURCE_DIR\.gitignore.github" -Destination "$TARGET_DIR\.gitignore" -Force

Write-Host "Files prepared in $TARGET_DIR"
Write-Host ""
Write-Host "Now you can use the GitHub MCP tool to push these files to GitHub"
Write-Host "Important: Files are prepared in $TARGET_DIR directory"

# List contents of the target directory to verify
Write-Host "Contents of the target directory:"
Get-ChildItem -Path $TARGET_DIR -Recurse | Select-Object -First 10
