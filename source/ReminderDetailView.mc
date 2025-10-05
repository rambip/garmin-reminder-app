import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.System;
import Toybox.Timer;
import Rez;
using Toybox.Lang;

// View to display the details of a selected reminder
class ReminderDetailView extends WatchUi.View {
    hidden var _reminderIndex;
    hidden var _reminder;
    hidden var _categoryLabel;
    hidden var _timeScopeLabel;
    hidden var _title;
    hidden var _instructionsLabel;
    // DEBUG counter to track lifecycle
    hidden var _updateCounter = 0;

    function initialize(reminderIndex) {
        View.initialize();
        _reminderIndex = reminderIndex;
        log("ReminderDetailView initialized with index: " + reminderIndex);

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
        log("ReminderDetailView onLayout called");
        log("onLayout for reminder index: " + _reminderIndex);
        setLayout(Rez.Layouts.ReminderDetailLayout(dc));
    }

    // Load strings into memory
    function onShow() {
        log("ReminderDetailView onShow called");

        // Get string resources if needed
        _title = WatchUi.loadResource(Rez.Strings.DetailViewTitle);
        _instructionsLabel = "START: Delete • BACK: Return";
    }

    function onUpdate(dc) {
        // Get references to the labels we need to update
        _categoryLabel = View.findDrawableById("categoryLabel") as WatchUi.Text;
        _timeScopeLabel = View.findDrawableById("timeScopeLabel") as WatchUi.Text;

        // Set the dynamic text content if we have valid labels
        if (_categoryLabel != null && _reminder != null) {
            var category = _reminder["category"];
            var firstLetter = _reminder["firstLetter"];

            // category is already a display string from storage
            _categoryLabel.setText(Lang.format("$1$ [$2$]", [category, firstLetter]));
        }

        if (_timeScopeLabel != null && _reminder != null) {
            var timeScope = _reminder["timeScope"];

            // timeScope is already a display string from storage
            _timeScopeLabel.setText(timeScope);
        }
        log("ReminderDetailView onUpdate called");
        // Let the layout handle the rendering
        View.onUpdate(dc);
    }

    // Unload strings to save memory
    function onHide() {
        log("ReminderDetailView onHide called");
        _title = null;
        _instructionsLabel = null;
        _categoryLabel = null;
        _timeScopeLabel = null;
    }
}

// Delegate to handle user interactions with the reminder detail view
class ReminderDetailDelegate extends WatchUi.BehaviorDelegate {
    hidden var _reminderIndex;
    hidden var _deletionCallback;

    function initialize(reminderIndex, deletionCallback) {
        BehaviorDelegate.initialize();
        _reminderIndex = reminderIndex;
        _deletionCallback = deletionCallback;
        log("ReminderDetailDelegate initialized with index: " + reminderIndex);
    }

    function onBack() {
        log("ReminderDetailDelegate.onBack called");
        log("Back button pressed, popping detail view");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        log("After popView from back button");
        return true;
    }

    // Handle menu button presses (specific for some devices)
    function onMenu() {
        log("onMenu called - trying to delete");
        log("Menu button pressed, calling deleteReminder");
        deleteReminder(_reminderIndex, _deletionCallback);
        log("Returned from deleteReminder after menu button");
        return true;
    }

    // Handle select button (center/enter button on many devices)
    function onSelect() {
        log("onSelect called - trying to delete");
        log("Select button pressed, calling deleteReminder");
        deleteReminder(_reminderIndex, _deletionCallback);
        log("Returned from deleteReminder after select button");
        return true;
    }

    // Handle native START button presses
    function onStart() {
        log("onStart called - trying to delete");
        log("Start button pressed, calling deleteReminder");
        deleteReminder(_reminderIndex, _deletionCallback);
        log("Returned from deleteReminder after start button");
        return true;
    }

    // Handle general key events - specifically the START button for deletion
    function onKey(keyEvent) {
        log("onKey event detected!");
        var key = keyEvent.getKey();
        var eventType = keyEvent.getType();
        log("Key pressed: " + key + ", Type: " + eventType);
        log("Is ENTER key? " + (key == WatchUi.KEY_ENTER));
        log("Is START key? " + (key == WatchUi.KEY_START));

        // Check for START key press - respond to all press types for debugging
        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            log("START/ENTER button pressed - deleting reminder index: " + _reminderIndex);
            // Delete the reminder directly without confirmation
            deleteReminder(_reminderIndex, _deletionCallback);
            return true;
        } else {
            log("Unhandled key: " + key);
        }

        return false;
    }
}

// Helper function to delete a reminder
function deleteReminder(reminderIndex, deletionCallback) {
    log("=== BEGIN DELETION PROCESS ===");
    log("Attempting to delete reminder at index: " + reminderIndex);

    // Get all reminders
    var allReminders = getReminders();
    var todayKey = getTodayKey();
    var todayRemindersIndices = [];

    // Find today's reminders and their indices in the main array
    log("Total reminders: " + allReminders.size());
    log("Looking for today's key: " + todayKey);

    for (var i = 0; i < allReminders.size(); i++) {
        log("Checking reminder " + i + " with date " + allReminders[i]["date"]);
        if (allReminders[i]["date"].toString().equals(todayKey)) {
            todayRemindersIndices.add(i);
            log("Found today's reminder at index " + i);
        }
    }
    log("Today's reminders count: " + todayRemindersIndices.size());

    // Remove the selected reminder
    log("Trying to delete reminder at index " + reminderIndex);
    if (reminderIndex < todayRemindersIndices.size()) {
        var indexToRemove = todayRemindersIndices[reminderIndex];
        log("Found corresponding global index " + indexToRemove + " to remove");

        // Create a new array without the reminder we want to remove
        var newReminders = [];
        for (var i = 0; i < allReminders.size(); i++) {
            if (i != indexToRemove) {
                newReminders.add(allReminders[i]);
            }
        }

        log("Old reminders count: " + allReminders.size() + ", New reminders count: " + newReminders.size());

        // Save the updated reminders list
        var saveSuccess = saveReminders(newReminders);
        log("Save successful? " + saveSuccess);
    } else {
        log("ERROR: Invalid reminder index - out of range");
    }

    // Pop just the detail view and notify parent via callback
    log("About to pop detail view");
    WatchUi.popView(WatchUi.SLIDE_RIGHT); // Pop detail view
    log("Detail view popped successfully");

    // Notify parent that deletion occurred
    if (deletionCallback != null) {
        log("Notifying parent via deletion callback");
        deletionCallback.invoke();
    }
    log("=== END DELETION PROCESS ===");
}
