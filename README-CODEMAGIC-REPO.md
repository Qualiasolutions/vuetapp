# Vuet App - Codemagic CI/CD Repository

This repository contains the Vuet App with Codemagic CI/CD configuration for TestFlight deployment.

## Important Notes for Deployment

### Required Environment Variables

Before running your first build in Codemagic, you must set up the following environment variables:

1. **App Store Connect API Key** - Create a variable group in Codemagic with:
   - `APP_STORE_CONNECT_PRIVATE_KEY` - The contents of your .p8 file

2. **Supabase Credentials** - Create a variable group in Codemagic named `supabase_credentials` with:
   - `SUPABASE_URL` - Your Supabase project URL
   - `SUPABASE_ANON_KEY` - Your Supabase anonymous key

### Setting Up in Codemagic

1. Log in to [Codemagic](https://codemagic.io)
2. Add this repository to your Codemagic account
3. Go to Environment Variables and add the required variable groups
4. Run the `ios-testflight` workflow to build and deploy to TestFlight

## App Details

- **Bundle ID**: `ai.vuet.vuet`
- **Team ID**: `36AP5U42Q4`
- **App Store Connect Key ID**: `33SP789JPW`

## Configuration Files

- `codemagic.yaml` - Contains the build and deployment configuration
- `README-CODEMAGIC-SETUP.md` - Detailed setup instructions 