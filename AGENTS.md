# Garmin App - Agents

This document describes the agent architecture of the Garmin reminder application, explaining the core components in the system. The application follows a minimal input philosophy, focusing on quick reminder creation with just three key data points.

## API Documentation

Garmin Connect IQ API Documentation: https://developer.garmin.com/connect-iq/api-docs/

## Core Agents

### 1. Application Controller (Main)

**Role**: Main application controller that handles lifecycle and initializes the view system.

**Responsibilities**:
- Initialize the application
- Manage application lifecycle
- Create and return initial views
- Provide glance view for the widget

### 2. Menu Components

#### 2.1 MainMenu

**Role**: Primary menu shown when the app is first launched.

**Responsibilities**:
- Display main menu options (Add Reminder, See Reminders)
- Serve as the entry point for the application
- Navigate to appropriate views based on selection

#### 2.2 MainMenuDelegate

**Role**: Event handler for the main menu interactions.

**Responsibilities**:
- Process menu item selections
- Launch appropriate sub-menus or views
- Handle back button behavior

#### 2.3 ReminderMenu

**Role**: Native Garmin menu for displaying and interacting with reminders.

**Responsibilities**:
- Display reminders in a structured menu with category, time scope, and letter code
- Format menu items to show full category name and letter code in label, time scope in sublabel
- Support quick recognition of reminder categories through visual cues
- Allow for easy navigation through items

#### 2.4 ReminderMenuDelegate

**Role**: Event handler for reminder menu interactions.

**Responsibilities**:
- Process reminder item selection
- Handle menu navigation
- Return to main menu when needed

### 3. View Components

#### 3.1 MinimalView

**Role**: Lightweight view for the Garmin glance feature.

**Responsibilities**:
- Provide a condensed view of reminders
- Display simple total reminder count

#### 3.2 NotImplementedView

**Role**: Placeholder view for features that are not yet implemented.

**Responsibilities**:
- Display a message indicating the feature is coming soon
- Provide feedback for planned functionality

#### 3.3 PlaceholderDelegate

**Role**: Simple delegate for placeholder views.

**Responsibilities**:
- Handle back button for not-yet-implemented features
- Return to previous screen

## Data Flow

1. The `Main` class initializes the application and creates reminder data
2. The app launches directly to the `MainMenu`
3. User selects "See Reminders" to open the `ReminderMenu`
4. The `ReminderMenu` displays all reminders in a structured list
5. User can navigate and select specific reminders
6. Menu actions return the user to the previous menu or view

## Menu Display Implementation

### MenuItem Usage

The app uses WatchUi.MenuItem with the following structure:
- Main label: Shows full category name and letter code "work [N]" (Work reminder with code N)
- Sub label: Shows time scope (morning, afternoon, evening)
- Identifier: Structured as "reminder_X" where X is the index
- Options: Controls alignment and presentation (left aligned for better readability)

## Build System

### Build Script (build.sh)

**Role**: Compiles the application for the target device.

**Responsibilities**:
- Compiles Monkey C code using monkeyc compiler
- Sets the target device (fr165)
- Uses the developer key for signing
- Outputs to result.prg

**Usage**:
- Run `./build.sh` after each major code change
- Ensures changes are properly compiled and ready for testing
- Creates result.prg file that can be installed on the device

## Data Structure

### Reminders Storage

**Format**: Dictionary with date keys and arrays of reminder objects

**Components**:
- Date keys (stored as string timestamps)
- Reminder objects with three properties:
  - category: Context grouping (work, friends, family, message, administrative)
  - timeScope: Priority level (urgent, today, later)
  - firstLetter: Simple letter code (N, R, S, T, C) without specific meanings

**Usage**:
- Multiple reminders can be associated with a single date
- Reminders are categorized for easier mental mapping
- Minimal data structure supports quick input and recognition
- Time scopes help prioritize when tasks should be completed
- Fixed letter codes (N, R, S, T, C) simplify selection and provide basic identifiers