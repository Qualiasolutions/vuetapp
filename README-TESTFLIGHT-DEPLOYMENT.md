# 🚀 TestFlight Deployment Setup for Vuet App

This guide explains how to deploy your Flutter app to TestFlight from Windows using GitHub Actions.

## 📋 Overview

We've set up an automated deployment pipeline that:
- ✅ Builds your Flutter app on macOS runners (GitHub Actions)
- ✅ Signs the app with your iOS certificates
- ✅ Uploads directly to TestFlight
- ✅ Manages versioning automatically
- ✅ Can be triggered from Windows

## 🛠️ Prerequisites

Before starting, ensure you have:

1. **Apple Developer Account** with:
   - iOS Distribution Certificate
   - App Store provisioning profile for `ai.vuet.vuet`
   - Access to App Store Connect

2. **GitHub Repository** with:
   - Your Flutter project pushed to main branch
   - GitHub Actions enabled

3. **Windows Tools** (optional but recommended):
   - Git for Windows
   - GitHub CLI (`gh`) - for easier secret management

## ⚡ Quick Start

### Step 1: Generate App-Specific Password

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in and go to **Sign-In and Security**
3. Select **App-Specific Passwords**
4. Click **Generate Password**
5. Name it "GitHub Actions TestFlight"
6. **Save the password** - you'll need it for GitHub secrets

### Step 2: Get Your Certificates

You need these files from your Apple Developer account:

#### Option A: If you have a Mac
1. **iOS Distribution Certificate (.p12)**:
   - Open Keychain Access
   - Find your "iOS Distribution" certificate
   - Right-click → Export → Save as .p12 format
   - Set a password and remember it

2. **App Store Provisioning Profile (.mobileprovision)**:
   - Go to [Apple Developer Portal](https://developer.apple.com)
   - Certificates, Identifiers & Profiles → Profiles
   - Download the App Store profile for `ai.vuet.vuet`

#### Option B: If you don't have a Mac
- Ask someone with a Mac to export your certificate
- Or use Xcode Cloud / other CI services to generate them
- Download the provisioning profile from Apple Developer Portal

### Step 3: Set Up GitHub Secrets

#### Automatic Setup (Recommended)
```powershell
# Run the setup script
.\scripts\setup_testflight_windows.ps1 -SetupSecrets
```

#### Manual Setup
Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `APPLE_ID` | Your Apple Developer email | `p_ferraby@yahoo.com` |
| `APPLE_PASSWORD` | App-specific password from Step 1 | `xxxx-xxxx-xxxx-xxxx` |
| `BUILD_CERTIFICATE_BASE64` | Base64 encoded .p12 file | `MIIKdgIBAzC...` |
| `P12_PASSWORD` | Password for your .p12 certificate | `your_cert_password` |
| `BUILD_PROVISION_PROFILE_BASE64` | Base64 encoded .mobileprovision | `MIIMsQYJKo...` |
| `KEYCHAIN_PASSWORD` | Any temporary password | `temp_keychain_123` |
| `SUPABASE_URL` | Your Supabase project URL | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Your Supabase anon key | `eyJhbGci...` |

#### Converting Files to Base64
**On Windows:**
```powershell
# Convert certificate
$cert = [Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\cert.p12"))
echo $cert

# Convert provisioning profile  
$profile = [Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\profile.mobileprovision"))
echo $profile
```

**On macOS/Linux:**
```bash
# Convert certificate
base64 -i certificate.p12 | pbcopy

# Convert provisioning profile
base64 -i profile.mobileprovision | pbcopy
```

### Step 4: Deploy to TestFlight

#### Option A: Push to trigger deployment
```bash
git add .
git commit -m "Deploy to TestFlight"
git push origin main
```

#### Option B: Manual trigger
```powershell
# Using the script
.\scripts\setup_testflight_windows.ps1 -TriggerDeploy

# Or using GitHub CLI
gh workflow run "iOS TestFlight Deployment" --field deploy_to_testflight=true
```

#### Option C: GitHub Web Interface
1. Go to your repository on GitHub
2. Click **Actions** tab
3. Select **iOS TestFlight Deployment**
4. Click **Run workflow**
5. Set "Deploy to TestFlight" to `true`
6. Click **Run workflow**

## 📱 App Configuration

Your app is configured with:
- **Bundle ID**: `ai.vuet.vuet`
- **Display Name**: `Vuet`
- **Team ID**: `36AP5U42Q4`
- **Current Version**: `1.0.0+1`

## 🔄 Deployment Workflow

The GitHub Actions workflow will:

1. **Build Environment Setup** (2-3 minutes)
   - Install Flutter and dependencies
   - Set up Xcode and certificates

2. **Code Quality Checks** (1-2 minutes)
   - Run `flutter analyze`
   - Execute tests
   - Generate code (build_runner)

3. **iOS Build** (5-8 minutes)
   - Build Flutter app for iOS
   - Archive with Xcode
   - Create signed IPA

4. **TestFlight Upload** (3-5 minutes)
   - Validate app
   - Upload to App Store Connect
   - Process in TestFlight

**Total time**: ~10-18 minutes

## 📊 Monitoring Deployments

### Check Status
```powershell
# Using the script
.\scripts\setup_testflight_windows.ps1 -CheckStatus

# Or check GitHub Actions tab in your repository
```

### View Logs
1. Go to GitHub repository → Actions
2. Click on the latest workflow run
3. Expand job steps to see detailed logs

## 🔧 Troubleshooting

### Common Issues

#### Certificate Problems
```
Error: Code signing failed
```
**Solution**: Verify your .p12 certificate and password are correct

#### Provisioning Profile Issues  
```
Error: No matching provisioning profiles found
```
**Solution**: Ensure your provisioning profile matches your Bundle ID (`ai.vuet.vuet`)

#### Upload Failures
```
Error: Altool upload failed
```
**Solution**: Check your Apple ID and app-specific password

#### Build Failures
```
Error: Flutter build failed
```
**Solution**: Test locally with `flutter build ios --release`

### Debug Steps

1. **Local Build Test**:
   ```bash
   flutter clean
   flutter pub get
   flutter build ios --release
   ```

2. **Check Certificates**:
   - Verify certificate is not expired
   - Ensure provisioning profile is active
   - Check Team ID matches

3. **View Detailed Logs**:
   - Check GitHub Actions logs
   - Look for specific error messages
   - Verify all secrets are set

## 🎯 Next Steps After Deployment

1. **App Store Connect**:
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Navigate to your app
   - Check TestFlight tab for processing status

2. **TestFlight Distribution**:
   - Add internal testers
   - Configure test information
   - Submit for external testing (if needed)

3. **Version Management**:
   - The workflow auto-increments build numbers
   - Manually update version in `pubspec.yaml` for major releases

## 📝 Script Usage Reference

```powershell
# Show help
.\scripts\setup_testflight_windows.ps1 -Help

# Interactive secrets setup
.\scripts\setup_testflight_windows.ps1 -SetupSecrets

# Check deployment status
.\scripts\setup_testflight_windows.ps1 -CheckStatus

# Trigger manual deployment
.\scripts\setup_testflight_windows.ps1 -TriggerDeploy

# Setup with parameters
.\scripts\setup_testflight_windows.ps1 -SetupSecrets -AppSpecificPassword "xxxx-xxxx-xxxx-xxxx"
```

## 🔒 Security Notes

- Never commit certificates or passwords to git
- Use GitHub secrets for all sensitive data
- Rotate app-specific passwords periodically
- Keep provisioning profiles updated

## 🆘 Support

If you encounter issues:

1. Check this README first
2. Review GitHub Actions logs
3. Verify all prerequisites are met
4. Test local builds work
5. Check Apple Developer Portal for certificate status

---

**Happy deploying! 🚀**
