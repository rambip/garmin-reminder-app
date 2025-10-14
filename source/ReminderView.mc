import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;
using Toybox.Lang;

// Menu delegate that creates and manages the main menu

// Delegate for handling the main menu interactions
class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
        log("MainMenuDelegate initialized");
    }

    function onSelect(item) {
        var itemId = item.getId();
        log("MainMenuDelegate.onSelect called with item: " + itemId);

        if (itemId == :add_reminder) {
            // Start the add reminder process with the category selection menu
            log("Creating CategoryMenuDelegate");
            var categoryDelegate = new CategoryMenuDelegate();
            log("About to push category menu view");
            WatchUi.pushView(new Rez.Menus.CategoryMenu(), categoryDelegate, WatchUi.SLIDE_UP);
            log("Category menu view pushed");
        } else if (itemId == :see_reminders) {
            // Show the reminders menu
            log("Creating ReminderMenuDelegate");
            var menuDelegate = new ReminderMenuDelegate();
            log("About to push reminder menu view");
            // For dynamic content, we create and populate the menu programmatically
            // Create display format with full category name and first letter
            var menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.RemindersMenuTitle)});

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

            // Add reminders to the menu with new structure
            if (todayReminders.size() > 0) {
                for (var i = 0; i < todayReminders.size(); i++) {
                    // Get reminder data - these are already display strings from storage
                    var category = todayReminders[i]["category"];
                    var timeScope = todayReminders[i]["timeScope"];
                    var firstLetter = todayReminders[i]["firstLetter"];

                    // Create display format with full category name and first letter
                    menu.addItem(new WatchUi.MenuItem(
                        Lang.format("$1$ [$2$]", [category, firstLetter]),
                        timeScope,
                        "reminder_" + i,  // Keep as string since we're creating this menu manually
                        {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                    ));
                }
            } else {
                menu.addItem(new WatchUi.MenuItem(
                    WatchUi.loadResource(Rez.Strings.NoRemindersLabel),
                    WatchUi.loadResource(Rez.Strings.NoRemindersSubLabel),
                    "no_reminders",  // Keep as string since we're creating this menu manually
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
                ));
            }

            WatchUi.pushView(menu, menuDelegate, WatchUi.SLIDE_UP);
            log("Reminder menu view pushed");
        }
    }

    function onBack() {
        log("MainMenuDelegate.onBack called - exiting app");
        // Exit the app
        System.exit();
    }
}

// Classes for the add reminder flow are defined in ViewManager.mc

// Menu delegate to handle reminders menu interactions
class ReminderMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var _deletionOccurred = false;

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onDeletionComplete() {
        log("ReminderMenuDelegate: Deletion occurred, popping immediately");
        _deletionOccurred = true;
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        log("Reminder menu view popped via callback");
    }

    function onSelect(item) {
        var itemId = item.getId();
        log("ReminderMenuDelegate.onSelect called with item: " + itemId);
        log("Reminder menu item selected: " + itemId);

        // Process selection based on item ID
        if (itemId instanceof String && itemId.find("reminder_") == 0) {
            // Extract the index from the ID (e.g., "reminder_2" -> 2)
            var indexStr = itemId.substring(9, itemId.length());
            var index = indexStr.toNumber();
            log("Selected reminder index: " + index);
            log("Preparing to show detail view for reminder: " + index);

            // Open the detail view for this reminder, passing deletion callback
            log("Creating ReminderDetailView for index: " + index);
            var detailView = new ReminderDetailView(index);
            var detailDelegate = new ReminderDetailDelegate(index, method(:onDeletionComplete));
            log("About to push detail view to stack");
            WatchUi.pushView(detailView, detailDelegate, WatchUi.SLIDE_LEFT);
            log("Pushed ReminderDetailView");
            log("Detail view pushed successfully");
            return;
        }

        // Return to the previous view with animation
        log("Item not a reminder, popping reminder menu view");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        log("Reminder menu view popped successfully");
    }

    function onBack() {
        log("ReminderMenuDelegate.onBack called");
        log("Back button pressed from reminder menu");
        // Go back to the main menu
        log("About to pop reminder menu view");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        log("Reminder menu view popped successfully");
        // No return value for Menu2InputDelegate onBack
    }
}
