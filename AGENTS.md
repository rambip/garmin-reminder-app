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

// Handle menu selection with symbols
function onSelect(item) {
    if (item.getId() == :add_reminder) {
        // Handle add reminder selection
    }
}
```

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
