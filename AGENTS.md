# Garmin App - Development Best Practices

> **Important:** Please read the [ARCHITECTURE.md](ARCHITECTURE.md) document first to understand the overall application structure before diving into these development best practices.

This document describes the Garmin Connect IQ best practices for application development, focusing on platform-specific patterns, component lifecycles, and recommended implementation approaches.

## API Documentation

Garmin Connect IQ API Documentation: https://developer.garmin.com/connect-iq/api-docs/

A comprehensive index of Garmin Connect IQ documentation resources is available in the `GARMIN_DOCS.md` file, which contains organized links to all core topics of the Garmin development platform.

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

## Menu Display Implementation

### MenuItem Usage

The app uses WatchUi.MenuItem with the following structure:
- Main label: Shows primary information 
- Sub label: Shows secondary information
- Identifier: Unique ID for handling selection events
- Options: Controls alignment and presentation (left aligned for better readability)

**Example**:
```
_menu.addItem(new WatchUi.MenuItem(
    "Primary Text",
    "Secondary Text",
    "item_identifier",
    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
));
```
