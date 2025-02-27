#!/bin/bash

KEYBOARD_MAC=""
TRACKPAD_MAC=""
OTHER_MAC_IP=""

# Port Number for the Custom HTTP Server on the Other Mac
PORT=""

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