import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
// Main module contains the application foundation

// Dictionary to store reminders with dates as keys
// Each date key maps to an array of reminder objects
var remindersData = {};

// Initialize empty reminder data
function initializeDefaultData() {
    // No default data - users will add their own reminders
}

// Get today's date as a Moment and as a string key
function getTodayInfo() {
    // Get the current date (today)
    var today = Time.today();
    var todayInfo = {:moment => today, :key => today.value().toString()};
    return todayInfo;
}

// Add a new reminder
function addReminder(category, timeScope, firstLetter) {
    var todayInfo = getTodayInfo();
    var dateKey = todayInfo[:key];

    // Create the reminder object
    var reminder = {:category => category, :timeScope => timeScope, :firstLetter => firstLetter};

    // Check if we already have reminders for today
    var existingReminders = remindersData.get(dateKey);

    if (existingReminders != null) {
        // Add to existing array
        existingReminders.add(reminder);
    } else {
        // Create new array with this reminder
        remindersData.put(dateKey, [reminder]);
    }
}

class Main extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
        initializeDefaultData();
    }

    function getInitialView() {
        return [new MainMenu(), new MainMenuDelegate()];
    }

    function getGlanceView() {
        return [new MinimalView()];
    }
}

class MinimalView extends WatchUi.GlanceView {
    function initialize() {
        GlanceView.initialize();
    }
    function onUpdate(dc) {
        // Set color scheme and clear
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();

        // Draw app title
        dc.drawText(
            0,
            0,
            Graphics.FONT_MEDIUM,
            "Reminders",
            Graphics.TEXT_JUSTIFY_LEFT
        );

        // Get today's date for showing reminders
        var todayInfo = getTodayInfo();
        var dateKey = todayInfo[:key];
        var reminder = remindersData.get(dateKey);

        // Count reminders
        var reminderCount = reminder != null ? reminder.size() : 0;

        // Draw the reminder count (simple glance view)
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_TINY,
            Lang.format("Reminders: $1$", [reminderCount]),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}

// The app now uses a menu-based interface with MainMenu as the entry point
