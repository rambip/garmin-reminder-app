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
    hidden var _selectedGroup;

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
            _selectedGroup = item.getId();
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
            // Letter group menu with all letters in alphabetical order across 4 categories
            menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.CategoryMenuTitle)});

            // Group 1: A, B, C, D, E
            menu.addItem(new WatchUi.MenuItem(
                "A B C D E",
                null,
                :group1,
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));

            // Group 2: F, G, H, I, J
            menu.addItem(new WatchUi.MenuItem(
                "F G H I J",
                null,
                :group2,
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));

            // Group 3: K, L, M, N, O
            menu.addItem(new WatchUi.MenuItem(
                "K L M N O",
                null,
                :group3,
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));

            // Group 4: P, Q, R, S, T
            menu.addItem(new WatchUi.MenuItem(
                "P Q R S T",
                null,
                :group4,
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));

            // Group 5: U, V, W, X, Y, Z
            menu.addItem(new WatchUi.MenuItem(
                "U V W X Y Z",
                null,
                :group5,
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
        } else if (step == 3) {
            // Letter menu - dynamically show letters based on selected group
            menu = new WatchUi.Menu2({:title => "Select Letter"});

            // Get the selected group to determine which letters to show
            if (_selectedGroup == :group1) {
                // A, B, C, D, E
                menu.addItem(new WatchUi.MenuItem(
                    "A",
                    null,
                    "A",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
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
                    "E",
                    null,
                    "E",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            } else if (_selectedGroup == :group2) {
                // F, G, H, I, J
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
                menu.addItem(new WatchUi.MenuItem(
                    "H",
                    null,
                    "H",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "I",
                    null,
                    "I",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "J",
                    null,
                    "J",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            } else if (_selectedGroup == :group3) {
                // K, L, M, N, O
                menu.addItem(new WatchUi.MenuItem(
                    "K",
                    null,
                    "K",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "L",
                    null,
                    "L",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "M",
                    null,
                    "M",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "N",
                    null,
                    "N",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "O",
                    null,
                    "O",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            } else if (_selectedGroup == :group4) {
                // P, Q, R, S, T
                menu.addItem(new WatchUi.MenuItem(
                    "P",
                    null,
                    "P",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "Q",
                    null,
                    "Q",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "R",
                    null,
                    "R",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "S",
                    null,
                    "S",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "T",
                    null,
                    "T",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            } else if (_selectedGroup == :group5) {
                // U, V, W, X, Y, Z
                menu.addItem(new WatchUi.MenuItem(
                    "U",
                    null,
                    "U",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "V",
                    null,
                    "V",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "W",
                    null,
                    "W",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "X",
                    null,
                    "X",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "Y",
                    null,
                    "Y",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
                menu.addItem(new WatchUi.MenuItem(
                    "Z",
                    null,
                    "Z",
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            }
        }
        else {
            System.error("step not known");
        }
        return menu;
    }
}
