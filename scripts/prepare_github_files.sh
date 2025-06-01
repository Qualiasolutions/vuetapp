#!/bin/bash
# Script to prepare the Vuet App files for GitHub deployment
# This script doesn't contain any GitHub tokens - it just prepares files

# Enable verbose mode to see what's happening
set -ex

# Get current directory
CURRENT_DIR=$(pwd)
echo "Current directory: $CURRENT_DIR"

# Set target directory with absolute path
TARGET_DIR="$CURRENT_DIR/../github_deploy"
SOURCE_DIR="$CURRENT_DIR"
echo "Target directory: $TARGET_DIR"
echo "Source directory: $SOURCE_DIR"

echo "=== Preparing Vuet App Files for GitHub Push ==="

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

# Copy DEPLOYMENT_GUIDE.md
cp "$SOURCE_DIR/DEPLOYMENT_GUIDE.md" "$TARGET_DIR/"

# Copy .gitignore for GitHub
cp "$SOURCE_DIR/.gitignore.github" "$TARGET_DIR/.gitignore"

echo "Files prepared in $TARGET_DIR"
echo
echo "Now you can use the GitHub MCP tool to push these files to GitHub"
echo "Important: Files are prepared in $TARGET_DIR directory"
