#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Verify if devices are connected
device_connected() {
    blueutil --paired | grep -i "$1" &>/dev/null
    return $?
}

if device_connected "$KEYBOARD_MAC" && device_connected "$TRACKPAD_MAC"; then
    echo "Keyboard and Trackpad are already connected."
    exit 0
fi

# Check if required environment variables are set
if [ -z "$KEYBOARD_MAC" ] || [ -z "$TRACKPAD_MAC" ] || [ -z "$OTHER_MAC_IP" ] || [ -z "$PORT" ]; then
    echo "Missing required environment variables. Please define KEYBOARD_MAC, TRACKPAD_MAC, OTHER_MAC_IP, and PORT in a .env file."
    exit 1
fi

# Tell the other Mac to unpair the trackpad
echo "Requesting the other Mac to release the trackpad..."
curl -X GET "http://$OTHER_MAC_IP:$PORT/unpair" &>/dev/null

connect_if_not_connected() {
    if ! device_connected "$1"; then
        echo "Connecting $2..."
        blueutil --connect "$1"

        sleep 1

        if device_connected "$1"; then
            echo "✅ $2 successfully connected!"
        else
            echo "❌ Failed to connect Keyboard. Check if it's turned on and in range."
        fi
    else
        echo "$1 is already connected."
    fi
}

connect_if_not_connected "$KEYBOARD_MAC" "Keyboard"
connect_if_not_connected "$TRACKPAD_MAC" "Trackpad"