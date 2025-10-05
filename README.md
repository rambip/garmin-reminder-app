# Garmin Reminder App

A minimalist daily reminder app for Garmin watches. Quick to use, easy to navigate.

## What is it?

A simple reminder system designed for your watch. No typing required—just three quick menu selections and you're done.

## Why use it?

Typing on a watch is tedious. This app lets you create reminders in seconds using only menus:
- Pick a **category** (Work, Family, Friends, etc.)
- Pick a **time** (Urgent, Today, Later)
- Pick a **letter** (B through V) as your personal code

Example: "Work [B] - Urgent" could mean "Call Bob urgently about work."

The letter codes are yours to define. Use them however makes sense to you.

## Features

- ✅ Create reminders in 3 taps
- ✅ View today's reminders at a glance
- ✅ Delete reminders when done
- ✅ Glance view for quick access
- ✅ No typing needed

## How to Use

### Adding a Reminder
1. Open the app
2. Select "Add Reminder"
3. Choose category → time → letter
4. Done!

### Viewing Reminders
- Open the app and select "See Reminders"
- Or check the glance view from your watch face

### Deleting a Reminder
1. Select the reminder you want to delete
2. Press the START button
3. Done!

## Supported Devices

- Forerunner 165
- (More devices coming soon)

## Installation

1. Download the latest release from the Garmin Connect IQ Store
2. Or sideload the `.prg` file using the Garmin Connect app

## For Developers

Built with Monkey C for Garmin Connect IQ.

```bash
./build.sh              # Build the app
monkeydo result.prg fr165  # Run in simulator
```

Key architectural decisions:
- Symbol-to-string conversion happens at boundaries
- Parent-child navigation uses callbacks (no hardcoded pop counts)
- See `AGENTS.md` for development guidelines

## License

MIT