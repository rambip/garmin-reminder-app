import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;

// The main menu shown when first entering the app
class MainMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title => "Reminder App"});
        populateMenu();
    }

    // Populate the menu with main options
    function populateMenu() {
        // Add the two main menu options with left alignment for better readability
        addItem(new WatchUi.MenuItem(
            "Add Reminder",
            "Create a new reminder",
            "add_reminder",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        addItem(new WatchUi.MenuItem(
            "See Reminders",
            "View your reminders",
            "see_reminders",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }
}

// Delegate for handling the main menu interactions
class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var itemId = item.getId();
        System.println("Selected main menu item: " + itemId);

        if (itemId.equals("add_reminder")) {
            // Start the add reminder process with the category selection menu
            var categoryMenu = new CategoryMenu();
            var categoryDelegate = new CategoryMenuDelegate();
            WatchUi.pushView(categoryMenu, categoryDelegate, WatchUi.SLIDE_UP);
        } else if (itemId.equals("see_reminders")) {
            // Show the reminders menu
            var menu = new ReminderMenu();
            var menuDelegate = new ReminderMenuDelegate();
            WatchUi.pushView(menu, menuDelegate, WatchUi.SLIDE_UP);
        }
    }

    function onBack() {
        // Exit the app
        System.exit();
        return true;
    }
}

// Classes for the add reminder flow are defined in ViewManager.mc

// Menu class for displaying reminders in a native Garmin menu
class ReminderMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title => "Reminders"});
        populateMenu();
    }

    // Populate the menu with reminder items
    function populateMenu() {
        // Get reminders for today using the system function
        var todayInfo = getTodayInfo();
        var dateKey = todayInfo[:key];
        var reminders = remindersData.get(dateKey);

        // No header - we start directly with the reminders

        // Add reminders to the menu with new structure
        if (reminders != null && reminders.size() > 0) {
            for (var i = 0; i < reminders.size(); i++) {
                // Get reminder data
                var category = reminders[i][:category];
                var timeScope = reminders[i][:timeScope];
                var firstLetter = reminders[i][:firstLetter];

                // Create display format with full category name and first letter
                addItem(new WatchUi.MenuItem(
                    Lang.format("$1$ [$2$]", [category, firstLetter]),
                    timeScope,
                    "reminder_" + i,
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            }
        } else {
            addItem(new WatchUi.MenuItem(
                "No reminders",
                "Add some!",
                "no_reminders",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
        }

        // No footer - menu ends with the last reminder
    }
}

// Menu delegate to handle reminders menu interactions
class ReminderMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var itemId = item.getId();
        System.println("Selected reminder menu item: " + itemId);

        // Process selection based on item ID
        if (itemId instanceof String && itemId.find("reminder_") == 0) {
            // This is a reminder item - could implement actions here
            // For example, view details, mark as done, etc.
            WatchUi.requestUpdate();
        }

        // Display a confirmation that the item was selected
        System.println("Selected: " + item.getLabel());

        // Return to the previous view with animation
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        // Go back to the main menu
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        // No return value for Menu2InputDelegate onBack
    }
}
