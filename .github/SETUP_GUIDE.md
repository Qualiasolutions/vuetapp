# 🚀 GitHub Actions iOS TestFlight Setup Guide

This guide will help you set up automated iOS builds and TestFlight deployment using GitHub Actions.

## 📋 Prerequisites

- ✅ Apple Developer Account (Team ID: 36AP5U42Q4)
- ✅ App Store Connect Access (p_ferraby@yahoo.com)
- ✅ GitHub Repository with admin access
- ✅ Xcode project properly configured

## 🔐 Required GitHub Secrets

You need to add these secrets to your GitHub repository:

### Step 1: Go to GitHub Repository Settings
1. Navigate to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** for each secret below

### Step 2: Add Required Secrets

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `APPLE_TEAM_ID` | Your Apple Developer Team ID | Already have: `36AP5U42Q4` |
| `APPLE_KEY_ID` | App Store Connect API Key ID | See section below |
| `APPLE_KEY_ISSUER_ID` | App Store Connect API Issuer ID | See section below |
| `APPLE_API_KEY` | App Store Connect API Key (base64) | See section below |
| `IOS_CERTIFICATE_P12` | iOS Distribution Certificate (base64) | See section below |
| `IOS_P12_PASSWORD` | Certificate password | Set when exporting certificate |
| `IOS_PROVISIONING_PROFILE` | Provisioning Profile (base64) | See section below |

## 🔑 Getting App Store Connect API Key

### Step 1: Create API Key
1. Sign in to [App Store Connect](https://appstoreconnect.apple.com)
2. Go to **Users and Access** → **Keys** tab
3. Click **+** to create a new API key
4. Set **Name**: "GitHub Actions CI/CD"
5. Set **Access**: "App Manager" or "Developer"
6. Click **Generate**

### Step 2: Download and Prepare
1. **Download** the `.p8` key file (AuthKey_XXXXXXXXXX.p8)
2. **Note the Key ID** (10 characters, e.g., "ABC123DEFG")
3. **Note the Issuer ID** (UUID format)
4. **Convert to base64**:
   ```bash
   base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
   ```
5. **Add to GitHub Secrets**:
   - `APPLE_KEY_ID`: The Key ID (e.g., "ABC123DEFG")
   - `APPLE_KEY_ISSUER_ID`: The Issuer ID (UUID)
   - `APPLE_API_KEY`: The base64 content (paste from clipboard)

## 📱 Getting iOS Distribution Certificate

### Step 1: Create Certificate Request
1. Open **Keychain Access** on Mac
2. **Keychain Access** → **Certificate Assistant** → **Request a Certificate From a Certificate Authority**
3. Enter your email: `p_ferraby@yahoo.com`
4. **Common Name**: "Vuet Distribution"
5. **Request is**: "Saved to disk"
6. Save as `CertificateSigningRequest.certSigningRequest`

### Step 2: Generate Certificate in Apple Developer
1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/certificates/list)
2. Click **+** to add certificate
3. Select **iOS Distribution (App Store and Ad Hoc)**
4. Upload your `.certSigningRequest` file
5. Download the generated certificate (`.cer` file)

### Step 3: Install and Export
1. **Double-click** the `.cer` file to install in Keychain
2. In **Keychain Access**, find your certificate
3. **Right-click** → **Export** → Choose **Personal Information Exchange (.p12)**
4. Set a **strong password** (save this for `IOS_P12_PASSWORD` secret)
5. **Convert to base64**:
   ```bash
   base64 -i YourCertificate.p12 | pbcopy
   ```
6. **Add to GitHub Secrets**:
   - `IOS_CERTIFICATE_P12`: Paste the base64 content
   - `IOS_P12_PASSWORD`: Your certificate password

## 📋 Getting Provisioning Profile

### Step 1: Create App Identifier (if not exists)
1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers/list)
2. Verify **ai.vuet.vuet** exists, or create it

### Step 2: Create Provisioning Profile
1. Go to [Provisioning Profiles](https://developer.apple.com/account/resources/profiles/list)
2. Click **+** to add profile
3. Select **App Store** distribution
4. Choose **ai.vuet.vuet** app identifier
5. Select your **Distribution Certificate**
6. **Name**: "Vuet App Store Profile"
7. **Generate** and **Download**

### Step 3: Convert and Add
1. **Convert to base64**:
   ```bash
   base64 -i Vuet_App_Store_Profile.mobileprovision | pbcopy
   ```
2. **Add to GitHub Secret**:
   - `IOS_PROVISIONING_PROFILE`: Paste the base64 content

## 🚀 How to Deploy

### Automatic Deployment
- **Push to main/master branch** → Automatically builds and deploys to TestFlight

### Manual Deployment
1. Go to your GitHub repository
2. Click **Actions** tab
3. Click **🚀 iOS TestFlight Deployment** workflow
4. Click **Run workflow**
5. Choose your options and click **Run workflow**

## 📊 Monitoring Builds

### GitHub Actions
- Monitor progress in **Actions** tab
- View detailed logs for each step
- Download build artifacts if needed

### App Store Connect
- Check [App Store Connect](https://appstoreconnect.apple.com)
- Go to **TestFlight** section
- Your build will appear within 30 minutes
- Add external testers and distribute

## 🛠️ Troubleshooting

### Common Issues

**Certificate/Provisioning Errors:**
- Verify all base64 conversions are correct
- Ensure certificates haven't expired
- Check Team ID matches exactly

**Build Failures:**
- Check Flutter version compatibility
- Verify iOS deployment target (minimum 12.0)
- Review build logs in GitHub Actions

**TestFlight Upload Errors:**
- Verify App Store Connect API key permissions
- Check bundle identifier matches exactly
- Ensure app version is incremented

### Getting Help
1. Check GitHub Actions logs for detailed error messages
2. Verify all secrets are properly set
3. Test individual steps locally if possible

## ✅ Verification Checklist

Before your first deployment:

- [ ] All 7 GitHub secrets added correctly
- [ ] App Store Connect API key has proper permissions
- [ ] iOS Distribution Certificate is valid and properly exported
- [ ] Provisioning Profile matches your bundle ID
- [ ] Team ID is correct (36AP5U42Q4)
- [ ] pubspec.yaml version is properly formatted
- [ ] Repository is pushed to GitHub

## 🎉 Success!

Once set up, every push to main will:
1. ✅ Build your Flutter app for iOS
2. ✅ Create signed IPA
3. ✅ Upload to TestFlight automatically
4. ✅ Notify you of success/failure

Your Vuet app will be available for testing within 30 minutes! 🚀

---

## 📞 Support

If you encounter issues:
1. Check the GitHub Actions logs
2. Verify all secrets are correct
3. Ensure Apple Developer account is active
4. Double-check bundle identifier and Team ID

Happy deploying! 🎊 