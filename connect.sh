#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Check if required environment variables are set
if [ -z "$KEYBOARD_MAC" ] || [ -z "$TRACKPAD_MAC" ] || [ -z "$OTHER_MAC_IP" ] || [ -z "$PORT" ]; then
    echo "Missing required environment variables. Please define KEYBOARD_MAC, TRACKPAD_MAC, OTHER_MAC_IP, and PORT in a .env file."
    exit 1
fi

# Tell the other Mac to unpair the trackpad
echo "Requesting the other Mac to release the trackpad..."
curl -X GET "http://$OTHER_MAC_IP:$PORT/unpair" &>/dev/null

# Wait for a couple of seconds to ensure the other Mac unpairs it
sleep 1

# Now, pair & connect the trackpad to this Mac
echo "Pairing and connecting the trackpad to this Mac..."
blueutil --pair "$KEYBOARD_MAC"
blueutil --pair "$TRACKPAD_MAC"

echo "Trackpad should now be connected!"