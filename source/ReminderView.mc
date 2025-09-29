import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;

// The main menu shown when first entering the app
class MainMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title => "Reminder App"});
        populateMenu();
    }

    // Populate the menu with main options
    function populateMenu() {
        // Add the two main menu options
        addItem(new WatchUi.MenuItem(
            "Add Reminder",
            "Create a new reminder",
            "add_reminder",
            null
        ));

        addItem(new WatchUi.MenuItem(
            "See Reminders",
            "View your reminders",
            "see_reminders",
            null
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
            // Placeholder for future implementation
            // Would show a form to add a new reminder
            // Show a placeholder message for now
            WatchUi.pushView(
                new NotImplementedView(),
                new PlaceholderDelegate(),
                WatchUi.SLIDE_UP
            );
        } else if (itemId.equals("see_reminders")) {
            // Show the reminders menu
            var menu = new ReminderMenu();
            var menuDelegate = new ReminderMenuDelegate();
            WatchUi.pushView(menu, menuDelegate, WatchUi.SLIDE_UP);
        }
    }

    function onBack() {
        // Exit the app
        // Return nothing (void) for Menu2InputDelegate
    }
}

// Simple view for not-yet-implemented features
class NotImplementedView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        // Nothing to do
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/2,
            Graphics.FONT_TINY,
            "Add Reminder feature\ncoming soon!",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}

// Placeholder delegate for not-yet-implemented features
class PlaceholderDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}

// Menu class for displaying reminders in a native Garmin menu
class ReminderMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title => "Reminders"});
        populateMenu();
    }

    // Populate the menu with reminder items
    function populateMenu() {
        // Get today's reminders
        var today = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var todayKey = today.value().toString();
        var reminders = remindersData.get(todayKey);

        // Add header for today's reminders
        addItem(new WatchUi.MenuItem(
            "TODAY'S REMINDERS",
            null,
            "todayHeader",
            null
        ));

        // Add today's reminders to the menu
        if (reminders != null && reminders.size() > 0) {
            for (var i = 0; i < reminders.size(); i++) {
                addItem(new WatchUi.MenuItem(
                    reminders[i][:text],
                    Lang.format("Item $1$", [i + 1]),
                    "reminder_today_" + i,
                    null
                ));
            }
        } else {
            addItem(new WatchUi.MenuItem(
                "No reminders for today",
                null,
                "no_reminders_today",
                null
            ));
        }

        // Add tomorrow's reminders header
        addItem(new WatchUi.MenuItem(
            "TOMORROW'S REMINDERS",
            null,
            "tomorrowHeader",
            null
        ));

        // Get tomorrow's reminders
        var tomorrow = Time.Gregorian.moment({:year => 2023, :month => 10, :day => 1});
        var tomorrowKey = tomorrow.value().toString();
        var tomorrowReminders = remindersData.get(tomorrowKey);

        // Add tomorrow's reminders to the menu
        if (tomorrowReminders != null && tomorrowReminders.size() > 0) {
            for (var i = 0; i < tomorrowReminders.size(); i++) {
                addItem(new WatchUi.MenuItem(
                    tomorrowReminders[i][:text],
                    Lang.format("Item $1$", [i + 1]),
                    "reminder_tomorrow_" + i,
                    null
                ));
            }
        } else {
            addItem(new WatchUi.MenuItem(
                "No reminders for tomorrow",
                null,
                "no_reminders_tomorrow",
                null
            ));
        }
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

        // Return to the previous view
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        // Go back to the main menu
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
