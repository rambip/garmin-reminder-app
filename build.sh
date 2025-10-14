#!/bin/sh

# List of devices to build for
DEVICES="fr165 fr245"

# Loop through each device
for DEVICE in $DEVICES; do
    echo "Building for device: $DEVICE"
    monkeyc -y developer_key.der -d $DEVICE -f monkey.jungle -o "build/reminder_app_${DEVICE}.prg" --release
done

echo "Build completed for all devices"
