import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;
import Rez;

// View to display the details of a selected reminder
class ReminderDetailView extends WatchUi.View {
    hidden var _reminderIndex;
    hidden var _reminder;
    hidden var _categoryLabel;
    hidden var _timeScopeLabel;

    function initialize(reminderIndex) {
        View.initialize();
        _reminderIndex = reminderIndex;
        System.println("DEBUG: ReminderDetailView initialized with index: " + reminderIndex);

        // Get the reminder object
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

        _reminder = todayReminders[reminderIndex];
    }

    function onLayout(dc) {
        System.println("DEBUG: ReminderDetailView onLayout called");
        setLayout(Rez.Layouts.ReminderDetailLayout(dc));

        // Get references to the labels we need to update
        _categoryLabel = findDrawableById("categoryLabel") as WatchUi.Text;
        _timeScopeLabel = findDrawableById("timeScopeLabel") as WatchUi.Text;

        // Set the dynamic text content
        _categoryLabel.setText(Lang.format("$1$ [$2$]", [_reminder["category"], _reminder["firstLetter"]]));
        _timeScopeLabel.setText(_reminder["timeScope"]);
    }

    function onUpdate(dc) {
        System.println("DEBUG: ReminderDetailView onUpdate called");
        // Let the layout handle the rendering
        View.onUpdate(dc);
    }
}

// Delegate to handle user interactions with the reminder detail view
class ReminderDetailDelegate extends WatchUi.BehaviorDelegate {
    hidden var _reminderIndex;

    function initialize(reminderIndex) {
        BehaviorDelegate.initialize();
        _reminderIndex = reminderIndex;
        System.println("DEBUG: ReminderDetailDelegate initialized with index: " + reminderIndex);
    }

    function onBack() {
        System.println("DEBUG: ReminderDetailDelegate.onBack called");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    // Handle menu button presses (specific for some devices)
    function onMenu() {
        System.println("DEBUG: onMenu called - trying to delete");
        deleteReminder(_reminderIndex);
        return true;
    }

    // Handle select button (center/enter button on many devices)
    function onSelect() {
        System.println("DEBUG: onSelect called - trying to delete");
        deleteReminder(_reminderIndex);
        return true;
    }

    // Handle native START button presses
    function onStart() {
        System.println("DEBUG: onStart called - trying to delete");
        deleteReminder(_reminderIndex);
        return true;
    }

    // Handle general key events - specifically the START button for deletion
    function onKey(keyEvent) {
        System.println("DEBUG: onKey event detected!");
        var key = keyEvent.getKey();
        var eventType = keyEvent.getType();
        System.println("DEBUG: Key pressed: " + key + ", Type: " + eventType);
        System.println("DEBUG: Is ENTER key? " + (key == WatchUi.KEY_ENTER));
        System.println("DEBUG: Is START key? " + (key == WatchUi.KEY_START));

        // Check for START key press - respond to all press types for debugging
        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            System.println("DEBUG: START/ENTER button pressed - deleting reminder index: " + _reminderIndex);
            // Delete the reminder directly without confirmation
            deleteReminder(_reminderIndex);
            return true;
        } else {
            System.println("DEBUG: Unhandled key: " + key);
        }

        return false;
    }
}

// Helper function to delete a reminder
function deleteReminder(reminderIndex) {
    try {
        System.println("=== BEGIN DELETION PROCESS ===");
        System.println("DEBUG: Attempting to delete reminder at index: " + reminderIndex);

        // Get all reminders
        var allReminders = getReminders();
        var todayKey = getTodayKey();
        var todayRemindersIndices = [];

        // Find today's reminders and their indices in the main array
        System.println("DEBUG: Total reminders: " + allReminders.size());
        System.println("DEBUG: Looking for today's key: " + todayKey);

    for (var i = 0; i < allReminders.size(); i++) {
        System.println("DEBUG: Checking reminder " + i + " with date " + allReminders[i]["date"]);
        if (allReminders[i]["date"].toString().equals(todayKey)) {
            todayRemindersIndices.add(i);
            System.println("DEBUG: Found today's reminder at index " + i);
        }
    }
    System.println("DEBUG: Today's reminders count: " + todayRemindersIndices.size());

    // Remove the selected reminder
    System.println("DEBUG: Trying to delete reminder at index " + reminderIndex);
    if (reminderIndex < todayRemindersIndices.size()) {
        var indexToRemove = todayRemindersIndices[reminderIndex];
        System.println("DEBUG: Found corresponding global index " + indexToRemove + " to remove");

        // Create a new array without the reminder we want to remove
        var newReminders = [];
        for (var i = 0; i < allReminders.size(); i++) {
            if (i != indexToRemove) {
                newReminders.add(allReminders[i]);
            }
        }

        System.println("DEBUG: Old reminders count: " + allReminders.size() + ", New reminders count: " + newReminders.size());

        // Save the updated reminders list
        var saveSuccess = saveReminders(newReminders);
        System.println("DEBUG: Save successful? " + saveSuccess);
    } else {
        System.println("ERROR: Invalid reminder index - out of range");
    }

    // Clear the view stack and return to main menu
    System.println("DEBUG: Clearing navigation stack");

    // Instead of manipulating the view stack directly, use switchToView
    // This will replace the current view with a new one
    System.println("DEBUG: Switching directly to a new reminder menu");
    var menuDelegate = new ReminderMenuDelegate();
    WatchUi.switchToView(menuDelegate.getMenu(), menuDelegate, WatchUi.SLIDE_RIGHT);
    System.println("=== END DELETION PROCESS ===");
    } catch (ex) {
        System.println("ERROR IN DELETE PROCESS: " + ex.getErrorMessage());
    }
}
