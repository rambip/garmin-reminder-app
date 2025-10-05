This is your guide. Each time you learn something new, add a small section in this file.

**HARD RULE: Maximum 5 lines added per edit to this file.**

# Garmin Connect IQ Development Guidelines

## Concision

Code should be like this file: compact, focused, with flexibility only when strictly necessary.

You can propose a feature in your answer, but don't implement it if not asked.

## Watch for Unexpected Behavior
MonkeyC has non-standard behavior in many areas. Don't assume it matches other languages. Always:
- Read documentation before implementing non-trivial features
- test any argument invariants at the start of the function, and crash the app if it does not hold.

## Architecture

Read [ARCHITECTURE.md](ARCHITECTURE.md) first for overall application structure.

## Documentation

Local documentation is available in:
- `garmin_docs/api/` - API reference
- `garmin_docs/guide/` - Implementation guides
- `garmin_docs/language/` - MonkeyC language reference
- [`GARMIN_DOCS.md`](GARMIN_DOCS.md) - Comprehensive index

## Build & Run

Build each time you add a feature.

```
./build.sh         # Compile for fr165 device
monkeydo result.prg fr165  # Run in simulator
```

## UI Component Patterns

Use composition over inheritance for UI components:

```
class MyMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _menu;

    function initialize() {
        Menu2InputDelegate.initialize();
        _menu = new WatchUi.Menu2({:title => "My Menu"});
    }

    function getMenu() {
        return _menu;
    }
}

// Usage
var menuDelegate = new MyMenuDelegate();
WatchUi.pushView(menuDelegate.getMenu(), menuDelegate, WatchUi.SLIDE_UP);
```

## View Lifecycle

```
function onLayout(dc) {
    setLayout(Rez.Layouts.MyLayout(dc));
}

function onShow() {
    _titleText = WatchUi.loadResource(Rez.Strings.MyTitle);
    _label = View.findDrawableById("myLabel");
    _label.setText(_titleText);
}

function onHide() {
    _titleText = null;
    _label = null;  // Free memory
}
```

## Layout Structure

```
<resources>
    <layouts>
        <layout id="MyLayout">
            <label id="titleLabel" x="center" y="20%" font="Graphics.FONT_MEDIUM" />
        </layout>
    </layouts>
</resources>
```

## Resource Structure

The compiler automatically processes resources based on directory structure:
- `resources/strings/` - String resources
- `resources/layouts/` - Layout definitions
- `resources/menus/` - Menu definitions
- `resources/drawables/` - Images and bitmaps

Resource qualifiers for targeting specific devices/languages:
- `resources-fr165/` - Device-specific
- `resources-deu/` - Language-specific
- `resources-round-218x218/` - Screen size-specific

## Menu Examples

MenuItem usage:
```
_menu.addItem(new WatchUi.MenuItem(
    "Primary Text",
    "Secondary Text",
    "item_identifier",
    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
));
```

Menu resources:
```
<menus>
    <menu2 id="MainMenu" title="@Strings.MainMenuTitle">
        <menu-item id="add_reminder" label="@Strings.AddReminderLabel"
                   subLabel="@Strings.AddReminderSubLabel">
            <param name="alignment">WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT</param>
        </menu-item>
    </menu2>
</menus>
```

Working with symbols:
```
// Push a menu from resources
WatchUi.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(), WatchUi.SLIDE_UP);

// Convert symbols to strings immediately in onSelect
function onSelect(item) {
    var categorySymbol = item.getId();  // Symbol like :work
    var categoryStr = getCategoryString(categorySymbol);  // "Work"
    var delegate = new ChildDelegate(categoryStr);  // Pass string
}

// Simple symbol-to-string converter
function getCategoryString(categorySymbol) {
    var map = {:work => Rez.Strings.CategoryWork, :friends => Rez.Strings.CategoryFriends};
    return map.hasKey(categorySymbol) ? WatchUi.loadResource(map[categorySymbol]) : categorySymbol.toString();
}
```

Symbol-to-string: Use simple map with symbol keys. Convert ONCE at source, pass strings everywhere.

## Storage

Storage limitations:
- `Lang.Symbol` cannot be stored directly
- Keys and values limited to 8KB each, 128KB total app storage

Symbol-to-string mapping:
```
// Store a symbol by converting to string
function storeCategory(categorySymbol) {
    var stringMap = {:work => "work", :family => "family"};
    if (stringMap.hasKey(categorySymbol)) {
        Storage.setValue("lastCategory", stringMap[categorySymbol]);
    }
}
```


## Build Annotations

Conditional compilation using annotations:
```
(:debug) function log(message) { System.println("DEBUG: " + message); }
(:release) function log(message) { }
```

## Imports

```
import Toybox.WatchUi;
import Toybox.Graphics;
import Rez;  // Auto-generated module for all resources
```

Custom project files (.mc) are automatically imported - no explicit import statements needed for your own code files. The compiler automatically finds and includes all .mc files in your project.

```
// Example: If you have these files:
// - MyProject/source/MyView.mc
// - MyProject/source/MyDelegate.mc

// In MyView.mc, you can directly use classes from MyDelegate.mc:
function initialize() {
    // No import needed, MyCustomDelegate is automatically available
    _delegate = new MyCustomDelegate();
}
```

## Parent-Child Navigation Callbacks

Avoid hardcoded multiple pops. Use callbacks so each view only knows its immediate parent.

```
// Parent creates callback and passes to child
var child = new ChildDelegate(method(:onComplete));
WatchUi.pushView(childView, child, WatchUi.SLIDE_LEFT);

function onComplete() {
    WatchUi.popView(WatchUi.SLIDE_LEFT);  // Pop myself
    if (_parentCallback != null) { _parentCallback.invoke(); }  // Notify my parent
}

// Child stores callback and invokes when done
class ChildDelegate {
    hidden var _callback;
    function initialize(callback) { _callback = callback; }
    function onDone() { WatchUi.popView(WatchUi.SLIDE_LEFT); _callback.invoke(); }
}
```

Child pops itself, calls callback. Parent pops itself, calls its parent. Chain collapses automatically.
