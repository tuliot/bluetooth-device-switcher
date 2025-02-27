# Bluetooth Device Swapper

This project provides an automated way to **swap a Magic Trackpad and a Bluetooth keyboard between two Macs** over a local network. It runs a small HTTP server on each Mac to handle device unpairing and allows seamless device switching with a simple script.

## Features

- **One-Click Setup**: Uses `install.sh` to set everything up.
- **Seamless Bluetooth Switching**: Unpairs and connects a Magic Trackpad & keyboard between two Macs.
- **No SSH Required**: Uses HTTP requests over LAN instead of SSH for better security.
- **Automatic Server Startup**: Runs a background server to manage Bluetooth device swaps.

---

## Installation

### 1️⃣ Clone the Repository

```sh
git clone https://github.com/yourusername/bluetooth-device-swapper.git
cd bluetooth-device-swapper
```

### 2️⃣ Run the Installation Script

The `install.sh` script will:

- Install `blueutil`
- Set up a LaunchAgent for automatic startup
- Start the device switch server

Run:

```sh
./install.sh
```

If needed, make it executable first:

```sh
chmod +x install.sh
```

### 3️⃣ Configure Environment Variables

Create a `.env` file in the same directory and set up your device details:

```sh
KEYBOARD_MAC=XX:XX:XX:XX:XX:XX
TRACKPAD_MAC=YY:YY:YY:YY:YY:YY
OTHER_MAC_IP=192.168.1.200
PORT=36487
```

This ensures both `device_switch_server.py` and `connect.sh` use the correct MAC addresses and network settings.

---

## Usage

### **Starting the Device Switch Server**

The installation script already sets up the server to start automatically on boot. If you need to start it manually:

```sh
python3 device_switch_server.py
```

### **Swapping Devices Between Macs**

Run the following command on the Mac you want to switch the devices to:

```sh
./connect.sh
```

This will:

1. Send an HTTP request to the other Mac to **unpair** the trackpad and keyboard.
2. **Pair and connect** the trackpad & keyboard to the current Mac.

---

## Automating at Startup (Optional)

The `install.sh` script sets up a **LaunchAgent** to ensure the server runs automatically at boot.

If needed, you can manually reload the LaunchAgent:

```sh
launchctl unload ~/Library/LaunchAgents/com.user.trackpadserver.plist
launchctl load ~/Library/LaunchAgents/com.user.trackpadserver.plist
```

---

## Troubleshooting

### Devices Won’t Connect?

- Ensure `device_switch_server.py` is **running** on the other Mac.
- Verify that **correct MAC addresses** are set in `.env`.
- Check the **correct IP addresses** in `.env`.
- Restart Bluetooth:
  ```sh
  blueutil --power 0 && blueutil --power 1
  ```

---

🚀 Now everything is **automated and easy to deploy**! Let me know if you need any refinements. 🔥
