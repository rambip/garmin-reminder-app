import Toybox.WatchUi;
import Toybox.Graphics;
import Rez;
using Toybox.Lang;
// Use the utility functions from StringUtils

class CategoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
        log("CategoryMenuDelegate initialized");
    }

    // When a category is selected
    function onSelect(item) {
        var category = item.getId();
        log("CategoryMenuDelegate.onSelect called with category: " + category);

        // Show the time scope menu
        var timeDelegate = new TimeMenuDelegate(category);
        log("About to push time menu view");
        WatchUi.pushView(new Rez.Menus.TimeMenu(), timeDelegate, WatchUi.SLIDE_LEFT);
        log("Time menu view pushed");
    }

    function onBack() {
        log("CategoryMenuDelegate.onBack called");
        log("About to pop category view");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        log("Category view popped");
    }
}

class TimeMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _category;

    function initialize(category) {
        Menu2InputDelegate.initialize();
        _category = category;
        log("TimeMenuDelegate initialized with category: " + category);
    }



    function onSelect(item) {
        var timeScope = item.getId();
        log("TimeMenuDelegate.onSelect called with timeScope: " + timeScope);

        log("Creating LetterGroupMenuDelegate");
        var letterGroupDelegate = new LetterGroupMenuDelegate(_category, timeScope);
        log("About to push letter group menu view");
        WatchUi.pushView(letterGroupDelegate.getMenu(), letterGroupDelegate, WatchUi.SLIDE_LEFT);
        log("Letter group menu view pushed");
    }

    function onBack() {
        log("TimeMenuDelegate.onBack called");
        log("About to pop time scope view");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        log("Time scope view popped");
    }
}

class LetterGroupMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _category;
    hidden var _timeScope;
    hidden var _menu;

    function initialize(category, timeScope) {
        Menu2InputDelegate.initialize();
        _category = category;
        _timeScope = timeScope;
        log("LetterGroupMenuDelegate initialized with category: " + category + ", timeScope: " + timeScope);

        // Create the menu
        _menu = new WatchUi.Menu2({:title => "Select Group"});

        // Populate the menu with letter groups
        _menu.addItem(new WatchUi.MenuItem(
            "B C D F G",
            null,
            "group1",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "H J L M N",
            null,
            "group2",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "P Q R S T V",
            null,
            "group3",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }

    // Get the menu instance
    function getMenu() {
        log("LetterGroupMenuDelegate.getMenu called");
        return _menu;
    }

    function onSelect(item) {
        var groupId = item.getId();
        log("LetterGroupMenuDelegate.onSelect called with groupId: " + groupId);

        log("Creating LetterMenuDelegate");
        var letterDelegate = new LetterMenuDelegate(_category, _timeScope, groupId);
        log("About to push letter menu view");
        WatchUi.pushView(letterDelegate.getMenu(), letterDelegate, WatchUi.SLIDE_LEFT);
        log("Letter menu view pushed");
    }

    function onBack() {
        log("LetterGroupMenuDelegate.onBack called");
        log("About to pop letter group view");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        log("Letter group view popped");
    }
}

class LetterMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _category;
    hidden var _timeScope;
    hidden var _menu;
    hidden var _groupId;

    function initialize(category, timeScope, groupId) {
        Menu2InputDelegate.initialize();
        _category = category;
        _timeScope = timeScope;
        _groupId = groupId;
        log("LetterMenuDelegate initialized with category: " + category + ", timeScope: " + timeScope + ", groupId: " + groupId);

        // Create the menu
        _menu = new WatchUi.Menu2({:title => "Select Letter"});

        // Populate the menu based on the selected group
        if (_groupId.equals("group1")) {
            addLetters(["B", "C", "D", "F", "G"]);
        } else if (_groupId.equals("group2")) {
            addLetters(["H", "J", "L", "M", "N"]);
        } else if (_groupId.equals("group3")) {
            addLetters(["P", "Q", "R", "S", "T", "V"]);
        }
    }

    // Helper function to add letters to the menu
    function addLetters(letters) {
        for (var i = 0; i < letters.size(); i++) {
            _menu.addItem(new WatchUi.MenuItem(
                letters[i],
                null,
                letters[i],
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
        }
    }

    // Get the menu instance
    function getMenu() {
        log("LetterMenuDelegate.getMenu called");
        return _menu;
    }

    function onSelect(item) {
        var letter = item.getId();
        log("LetterMenuDelegate.onSelect called with letter: " + letter);

        log("Adding reminder with category: " + _category + ", timeScope: " + _timeScope + ", letter: " + letter);
        addReminder(_category, _timeScope, letter);
        log("Reminder added successfully");

        log("Creating ReminderAddedView");
        var reminderAddedView = new ReminderAddedView(_category, _timeScope, letter);
        var reminderAddedDelegate = new ReminderAddedDelegate();
        log("About to push reminder added view");
        WatchUi.pushView(
            reminderAddedView,
            reminderAddedDelegate,
            WatchUi.SLIDE_LEFT
        );
        log("Reminder added view pushed");
    }

    function onBack() {
        log("LetterMenuDelegate.onBack called");
        log("About to pop letter view");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        log("Letter view popped");
    }
}

class ReminderAddedView extends WatchUi.View {
    hidden var _category;
    hidden var _timeScope;
    hidden var _letter;
    hidden var _categoryLabel;
    hidden var _timeScopeLabel;

    function initialize(category, timeScope, letter) {
        View.initialize();

        _category = category;
        _timeScope = timeScope;
        _letter = letter;
        log("ReminderAddedView initialized with category: " + _category + ", timeScope: " + _timeScope + ", letter: " + _letter);
    }

    function onLayout(dc) {
        log("ReminderAddedView.onLayout called");
        setLayout(Rez.Layouts.ReminderAddedLayout(dc));
    }

    // Load strings into memory
    function onShow() {
        log("ReminderAddedView.onShow called");
        // No string resources need to be loaded here, but we maintain the lifecycle pattern
    }

    function onUpdate(dc) {
        log("ReminderAddedView.onUpdate called");
        // Get references to the labels we need to update
        _categoryLabel = View.findDrawableById("category") as WatchUi.Text;
        _timeScopeLabel = View.findDrawableById("timeScope") as WatchUi.Text;

        // Set the dynamic text content
        if (_categoryLabel != null) {
            // Get the display string for the category (handles both symbols and strings)
            var categoryStr = getCategoryString(_category);
            _categoryLabel.setText(categoryStr + " [" + _letter + "]");
        }
        if (_timeScopeLabel != null) {
            // Get the display string for the time scope (handles both symbols and strings)
            var timeScopeStr = getTimeScopeString(_timeScope);
            _timeScopeLabel.setText(timeScopeStr);
        }

        // Let the layout handle the rendering
        View.onUpdate(dc);
    }

    function onHide() {
        log("ReminderAddedView.onHide called");
        // Free resources
        _categoryLabel = null;
        _timeScopeLabel = null;
    }
}

class ReminderAddedDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
        log("ReminderAddedDelegate initialized");
    }

    function onBack() {
        returnToMainMenu();
        return true;
    }
    function onStart() {
        returnToMainMenu();
        return true;
    }
    function onSelect() {
        returnToMainMenu();
        return true;
    }

    function returnToMainMenu() {
        log("ReminderAddedDelegate.onBack called - returning to main menu");
        // Return all the way to the main menu
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        log("All views popped, should be back at main menu now");
    }
}
