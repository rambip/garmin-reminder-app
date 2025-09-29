import Toybox.WatchUi;

class CategoryMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title => "Select Category"});
        populateMenu();
    }

    function populateMenu() {
        addItem(new WatchUi.MenuItem(
            "Work",
            null,
            "work",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "Friends",
            null,
            "friends",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "Family",
            null,
            "family",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "Message",
            null,
            "message",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "Administrative",
            null,
            "administrative",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }
}

class CategoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var category = item.getId();
        System.println("Selected category: " + category);

        var timeMenu = new TimeMenu(category);
        var timeDelegate = new TimeMenuDelegate(category);
        WatchUi.pushView(timeMenu, timeDelegate, WatchUi.SLIDE_LEFT);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class TimeMenu extends WatchUi.Menu2 {
    hidden var _category;

    function initialize(category) {
        Menu2.initialize({:title => "Select Time"});
        _category = category;
        populateMenu();
    }

    function populateMenu() {
        addItem(new WatchUi.MenuItem(
            "Urgent",
            null,
            "urgent",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "Today",
            null,
            "today",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "Later",
            null,
            "later",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }
}

class TimeMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _category;

    function initialize(category) {
        Menu2InputDelegate.initialize();
        _category = category;
    }

    function onSelect(item) {
        var timeScope = item.getId();
        System.println("Selected time scope: " + timeScope);

        var letterMenu = new LetterMenu(_category, timeScope);
        var letterDelegate = new LetterMenuDelegate(_category, timeScope);
        WatchUi.pushView(letterMenu, letterDelegate, WatchUi.SLIDE_LEFT);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

class LetterMenu extends WatchUi.Menu2 {
    hidden var _category;
    hidden var _timeScope;

    function initialize(category, timeScope) {
        Menu2.initialize({:title => "Select Letter"});
        _category = category;
        _timeScope = timeScope;
        populateMenu();
    }

    function populateMenu() {
        addItem(new WatchUi.MenuItem(
            "N",
            null,
            "N",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "R",
            null,
            "R",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "S",
            null,
            "S",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "T",
            null,
            "T",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "C",
            null,
            "C",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }
}

class LetterMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _category;
    hidden var _timeScope;

    function initialize(category, timeScope) {
        Menu2InputDelegate.initialize();
        _category = category;
        _timeScope = timeScope;
    }

    function onSelect(item) {
        var letter = item.getId();
        System.println("Selected letter: " + letter);

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
