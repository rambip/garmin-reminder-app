# Garmin Reminder App - Architecture

This document describes the core architecture of the Garmin reminder application, outlining the essential components and their interactions.

## Overview

The application follows a minimal input philosophy, focusing on quick reminder creation with just three key data points: category, time scope, and letter code.

## Core Components

### Application Controller

**Main**: Initializes the application, manages lifecycle, and provides the entry point.

### Menu Structure

**MainMenu → CategoryMenu → TimeMenu → LetterGroupMenu → LetterMenu**

The app uses a progressive menu flow for creating reminders with minimal inputs.

### View Components

- **MinimalView**: Glance view showing reminder count
- **ReminderAddedView**: Confirmation screen after creating a reminder
- **ReminderDetailView**: Shows individual reminder details

### Delegates

Each view has a corresponding delegate to handle user interactions:
- **MainMenuDelegate**: Main menu navigation
- **CategoryMenuDelegate**: Category selection
- **ReminderMenuDelegate**: Reminder listing and selection
- **ReminderDetailDelegate**: Individual reminder actions

## Data Flow

1. App launches to MainMenu
2. User selects "Add Reminder" to begin reminder creation flow
3. User progresses through category, time, and letter menus
4. After selection, reminder is added and ReminderAddedView confirms
5. User can view reminders via "See Reminders" option

## Data Structure

### Reminders

Stored as dictionaries with:
- Date key (string timestamp)
- Reminder object:
  - category: Context grouping (work, friends, etc.)
  - timeScope: Priority level (urgent, today, later)
  - firstLetter: Simple letter code for identification