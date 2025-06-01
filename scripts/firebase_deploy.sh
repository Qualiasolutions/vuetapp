#!/bin/bash
# Firebase Deployment script for Vuet App

# Ensure script exits if any command fails
set -e

# Print information about what we're doing
echo "=== Vuet App Firebase Deployment Script ==="
echo "Building and deploying Flutter app to Firebase hosting"
echo

# Check if environment files exist
if [ ! -f ".env.production" ]; then
  echo "Error: .env.production file not found!"
  echo "Please create a .env.production file with your Supabase credentials."
  exit 1
fi

# Run Flutter clean and pub get
echo "Cleaning project and getting dependencies..."
flutter clean
flutter pub get

# Build for web in release mode
echo "Building app for web in release mode..."
flutter build web --release

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "Error: Firebase CLI is not installed."
    echo "Please install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if logged into Firebase
echo "Checking Firebase login status..."
if ! firebase projects:list &> /dev/null; then
    echo "Not logged into Firebase. Please login..."
    firebase login
fi

# Deploy to Firebase hosting
echo "Deploying to Firebase hosting..."
firebase deploy --only hosting

echo 
echo "=== Deployment Complete ==="
echo "Your app has been deployed to Firebase hosting!"
echo "Visit your app at: https://qaaaa-448c6.web.app"
echo
