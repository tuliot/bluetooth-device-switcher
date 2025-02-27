#!/bin/bash

# Install blueutil if not installed
if ! command -v blueutil &> /dev/null
then
    echo "Installing blueutil..."
    brew install blueutil
else
    echo "blueutil is already installed."
fi

# Define LaunchAgent plist path
LAUNCH_AGENT_PATH="$HOME/Library/LaunchAgents/com.tuliotroncoso.deviceswitcherserver.plist"
SERVER_SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)/device_switch_server.py"
BLUEUTIL_PATH="$(command -v blueutil)" 

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Check for required environment variables
if [ -z "$KEYBOARD_MAC" ] || [ -z "$TRACKPAD_MAC" ] || [ -z "$OTHER_MAC_IP" ] || [ -z "$PORT" ]; then
    echo "Missing required environment variables. Please define KEYBOARD_MAC, TRACKPAD_MAC, OTHER_MAC_IP, and PORT in a .env file."
    exit 1
fi

# Create LaunchAgent plist
cat <<EOF > "$LAUNCH_AGENT_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>com.tuliotroncoso.deviceswitcherserver</string>
        <key>ProgramArguments</key>
        <array>
            <string>/usr/bin/python3</string>
            <string>$SERVER_SCRIPT_PATH</string>
        </array>

        <key>EnvironmentVariables</key>
        <dict>
            <key>BLUEUTIL_PATH</key>
            <string>$BLUEUTIL_PATH</string>
            <key>KEYBOARD_MAC</key>
            <string>$KEYBOARD_MAC</string>
            <key>TRACKPAD_MAC</key>
            <string>$TRACKPAD_MAC</string>
            <key>OTHER_MAC_IP</key>
            <string>$OTHER_MAC_IP</string>
            <key>PORT</key>
            <string>$PORT</string>
        </dict>

        <key>StandardOutPath</key>
            <string>/tmp/deviceswitcherserver.log</string>
        <key>StandardErrorPath</key>
            <string>/tmp/deviceswitcherserver.err</string>

        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
    </dict>
</plist>
EOF

echo "LaunchAgent plist created at $LAUNCH_AGENT_PATH with environment variables."

# Load LaunchAgent
launchctl unload "$LAUNCH_AGENT_PATH"
launchctl load "$LAUNCH_AGENT_PATH"
echo "Trackpad server started successfully."
