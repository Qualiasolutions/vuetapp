#!/bin/bash

# Git Commit and Push Script for Vuet App

set -e  # Exit on any error

# Function to display usage
usage() {
    echo "Usage: $0 [commit-message]"
    echo "If no commit message is provided, you'll be prompted to enter one."
    exit 1
}

# Get commit message from argument or prompt user
COMMIT_MESSAGE=""
if [ $# -eq 0 ]; then
    echo "Enter commit message:"
    read -r COMMIT_MESSAGE
    if [ -z "$COMMIT_MESSAGE" ]; then
        echo "Error: Commit message cannot be empty"
        exit 1
    fi
else
    COMMIT_MESSAGE="$*"
fi

echo "=== Git Commit and Push ==="
echo "Commit message: $COMMIT_MESSAGE"
echo

# Check git status
echo "Checking git status..."
git status --short

echo
read -p "Do you want to continue with commit and push? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Add all changes
echo "Adding all changes..."
git add .

# Commit changes
echo "Committing changes..."
git commit -m "$COMMIT_MESSAGE"

# Push to origin
echo "Pushing to GitHub..."
git push origin master

echo
echo "✅ Successfully committed and pushed changes to GitHub!"
echo "Commit message: $COMMIT_MESSAGE"
