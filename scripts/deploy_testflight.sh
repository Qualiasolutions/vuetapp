#!/bin/bash
# ===============================================================================
# Vuet TestFlight Deployment Script
# ===============================================================================
# This script automates the process of building and deploying the Vuet Flutter app
# to TestFlight for iOS testing.
#
# Author: Factory AI Assistant
# Date: June 1, 2025
# ===============================================================================

# Set strict error handling
set -e

# ===============================================================================
# Configuration
# ===============================================================================
APP_NAME="Vuet"
BUNDLE_ID="ai.vuet.vuet"
TEAM_ID="36AP5U42Q4"
VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
BUILD_NUMBER=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)
APPLE_ID="p_ferraby@yahoo.com"
APPLE_PASSWORD="Allegro575!"  # Note: For production, use environment variables or keychain
EXPORT_OPTIONS_PLIST="ios/ExportOptions.plist"
OUTPUT_DIRECTORY="build/ios/outputs"
IPA_PATH="${OUTPUT_DIRECTORY}/${APP_NAME}.ipa"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ===============================================================================
# Helper Functions
# ===============================================================================

# Print a section header
print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Print a success message
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Print an error message and exit
print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
    exit 1
}

# Print a warning message
print_warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
}

# Print an info message
print_info() {
    echo -e "ℹ $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create export options plist if it doesn't exist
create_export_options_plist() {
    if [ ! -f "$EXPORT_OPTIONS_PLIST" ]; then
        print_info "Creating ExportOptions.plist..."
        cat > "$EXPORT_OPTIONS_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>${TEAM_ID}</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>thinning</key>
    <string>&lt;none&gt;</string>
</dict>
</plist>
EOF
        print_success "Created ExportOptions.plist"
    else
        print_info "ExportOptions.plist already exists"
    fi
}

# ===============================================================================
# Environment Validation
# ===============================================================================
print_section "Environment Validation"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script must be run on macOS"
fi

# Check for required tools
print_info "Checking for required tools..."

# Check for Flutter
if ! command_exists flutter; then
    print_error "Flutter is not installed. Please install Flutter and try again."
fi

# Check for Xcode
if ! command_exists xcodebuild; then
    print_error "Xcode is not installed. Please install Xcode and try again."
fi

# Check for xcrun
if ! command_exists xcrun; then
    print_error "xcrun is not found. Please make sure Xcode command line tools are installed."
fi

# Check for Ruby (for Fastlane if we add it later)
if ! command_exists ruby; then
    print_warning "Ruby is not installed. This might be needed for Fastlane in future versions."
fi

# Verify Flutter version
FLUTTER_VERSION=$(flutter --version | head -1 | awk '{print $2}')
print_info "Flutter version: $FLUTTER_VERSION"

# Verify Xcode version
XCODE_VERSION=$(xcodebuild -version | head -1 | awk '{print $2}')
print_info "Xcode version: $XCODE_VERSION"

# Verify we have the correct Flutter channel
FLUTTER_CHANNEL=$(flutter channel | grep -E '^\* ' | awk '{print $2}')
print_info "Flutter channel: $FLUTTER_CHANNEL"
if [[ "$FLUTTER_CHANNEL" != "stable" ]]; then
    print_warning "Flutter is not on the stable channel. This might cause issues."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

print_success "Environment validation completed"

# ===============================================================================
# Project Preparation
# ===============================================================================
print_section "Project Preparation"

# Clean the project
print_info "Cleaning project..."
flutter clean
print_success "Project cleaned"

# Get dependencies
print_info "Getting dependencies..."
flutter pub get
print_success "Dependencies retrieved"

# Run code generation
print_info "Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs
print_success "Code generation completed"

# Update iOS deployment target if needed
IOS_DEPLOYMENT_TARGET="12.0"  # Minimum iOS version
print_info "Setting iOS deployment target to $IOS_DEPLOYMENT_TARGET..."
sed -i '' "s/IPHONEOS_DEPLOYMENT_TARGET = .*;/IPHONEOS_DEPLOYMENT_TARGET = $IOS_DEPLOYMENT_TARGET;/" ios/Flutter/AppFrameworkInfo.plist
print_success "iOS deployment target updated"

# Create the export options plist
create_export_options_plist

# ===============================================================================
# Flutter Build
# ===============================================================================
print_section "Flutter Build"

# Build the Flutter project for iOS
print_info "Building Flutter project for iOS (Release mode)..."
flutter build ios --release --no-codesign
print_success "Flutter build completed"

# ===============================================================================
# Xcode Build and Archive
# ===============================================================================
print_section "Xcode Build and Archive"

# Create output directory
mkdir -p "$OUTPUT_DIRECTORY"

# Archive the app
print_info "Archiving app with Xcode..."
xcodebuild -workspace ios/Runner.xcworkspace \
    -scheme Runner \
    -configuration Release \
    -archivePath "$OUTPUT_DIRECTORY/Runner.xcarchive" \
    -allowProvisioningUpdates \
    archive
print_success "App archived successfully"

# Export IPA
print_info "Exporting IPA..."
xcodebuild -exportArchive \
    -archivePath "$OUTPUT_DIRECTORY/Runner.xcarchive" \
    -exportOptionsPlist "$EXPORT_OPTIONS_PLIST" \
    -exportPath "$OUTPUT_DIRECTORY" \
    -allowProvisioningUpdates
print_success "IPA exported successfully"

# Verify IPA was created
if [ ! -f "$IPA_PATH" ]; then
    # Look for the actual IPA file
    IPA_PATH=$(find "$OUTPUT_DIRECTORY" -name "*.ipa" | head -1)
    
    if [ -z "$IPA_PATH" ]; then
        print_error "IPA file not found. Export may have failed."
    else
        print_info "Found IPA at: $IPA_PATH"
    fi
fi

# ===============================================================================
# TestFlight Upload
# ===============================================================================
print_section "TestFlight Upload"

# Validate the app before uploading
print_info "Validating app..."
xcrun altool --validate-app \
    -f "$IPA_PATH" \
    -t ios \
    -u "$APPLE_ID" \
    -p "$APPLE_PASSWORD" \
    --output-format xml
print_success "App validation completed"

# Upload to TestFlight
print_info "Uploading to TestFlight... (this may take several minutes)"
xcrun altool --upload-app \
    -f "$IPA_PATH" \
    -t ios \
    -u "$APPLE_ID" \
    -p "$APPLE_PASSWORD" \
    --output-format xml

# Check if upload was successful
if [ $? -eq 0 ]; then
    print_success "Upload to TestFlight successful!"
else
    print_error "Upload to TestFlight failed"
fi

# ===============================================================================
# Cleanup
# ===============================================================================
print_section "Cleanup"

# Ask if user wants to clean up build files
read -p "Clean up build files? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Cleaning up build files..."
    rm -rf "$OUTPUT_DIRECTORY/Runner.xcarchive"
    print_success "Cleanup completed"
else
    print_info "Skipping cleanup"
fi

# ===============================================================================
# Summary
# ===============================================================================
print_section "Deployment Summary"
echo "App Name: $APP_NAME"
echo "Bundle ID: $BUNDLE_ID"
echo "Version: $VERSION"
echo "Build Number: $BUILD_NUMBER"
echo "IPA Path: $IPA_PATH"
echo "Upload Date: $(date)"
echo ""
print_success "Deployment process completed!"
echo ""
print_info "The app should appear in App Store Connect within 30 minutes."
print_info "Visit https://appstoreconnect.apple.com to manage your TestFlight distribution."

exit 0
