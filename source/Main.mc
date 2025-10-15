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
        :domestic => Rez.Strings.CategoryDomestic,
        :administrative => Rez.Strings.CategoryAdministrative,
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
        :week => Rez.Strings.TimeWeek,
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

// Delegate for handling the main menu interactions
class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
        log("MainMenuDelegate initialized");
    }

    function onSelect(item) {
        var itemId = item.getId();
        log("MainMenuDelegate.onSelect called with item: " + itemId);

        if (itemId == :add_reminder) {
            // Start the add reminder process with the category selection menu
            var choiceDelegate = new ChoiceMenuDelegate();
            var firstMenu = choiceDelegate.initialMenu();
            WatchUi.pushView(firstMenu, choiceDelegate, WatchUi.SLIDE_UP);

        } else if (itemId == :see_reminders) {
            // Show the reminders menu
            log("Creating ReminderMenuDelegate");
            var menuDelegate = new ReminderMenuDelegate();
            log("About to push reminder menu view");
            // For dynamic content, we create and populate the menu programmatically
            // Create display format with full category name and first letter
            var menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.RemindersMenuTitle)});

            // Get all reminders
            var allReminders = getReminders();
            var today = Time.today();
            var todayKey = formatDateKey(today);
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
                    // Get reminder data - these are already display strings from storage
                    var category = todayReminders[i]["category"];
                    var timeScope = todayReminders[i]["timeScope"];
                    var firstLetter = todayReminders[i]["letters"];

                    // Create display format with full category name and first letter
                    menu.addItem(new WatchUi.MenuItem(
                        Lang.format("$1$ [$2$]", [category, firstLetter]),
                        timeScope,
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
            log("Reminder menu view pushed");
        }
    }

    function onBack() {
        log("MainMenuDelegate.onBack called - exiting app");
        // Exit the app
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        System.exit();
    }
}
