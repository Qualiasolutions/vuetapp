#!/bin/bash

# Script to display IP addresses for use with the Flutter web server
# Run this to find the IP address to use when accessing your app from Windows

echo "Available IP addresses for your Flutter web server:"
echo "----------------------------------------------------"

# Try hostname -I first (most common approach)
IP_ADDRESSES=$(hostname -I)
if [ -n "$IP_ADDRESSES" ]; then
    echo "Primary network addresses:"
    echo "$IP_ADDRESSES" | tr ' ' '\n' | grep -v '^$' | while read -r ip; do
        echo "  - $ip"
    done
    
    # Find the primary one (usually the first non-localhost)
    PRIMARY_IP=$(echo "$IP_ADDRESSES" | awk '{print $1}')
    if [ -n "$PRIMARY_IP" ]; then
        echo ""
        echo "To access your Flutter app from Windows:"
        echo "----------------------------------------"
        echo "1. Run the web server: ./scripts/run_web_server.sh"
        echo "2. Open Chrome on Windows and navigate to:"
        echo "   http://$PRIMARY_IP:8080"
    fi
else
    echo "Could not detect IP addresses using hostname -I."
    
    # Fallback to ip command
    if command -v ip &> /dev/null; then
        echo "Network interfaces:"
        ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | while read -r ip; do
            echo "  - $ip"
        done
    else
        echo "Could not find ip command. Please install net-tools or iproute2."
        echo "Try: sudo apt install net-tools"
    fi
fi

echo ""
echo "Note: If you have multiple network interfaces, choose the IP address"
echo "      that corresponds to the network your Windows machine is on."
