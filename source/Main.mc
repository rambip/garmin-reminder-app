import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;
import Toybox.Lang;
import Rez;
// Main module contains the application foundation

// Constants
const STORAGE_KEY_REMINDERS = "reminders";

// Helper function to get a category string from a category symbol
function getCategoryString(categorySymbol) {
    var categoryStrings = {
        :work => Rez.Strings.CategoryWork,
        :friends => Rez.Strings.CategoryFriends,
        :family => Rez.Strings.CategoryFamily,
        :message => Rez.Strings.CategoryMessage,
        :administrative => Rez.Strings.CategoryAdministrative,
        :domestic => Rez.Strings.CategoryDomestic
    };

    if (categoryStrings.hasKey(categorySymbol)) {
        return WatchUi.loadResource(categoryStrings[categorySymbol]);
    }
    System.error("unexpected symbol");
}

// Helper function to get a time scope string from a time scope symbol
// Call this immediately in onSelect to convert symbols to strings at the boundary
function getTimeScopeString(timeScopeSymbol) {
    var timeScopeStrings = {
        :urgent => Rez.Strings.TimeUrgent,
        :today => Rez.Strings.TimeToday,
        :later => Rez.Strings.TimeLater
    };

    if (timeScopeStrings.hasKey(timeScopeSymbol)) {
        return WatchUi.loadResource(timeScopeStrings[timeScopeSymbol]);
    }
    // Fallback: convert symbol to string by removing the colon
    System.error("unexpected symbol");
}

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
        log("Error saving reminders: " + ex);
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
// category and timeScope should already be display strings (converted in onSelect)
function addReminder(category, timeScope, firstLetter) {
    var dateKey = getTodayKey();

    // Create a reminder object with display string values
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
        return [new Rez.Menus.MainMenu(), new MainMenuDelegate()];
    }

    function getGlanceView() {
        return [new MinimalView()];
    }
}
