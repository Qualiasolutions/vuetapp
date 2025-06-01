#!/bin/bash
# Deployment script for Vuet App

# Ensure script exits if any command fails
set -e

# Print information about what we're doing
echo "=== Vuet App Deployment Script ==="
echo "This script prepares the Flutter app for deployment to Vercel via GitHub"
echo

# Check if environment files exist
if [ ! -f "../.env.production" ]; then
  echo "Error: .env.production file not found!"
  echo "Please create a .env.production file with your Supabase credentials."
  exit 1
fi

# Ensure the web directory has the required files
echo "Checking web directory files..."
if [ ! -f "../web/env-config.js" ]; then
  echo "Error: web/env-config.js file not found!"
  exit 1
fi

# Run Flutter clean and pub get
echo "Cleaning project and getting dependencies..."
cd ..
flutter clean
flutter pub get

# Build for web in release mode (optional - usually Vercel will do this)
echo "Building app for web in release mode (for testing)..."
flutter build web --release

echo 
echo "=== Deployment Preparation Complete ==="
echo 
echo "To deploy to GitHub and Vercel:"
echo "1. Commit your changes to GitHub repository:"
echo "   git add ."
echo "   git commit -m \"Deploy Vuet App to Vercel\""
echo "   git push origin main"
echo
echo "2. In Vercel, connect to the GitHub repository"
echo "3. Configure environment variables in Vercel project settings:"
echo "   - SUPABASE_URL"
echo "   - SUPABASE_ANON_KEY"
echo
echo "Done! Your app is ready for deployment."
