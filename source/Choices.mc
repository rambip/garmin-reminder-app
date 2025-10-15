using Toybox.WatchUi;

// A generic Menu2InputDelegate that accepts callbacks for select and back actions.
class GenericMenu2Delegate extends WatchUi.Menu2InputDelegate {
    hidden var _onSelectCallback;
    hidden var _onBackCallback;

    // Constructor takes two optional callbacks: onSelect(item), onBack()
    function initialize(onSelectCallback, onBackCallback) {
        Menu2InputDelegate.initialize();
        _onSelectCallback = onSelectCallback;
        _onBackCallback = onBackCallback;
    }

    function onSelect(item) {
        if (_onSelectCallback != null) {
            _onSelectCallback.invoke(item);
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        if (_onBackCallback != null) {
            _onBackCallback.invoke();
        } else {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
}

class ChoiceMenuView {
    function onLayout() {

    }
}

// A delegate for multi-step menu selection, using explicit step variables and switch logic.
class ChoiceMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _step;
    hidden var _partialReminder;

    function initialize() {
        _partialReminder = new PartialReminder();
    }

    function onSelect(item) {
        var menu;
        if (_partialReminder.category == null) {
            _partialReminder.category = item.getId();
            menu = getMenu(1);
        }
        else if (_partialReminder.timeScope == null) {
            _partialReminder.timeScope = item.getId();
            menu = getMenu(2);
        }
        else if (_partialReminder.letterGroup == null) {
            _partialReminder.letterGroup = item.getId();
            menu = getMenu(3);
        }
        else if (_partialReminder.letter == null) {
            // FIXME: symbol to letter ?
            _partialReminder.letter = item.getId();
            _partialReminder.save();
            var reminderAddedView = new ReminderAddedView(_partialReminder);
            var reminderAddedDelegate = new ReminderAddedDelegate();
            WatchUi.switchToView(
                reminderAddedView,
                reminderAddedDelegate,
                WatchUi.SLIDE_LEFT
            );
            return;
        }
        else {
            System.error("Partial reminder is complete: bug");
        }
        WatchUi.switchToView(menu, self, WatchUi.SLIDE_UP);
    }

    function onBack() {
    }

    function initialMenu() {
        return getMenu(0);
    }

    function getMenu(step) {
        var menu;
        if (step == 0) {
            return new Rez.Menus.CategoryMenu();
        }
        if (step == 1) {
            // Use Rez.Menus.TimeMenu for time selection
            menu = new Rez.Menus.TimeMenu();
        } else if (step == 2) {
            // Letter group menu (manual, as no resource exists)
            menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.CategoryMenuTitle)});
            menu.addItem(new WatchUi.MenuItem(
                "B C D F G",
                null,
                "group1",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
            menu.addItem(new WatchUi.MenuItem(
                "H J L M N",
                null,
                "group2",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
            menu.addItem(new WatchUi.MenuItem(
                "P Q R S T V",
                null,
                "group3",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
        } else if (step == 3) {
            // Letter menu (manual, as no resource exists)
            menu = new WatchUi.Menu2({:title => "Select Letter"});
            // For demonstration, just show group1 letters. In real use, you'd branch on previous selection.
            menu.addItem(new WatchUi.MenuItem(
                "B",
                null,
                "B",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
            menu.addItem(new WatchUi.MenuItem(
                "C",
                null,
                "C",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
            menu.addItem(new WatchUi.MenuItem(
                "D",
                null,
                "D",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
            menu.addItem(new WatchUi.MenuItem(
                "F",
                null,
                "F",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
            menu.addItem(new WatchUi.MenuItem(
                "G",
                null,
                "G",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
        }
        else {
            System.error("step not known");
        }
        return menu;
    }
}
