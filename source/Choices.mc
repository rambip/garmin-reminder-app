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

    // Arrays for letter groups to improve readability
    hidden var _group1Letters = ["A", "B", "C", "D", "E"];
    hidden var _group2Letters = ["F", "G", "H", "I", "J"];
    hidden var _group3Letters = ["K", "L", "M", "N", "O"];
    hidden var _group4Letters = ["P", "Q", "R", "S", "T"];
    hidden var _group5Letters = ["U", "V", "W", "X", "Y", "Z"];

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
        else if (_selectedGroup == null) {
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
            // Letter group menu with all letters in alphabetical order across 5 categories
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
                // Loop through group 1 letters using classic for loop
                for (var i = 0; i < _group1Letters.size(); i++) {
                    var letter = _group1Letters[i];
                    menu.addItem(new WatchUi.MenuItem(
                        letter,
                        null,
                        letter,
                        {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                    ));
                }
            } else if (_selectedGroup == :group2) {
                // Loop through group 2 letters using classic for loop
                for (var i = 0; i < _group2Letters.size(); i++) {
                    var letter = _group2Letters[i];
                    menu.addItem(new WatchUi.MenuItem(
                        letter,
                        null,
                        letter,
                        {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                    ));
                }
            } else if (_selectedGroup == :group3) {
                // Loop through group 3 letters using classic for loop
                for (var i = 0; i < _group3Letters.size(); i++) {
                    var letter = _group3Letters[i];
                    menu.addItem(new WatchUi.MenuItem(
                        letter,
                        null,
                        letter,
                        {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                    ));
                }
            } else if (_selectedGroup == :group4) {
                // Loop through group 4 letters using classic for loop
                for (var i = 0; i < _group4Letters.size(); i++) {
                    var letter = _group4Letters[i];
                    menu.addItem(new WatchUi.MenuItem(
                        letter,
                        null,
                        letter,
                        {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                    ));
                }
            } else if (_selectedGroup == :group5) {
                // Loop through group 5 letters using classic for loop
                for (var i = 0; i < _group5Letters.size(); i++) {
                    var letter = _group5Letters[i];
                    menu.addItem(new WatchUi.MenuItem(
                        letter,
                        null,
                        letter,
                        {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                    ));
                }
            }
        }
        else {
            System.error("step not known");
        }
        return menu;
    }
}
