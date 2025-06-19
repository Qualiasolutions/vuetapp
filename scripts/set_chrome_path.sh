#!/bin/bash

# This script helps set the CHROME_EXECUTABLE environment variable
# to point to the Windows Chrome executable.

# Instructions:
# 1. Edit the path below to point to your Chrome executable on Windows
#    For example, if your Windows drive is mounted at /mnt/c, you might use:
#    CHROME_PATH="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
#    Or if using a network path:
#    CHROME_PATH="\\\\WINDOWS-PC\\path\\to\\chrome.exe"

# Replace this with your actual Chrome path
CHROME_PATH="C:/Program Files/Google/Chrome/Application/chrome.exe"

# Export the environment variable
export CHROME_EXECUTABLE="$CHROME_PATH"

echo "CHROME_EXECUTABLE has been set to: $CHROME_EXECUTABLE"
echo "You can now run Flutter web applications with Chrome."
echo "Try running: flutter run -d chrome"
