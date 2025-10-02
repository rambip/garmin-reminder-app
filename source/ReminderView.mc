import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;

// Menu delegate that creates and manages the main menu

// Delegate for handling the main menu interactions
class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _menu;

    function initialize() {
        Menu2InputDelegate.initialize();

        // Create the main menu
        _menu = new WatchUi.Menu2({:title => "Reminder App"});

        // Populate the menu with main options
        _menu.addItem(new WatchUi.MenuItem(
            "Add Reminder",
            "Create a new reminder",
            "add_reminder",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));

        _menu.addItem(new WatchUi.MenuItem(
            "See Reminders",
            "View your reminders",
            "see_reminders",
            {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        ));
    }

    // Get the menu instance
    function getMenu() {
        return _menu;
    }

    function onSelect(item) {
        var itemId = item.getId();

        if (itemId.equals("add_reminder")) {
            // Start the add reminder process with the category selection menu
            var categoryDelegate = new CategoryMenuDelegate();
            WatchUi.pushView(categoryDelegate.getMenu(), categoryDelegate, WatchUi.SLIDE_UP);
        } else if (itemId.equals("see_reminders")) {
            // Show the reminders menu
            var menuDelegate = new ReminderMenuDelegate();
            WatchUi.pushView(menuDelegate.getMenu(), menuDelegate, WatchUi.SLIDE_UP);
        }
    }

    function onBack() {
        // Exit the app
        System.exit();
        return true;
    }
}

// Classes for the add reminder flow are defined in ViewManager.mc

// Menu delegate to handle reminders menu interactions
class ReminderMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _menu;

    function initialize() {
        Menu2InputDelegate.initialize();

        // Create the menu
        _menu = new WatchUi.Menu2({:title => "Reminders"});

        // We'll populate it in getMenu() before it's shown
    }

    // Get and populate the menu before it's shown
    function getMenu() {
        // Create a new menu instance instead of clearing the existing one
        _menu = new WatchUi.Menu2({:title => "Reminders"});

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
                _menu.addItem(new WatchUi.MenuItem(
                    Lang.format("$1$ [$2$]", [category, firstLetter]),
                    timeScope,
                    "reminder_" + i,
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            }
        } else {
            _menu.addItem(new WatchUi.MenuItem(
                "No reminders",
                "Add some!",
                "no_reminders",
                {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
            ));
        }

        return _menu;
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
