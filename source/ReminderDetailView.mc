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
        System.println("DEBUG-LIFECYCLE: onLayout for reminder index: " + _reminderIndex);
        setLayout(Rez.Layouts.ReminderDetailLayout(dc));
    }

    // Load strings into memory
    function onShow() {
        System.println("DEBUG: ReminderDetailView onShow called");

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

            // Get display string for category (handles both symbols and strings)
            var categoryStr = getCategoryString(category);
            _categoryLabel.setText(Lang.format("$1$ [$2$]", [categoryStr, firstLetter]));
        }

        if (_timeScopeLabel != null && _reminder != null) {
            var timeScope = _reminder["timeScope"];

            // Get display string for timeScope (handles both symbols and strings)
            var timeScopeStr = getTimeScopeString(timeScope);
            _timeScopeLabel.setText(timeScopeStr);
        }
        System.println("DEBUG: ReminderDetailView onUpdate called");
        // Let the layout handle the rendering
        View.onUpdate(dc);
    }

    // Unload strings to save memory
    function onHide() {
        System.println("DEBUG: ReminderDetailView onHide called");
        _title = null;
        _instructionsLabel = null;
        _categoryLabel = null;
        _timeScopeLabel = null;
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
        System.println("DEBUG-NAV: Back button pressed, popping detail view");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        System.println("DEBUG-NAV: After popView from back button");
        return true;
    }

    // Handle menu button presses (specific for some devices)
    function onMenu() {
        System.println("DEBUG: onMenu called - trying to delete");
        System.println("DEBUG-EVENT: Menu button pressed, calling deleteReminder");
        deleteReminder(_reminderIndex);
        System.println("DEBUG-EVENT: Returned from deleteReminder after menu button");
        return true;
    }

    // Handle select button (center/enter button on many devices)
    function onSelect() {
        System.println("DEBUG: onSelect called - trying to delete");
        System.println("DEBUG-EVENT: Select button pressed, calling deleteReminder");
        deleteReminder(_reminderIndex);
        System.println("DEBUG-EVENT: Returned from deleteReminder after select button");
        return true;
    }

    // Handle native START button presses
    function onStart() {
        System.println("DEBUG: onStart called - trying to delete");
        System.println("DEBUG-EVENT: Start button pressed, calling deleteReminder");
        deleteReminder(_reminderIndex);
        System.println("DEBUG-EVENT: Returned from deleteReminder after start button");
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

    // NAVIGATION DEBUG - Before popping views
    System.println("DEBUG-NAV: Current view stack before pop operations");
    System.println("DEBUG-NAV: About to pop detail view");
    WatchUi.popView(WatchUi.SLIDE_RIGHT); // Pop detail view
    System.println("DEBUG-NAV: Detail view popped successfully");
    System.println("DEBUG-NAV: About to pop reminder menu view");
    WatchUi.popView(WatchUi.SLIDE_RIGHT); // Pop reminder menu view
    System.println("DEBUG-NAV: Both views popped, should be at main menu now");
    System.println("=== END DELETION PROCESS ===");
}
