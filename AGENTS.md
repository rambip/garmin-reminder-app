# Garmin App - Agents

This document describes the agent architecture of the Garmin reminder application, explaining the core components in the system. The application follows a minimal input philosophy, focusing on quick reminder creation with just three key data points.

## API Documentation

Garmin Connect IQ API Documentation: https://developer.garmin.com/connect-iq/api-docs/

A comprehensive index of Garmin Connect IQ documentation resources is available in the `GARMIN_DOCS.md` file, which contains organized links to all core topics of the Garmin development platform.

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

**Running the Application**:
- To run the compiled app on a simulator, use the command: `monkeydo result.prg fr165`
- This launches the application on the fr165 device simulator
- Essential for testing functionality before deploying to physical devices

## Design Principles

### Component Architecture

**Pattern**: Use composition over inheritance for UI components.

**Implementation**:
- Do NOT subclass framework components like `WatchUi.Menu2`
- Instead, create delegate classes that extend appropriate delegate base classes
- Store framework components as member variables
- Provide accessor methods to retrieve the components when needed

**Example**:
```
// Correct approach - using composition
class MyMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _menu;  // Store as member variable
    
    function initialize() {
        Menu2InputDelegate.initialize();
        _menu = new WatchUi.Menu2({:title => "My Menu"});
        // Add items, configure menu
    }
    
    function getMenu() {
        return _menu;  // Accessor method
    }
}

// Usage
var menuDelegate = new MyMenuDelegate();
WatchUi.pushView(menuDelegate.getMenu(), menuDelegate, WatchUi.SLIDE_UP);
```

## View Lifecycle Management

### Layout and Label Handling

**Process**: Views must properly manage the lifecycle of UI elements and resources.

**Implementation**:
1. **onLayout**: Set the layout for the view using `setLayout()`
   - Only define the layout structure
   - Do NOT directly access or manipulate UI elements

2. **onShow**: Load resources and initialize UI elements
   - Load string resources with `WatchUi.loadResource()`
   - Get references to drawable elements with `View.findDrawableById()`
   - Set initial values for labels and other UI elements
   - This separation ensures resources are properly loaded before being used

3. **onUpdate**: Render the view
   - Update dynamic content if needed
   - Call the parent `View.onUpdate(dc)` to handle rendering

4. **onHide**: Clean up resources
   - Set resource variables to null to free memory
   - Essential for memory management on constrained devices

**Example**:
```
function onLayout(dc) {
    setLayout(Rez.Layouts.MyLayout(dc));
}

function onShow() {
    // Load resources
    _titleText = WatchUi.loadResource(Rez.Strings.MyTitle);
    
    // Get UI elements
    _label = View.findDrawableById("myLabel");
    
    // Set values
    _label.setText(_titleText);
}

function onHide() {
    // Free memory
    _titleText = null;
    _label = null;
}
```

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

## Layout Implementation

### Layout XML Structure

**Format**: Each layout file must follow a strict XML structure with proper nesting

**Components**:
- Each layout file must include top-level `<resources>` and nested `<layouts>` tags
- Inside the `<layouts>` tag, individual `<layout>` elements are defined with unique IDs
- UI elements like `<label>` are placed inside the `<layout>` element

**Example**:
```
<resources>
    <layouts>
        <layout id="MyLayout">
            <label id="titleLabel" x="center" y="20%" font="Graphics.FONT_MEDIUM" />
            <!-- More UI elements -->
        </layout>
    </layouts>
</resources>
```

**Usage**:
- Layout files are placed in the `resources/layouts/` directory
- Layout references are defined in `resources.xml` for compilation
- Views access layouts via `setLayout(Rez.Layouts.MyLayout(dc))` in their `onLayout` method
- UI element references must be obtained in `onShow()` using `findDrawableById()`, not in `onUpdate()`