import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;
using Toybox.Lang;

// Menu delegate that creates and manages the main menu


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
