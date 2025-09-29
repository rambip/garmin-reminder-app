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
        // Set background color
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        // Draw header with larger font
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_WHITE);
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/4,
            Graphics.FONT_MEDIUM,
            "COMING SOON",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Draw feature message
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/2,
            Graphics.FONT_SMALL,
            "Add Reminder feature",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Draw hint message
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
        // Get reminders for the specified date
        var date = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var dateKey = date.value().toString();
        var reminders = remindersData.get(dateKey);

        // No header - we start directly with the reminders

        // Add today's reminders to the menu
        if (reminders != null && reminders.size() > 0) {
            for (var i = 0; i < reminders.size(); i++) {
                // Enhanced display with index number as sublabel and left alignment
                // Get priority if available, otherwise use default
                var priorityText = reminders[i].hasKey(:priority) ? reminders[i][:priority] : "normal";

                addItem(new WatchUi.MenuItem(
                    reminders[i][:text],
                    Lang.format("#$1$ ($2$)", [(i + 1).toString(), priorityText]),
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
    }
}
