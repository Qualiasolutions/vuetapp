# 🔧 Environment Setup Guide

This guide explains how to set up environment variables for the Vuet Flutter app.

## 📋 Required Environment Files

You need to create these files from the provided templates:

### 1. Development Environment
```bash
cp .env.template .env.development
```

### 2. Production Environment
```bash
cp .env.production.template .env.production
```

### 3. Web Environment (for Flutter Web)
```bash
cp web/env.template.js web/env.js
```

## 🔑 Required API Keys & Secrets

You'll need to obtain and configure these services:

### Supabase Configuration
1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Get your project URL and anon key
3. Fill in:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_PROJECT_ID`

### OpenAI API (for LANA AI Assistant)
1. Go to [OpenAI API](https://platform.openai.com/api-keys)
2. Create a new API key
3. Fill in:
   - `OPENAI_API_KEY`
   - `OPENAI_ASSISTANT_ID` (if using a specific assistant)

### reCAPTCHA (for Web Security)
1. Go to [Google reCAPTCHA](https://www.google.com/recaptcha/admin)
2. Create site and secret keys
3. Fill in:
   - `RECAPTCHA_SITE_KEY`
   - `RECAPTCHA_SECRET_KEY`

## 🛡️ Security Notes

- **Never commit** real environment files to version control
- Keep your API keys secure and rotate them regularly
- Use different keys for development and production
- The `.gitignore` file is configured to prevent accidental commits

## 🚀 Getting Started

1. Copy the template files as shown above
2. Fill in your actual API keys and secrets
3. Run the Flutter app:
   ```bash
   flutter pub get
   flutter run
   ```

## ❓ Need Help?

- Check the [main README](README.md) for general setup
- Review [deployment documentation](README-DEPLOYMENT.md) for TestFlight setup
- Ensure all required services are properly configured 