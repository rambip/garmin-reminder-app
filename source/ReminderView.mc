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
        System.println("DEBUG-NAV: MainMenuDelegate initialized");
    }

    function onSelect(item) {
        var itemId = item.getId();
        System.println("DEBUG-NAV: MainMenuDelegate.onSelect called with item: " + itemId);

        if (itemId == :add_reminder) {
            // Start the add reminder process with the category selection menu
            System.println("DEBUG-NAV: Creating CategoryMenuDelegate");
            var categoryDelegate = new CategoryMenuDelegate();
            System.println("DEBUG-NAV: About to push category menu view");
            WatchUi.pushView(new Rez.Menus.CategoryMenu(), categoryDelegate, WatchUi.SLIDE_UP);
            System.println("DEBUG-NAV: Category menu view pushed");
        } else if (itemId == :see_reminders) {
            // Show the reminders menu
            System.println("DEBUG-NAV: Creating ReminderMenuDelegate");
            var menuDelegate = new ReminderMenuDelegate();
            System.println("DEBUG-NAV: About to push reminder menu view");
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
                    // Get reminder data
                    var category = todayReminders[i]["category"];
                    var timeScope = todayReminders[i]["timeScope"];
                    var firstLetter = todayReminders[i]["firstLetter"];

                    // Get display strings for category and timeScope
                    // These will handle both symbols and strings properly
                    var categoryStr = getCategoryString(category);
                    var timeScopeStr = getTimeScopeString(timeScope);

                    // Create display format with full category name and first letter
                    menu.addItem(new WatchUi.MenuItem(
                        Lang.format("$1$ [$2$]", [categoryStr, firstLetter]),
                        timeScopeStr,
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
            System.println("DEBUG-NAV: Reminder menu view pushed");
        }
    }

    function onBack() {
        System.println("DEBUG-NAV: MainMenuDelegate.onBack called - exiting app");
        // Exit the app
        System.exit();
        return true;
    }
}

// Classes for the add reminder flow are defined in ViewManager.mc

// Menu delegate to handle reminders menu interactions
class ReminderMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var itemId = item.getId();
        System.println("DEBUG: ReminderMenuDelegate.onSelect called with item: " + itemId);
        System.println("DEBUG-NAV: Reminder menu item selected: " + itemId);

        // Process selection based on item ID
        if (itemId instanceof String && itemId.find("reminder_") == 0) {
            // Extract the index from the ID (e.g., "reminder_2" -> 2)
            var indexStr = itemId.substring(9, itemId.length());
            var index = indexStr.toNumber();
            System.println("DEBUG: Selected reminder index: " + index);
            System.println("DEBUG-NAV: Preparing to show detail view for reminder: " + index);

            // Open the detail view for this reminder
            System.println("DEBUG: Creating ReminderDetailView for index: " + index);
            var detailView = new ReminderDetailView(index);
            var detailDelegate = new ReminderDetailDelegate(index);
            System.println("DEBUG-NAV: About to push detail view to stack");
            WatchUi.pushView(detailView, detailDelegate, WatchUi.SLIDE_LEFT);
            System.println("DEBUG: Pushed ReminderDetailView");
            System.println("DEBUG-NAV: Detail view pushed successfully");
            return;
        }

        // Return to the previous view with animation
        System.println("DEBUG-NAV: Item not a reminder, popping reminder menu view");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        System.println("DEBUG-NAV: Reminder menu view popped successfully");
    }

    function onBack() {
        System.println("DEBUG: ReminderMenuDelegate.onBack called");
        System.println("DEBUG-NAV: Back button pressed from reminder menu");
        // Go back to the main menu
        System.println("DEBUG-NAV: About to pop reminder menu view");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        System.println("DEBUG-NAV: Reminder menu view popped successfully");
        // No return value for Menu2InputDelegate onBack
    }
}
