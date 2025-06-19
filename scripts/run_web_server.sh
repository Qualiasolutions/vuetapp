#!/bin/bash

# Script to run Flutter web server with custom host and port
# This makes it accessible from other machines on the network

echo "Starting Flutter web server accessible from network..."
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080
