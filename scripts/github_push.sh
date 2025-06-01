#!/bin/bash
# Script to prepare and push the Vuet App to GitHub repository

# Ensure script exits if any command fails
set -e

GITHUB_REPO="Qualiasolutions/vuetapp"
TARGET_DIR="../github_deploy"
SOURCE_DIR=".."

echo "=== Preparing Vuet App for GitHub Push ==="

# Check if ../github_deploy directory exists, create it if not
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
  echo "Created $TARGET_DIR directory"
else
  echo "Cleaning $TARGET_DIR directory..."
  rm -rf "$TARGET_DIR"/*
fi

# Copy necessary files for deployment
echo "Copying essential files to $TARGET_DIR..."

# Core Flutter App
cp -r "$SOURCE_DIR/lib" "$TARGET_DIR/"
cp -r "$SOURCE_DIR/web" "$TARGET_DIR/"
cp "$SOURCE_DIR/pubspec.yaml" "$TARGET_DIR/"
cp "$SOURCE_DIR/pubspec.lock" "$TARGET_DIR/"
cp "$SOURCE_DIR/analysis_options.yaml" "$TARGET_DIR/"

# GitHub and CI Files
mkdir -p "$TARGET_DIR/.github/workflows"
cp "$SOURCE_DIR/.github/workflows/ci.yml" "$TARGET_DIR/.github/workflows/"
cp "$SOURCE_DIR/README.md" "$TARGET_DIR/"

# Deployment Configuration
cp "$SOURCE_DIR/vercel.json" "$TARGET_DIR/"
mkdir -p "$TARGET_DIR/scripts"
cp "$SOURCE_DIR/scripts/deploy.sh" "$TARGET_DIR/scripts/"

# Copy assets directory if it exists
if [ -d "$SOURCE_DIR/assets" ]; then
  cp -r "$SOURCE_DIR/assets" "$TARGET_DIR/"
fi

# Copy .env.example but not actual .env files
cp "$SOURCE_DIR/.env.example" "$TARGET_DIR/"

# Copy .gitignore for GitHub
cp "$SOURCE_DIR/.gitignore.github" "$TARGET_DIR/.gitignore"

echo "Files prepared in $TARGET_DIR"
echo

# Instructions for manual push or GitHub MCP
echo "To push to GitHub repository:"
echo "1. Navigate to $TARGET_DIR"
echo "2. Initialize git repository:"
echo "   git init"
echo "   git add ."
echo "   git commit -m \"Initial commit of Vuet App\""
echo
echo "3. Add remote repository:"
echo "   git remote add origin https://github.com/$GITHUB_REPO.git"
echo
echo "4. Push to GitHub:"
echo "   git push -u origin main"
echo
echo "Alternatively, you can use the GitHub MCP tool to push these files."
