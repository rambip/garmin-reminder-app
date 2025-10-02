import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;

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
        // Get all reminders
        var allReminders = getReminders();
        var todayKey = getTodayKey();

        var todayReminders = [];

        // Filter for today's reminders
        for (var i = 0; i < allReminders.size(); i++) {
            var reminderDate = allReminders[i]["date"];
            if (reminderDate.toString().equals(todayKey)) {
                todayReminders.add(allReminders[i]);
            }
        }

        // No header - we start directly with the reminders

        // Add reminders to the menu with new structure
        if (todayReminders.size() > 0) {
            for (var i = 0; i < todayReminders.size(); i++) {
                // Get reminder data
                var category = todayReminders[i]["category"];
                var timeScope = todayReminders[i]["timeScope"];
                var firstLetter = todayReminders[i]["firstLetter"];

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
        System.println("DEBUG: ReminderMenuDelegate.onSelect called with item: " + itemId);

        // Process selection based on item ID
        if (itemId instanceof String && itemId.find("reminder_") == 0) {
            // Extract the index from the ID (e.g., "reminder_2" -> 2)
            var indexStr = itemId.substring(9, itemId.length());
            var index = indexStr.toNumber();
            System.println("DEBUG: Selected reminder index: " + index);

            // Open the detail view for this reminder
            System.println("DEBUG: Creating ReminderDetailView for index: " + index);
            var detailView = new ReminderDetailView(index);
            var detailDelegate = new ReminderDetailDelegate(index);
            WatchUi.pushView(detailView, detailDelegate, WatchUi.SLIDE_LEFT);
            System.println("DEBUG: Pushed ReminderDetailView");
            return;
        }

        // Return to the previous view with animation
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        System.println("DEBUG: ReminderMenuDelegate.onBack called");
        // Go back to the main menu
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        // No return value for Menu2InputDelegate onBack
    }
}
