# Garmin Reminder App

A simple Garmin Connect IQ widget that displays and manages daily reminders on Garmin devices with minimal input requirements.

## Philosophy

This app is designed with speed of input in mind. Instead of typing out full reminder text, users only need to provide three pieces of information through a simple sequence of menus:
- **Category**: Work, Friends, Family, Message, Administrative
- **Time Scope**: Urgent, Today, Later
- **First Letter**: Choose from predefined codes: N, R, S, T, C (simple identifiers without specific meanings)

This minimalist approach enables quick reminder creation even on small watch screens, avoiding the need for complex text input. The app automatically stores all reminders with the current day's date.

## Features

- Create reminders with minimal input (just 3 quick menu selections)
- View reminders categorized by type in both app and glance view
- See indexed reminders for better organization
- Easy navigation with select button, swipe up, and swipe down gestures
- Automatic date assignment to today for all new reminders
- Confirmation screen after adding a reminder

## Supported Devices

- Forerunner 165

## Development

This app is built using Monkey C for Garmin Connect IQ. To build the project:

1. Install the Garmin Connect IQ SDK
2. Run `./build.sh` to compile for the target device
3. Use the Garmin Connect IQ app to install the result.prg file on your device

## Project Structure

- `source/Main.mc` - Application base, glance view, and data initialization
- `source/ReminderView.mc` - Main UI and interaction handling for the widget

## Reminder Structure

Reminders consist of three elements:
1. **Category** - A context grouping (work, friends, family, message, administrative)
2. **Time Scope** - Priority level (urgent, today, later)
3. **First Letter** - One of five predefined letter codes (N, R, S, T, C)
   - These are simple identifier codes without specific meanings
   - Quick to select and easy to remember
   - Can be assigned any meaning by the user

For example:
- work [N] - urgent → Work reminder with code N that needs urgent attention
- family [C] - later → Family reminder with code C that can be handled later

## How to Add Reminders

1. Select "Add Reminder" from the main menu
2. Choose a category (Work, Friends, Family, Message, Administrative)
3. Select a time scope (Urgent, Today, Later)
4. Select one of the letter codes (N, R, S, T, C)
5. View the confirmation screen
6. Press back to return to the main menu

## Future Enhancements

- Implement persistent storage for reminders
- Add reminder notifications
- Support additional Garmin devices
- Expand category options while maintaining minimal input philosophy
- Add ability to delete or mark reminders as complete
