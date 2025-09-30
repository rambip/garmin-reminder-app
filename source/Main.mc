import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;
import Toybox.Lang;
// Main module contains the application foundation

// Constants
const STORAGE_KEY_REMINDERS = "reminders";

// Get all reminders
function getReminders() {
    var reminders = Storage.getValue(STORAGE_KEY_REMINDERS);
    if (reminders == null) {
        return [];
    }
    return reminders;
}

// Save all reminders
function saveReminders(reminders) {
    try {
        Storage.setValue(STORAGE_KEY_REMINDERS, reminders);
        return true;
    } catch (ex) {
        System.println("Error saving reminders: " + ex);
        return false;
    }
}

// Initialize reminder data from storage
function initializeDefaultData() {
    // Nothing to initialize - data will be loaded from storage as needed
}

// Format a date into a simple string (YYYYMMDD)
function formatDateKey(moment) {
    var info = Gregorian.info(moment, Time.FORMAT_SHORT);
    // Format as YYYYMMDD for simple string comparison
    return Lang.format("$1$$2$$3$", [
        info.year,
        (info.month < 10) ? "0" + info.month : info.month.toString(),
        (info.day < 10) ? "0" + info.day : info.day.toString()
    ]);
}

// Get today's date as a string key
function getTodayKey() {
    var today = Time.today();
    return formatDateKey(today);
}

// Add a new reminder
function addReminder(category, timeScope, firstLetter) {
    var dateKey = getTodayKey();

    // Create a reminder object
    var reminder = {
        "date" => dateKey,
        "category" => category,
        "timeScope" => timeScope,
        "firstLetter" => firstLetter
    };

    // Get all existing reminders
    var reminders = getReminders();

    // Add the new reminder
    reminders.add(reminder);

    // Save the updated list of all reminders
    return saveReminders(reminders);
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

        // Get all reminders
        var allReminders = getReminders();
        var todayKey = getTodayKey();

        // Count today's reminders
        var reminderCount = 0;
        for (var i = 0; i < allReminders.size(); i++) {
            var reminderDate = allReminders[i]["date"];
            if (reminderDate.toString().equals(todayKey)) {
                reminderCount++;
            }
        }

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
