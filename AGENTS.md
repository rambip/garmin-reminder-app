# Garmin App - Agents

This document describes the agent architecture of the Garmin application, explaining the core components in the system.

## Core Agents

### 1. Application Controller (Main)

**Role**: Main application controller that handles lifecycle and initializes the view system.

**Responsibilities**:
- Initialize the application
- Manage application lifecycle
- Create and return initial views
- Provide glance view for the widget

### 2. View Components

#### 2.1 ReminderView

**Role**: Primary view that renders the main interface of the application with reminders.

**Responsibilities**:
- Render the main reminder interface
- Display current reminder and pagination information
- Show counts of upcoming reminders
- Handle layout and presentation

#### 2.2 MinimalView

**Role**: Lightweight view for the Garmin glance feature.

**Responsibilities**:
- Provide a condensed view of today's reminders
- Show the count of reminders for the current day

### 3. Interaction Handlers

#### 3.1 ReminderDelegate

**Role**: Event handler that processes user interactions with reminders.

**Responsibilities**:
- Process button presses and touch inputs
- Cycle through available reminders
- Handle next/previous navigation
- Manage back button behavior

## Data Flow

1. The `Main` class initializes the application and creates reminder data
2. Views display the current reminders based on date
3. User interactions are captured by `ReminderDelegate` which cycles through reminders
4. Views are refreshed with updated information
5. Current reminder index is tracked for cycling through reminders

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
- Reminder objects with text property
- Global index for tracking currently displayed reminder

**Usage**:
- Multiple reminders can be associated with a single date
- Reminders for different dates are separated
- Current index allows cycling through available reminders
