import Toybox.WatchUi;

class CategoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _menu;

    function initialize() {
        Menu2InputDelegate.initialize();

        // Create the menu
        _menu = new WatchUi.Menu2({:title => "Select Category"});

        // Populate the menu
        _menu.addItem(new WatchUi.MenuItem(
            "Work",
            null,
            "work",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "Friends",
            null,
            "friends",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "Family",
            null,
            "family",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "Message",
            null,
            "message",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "Administrative",
            null,
            "administrative",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "Domestic",
            null,
            "domestic",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }

    // Get the menu instance
    function getMenu() {
        return _menu;
    }

    function onSelect(item) {
        var category = item.getId();

        var timeDelegate = new TimeMenuDelegate(category);
        WatchUi.pushView(timeDelegate.getMenu(), timeDelegate, WatchUi.SLIDE_LEFT);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class TimeMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _category;
    hidden var _menu;

    function initialize(category) {
        Menu2InputDelegate.initialize();
        _category = category;

        // Create the menu
        _menu = new WatchUi.Menu2({:title => "Select Time"});

        // Populate the menu
        _menu.addItem(new WatchUi.MenuItem(
            "Urgent",
            null,
            "urgent",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "Today",
            null,
            "today",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "Later",
            null,
            "later",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }

    // Get the menu instance
    function getMenu() {
        return _menu;
    }

    function onSelect(item) {
        var timeScope = item.getId();

        var letterGroupDelegate = new LetterGroupMenuDelegate(_category, timeScope);
        WatchUi.pushView(letterGroupDelegate.getMenu(), letterGroupDelegate, WatchUi.SLIDE_LEFT);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
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
        return _menu;
    }

    function onSelect(item) {
        var groupId = item.getId();

        var letterDelegate = new LetterMenuDelegate(_category, _timeScope, groupId);
        WatchUi.pushView(letterDelegate.getMenu(), letterDelegate, WatchUi.SLIDE_LEFT);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
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
        return _menu;
    }

    function onSelect(item) {
        var letter = item.getId();

        addReminder(_category, _timeScope, letter);

        WatchUi.pushView(
            new ReminderAddedView(_category, _timeScope, letter),
            new ReminderAddedDelegate(),
            WatchUi.SLIDE_LEFT
        );
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

class ReminderAddedView extends WatchUi.View {
    hidden var _category;
    hidden var _timeScope;
    hidden var _letter;

    function initialize(category, timeScope, letter) {
        View.initialize();
        _category = category;
        _timeScope = timeScope;
        _letter = letter;
    }

    function onLayout(dc) {
        // Nothing to do
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_WHITE);
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/4,
            Graphics.FONT_MEDIUM,
            "Reminder Added",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/2 - 15,
            Graphics.FONT_SMALL,
            _category + " [" + _letter + "]",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/2 + 15,
            Graphics.FONT_SMALL,
            _timeScope,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_WHITE);
        dc.drawText(
            dc.getWidth()/2,
            (dc.getHeight()*3)/4,
            Graphics.FONT_TINY,
            "Press Back to return",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}

class ReminderAddedDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        // Return all the way to the main menu
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
