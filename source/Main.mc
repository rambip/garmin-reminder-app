import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
// Main module contains the application foundation

// Dictionary to store reminders with dates as keys
// Each date key maps to an array of reminder objects
var remindersData = {};

// Initialize with a default reminder for today (Sept 30th)
function initializeDefaultData() {
    // Create today's date (Sept 30th, 2023)
    var today = Time.Gregorian.moment({
        :year => 2023,
        :month => 9,  // September (1-12)
        :day => 30    // 30th
    });

    // Convert to seconds since epoch for dictionary key
    var todayKey = today.value().toString();

    // Add default reminders for today
    remindersData.put(todayKey, [
        {:text => "Default reminder for Sept 30th"},
        {:text => "Another reminder for today"},
        {:text => "Third reminder for today"}
    ]);

    // Add another reminder for tomorrow
    var tomorrow = Time.Gregorian.moment({
        :year => 2023,
        :month => 10,  // October
        :day => 1      // 1st
    });
    var tomorrowKey = tomorrow.value().toString();
    remindersData.put(tomorrowKey, [
        {:text => "Follow-up reminder for Oct 1st"},
        {:text => "Second task for tomorrow"}
    ]);
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
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.drawText(
            0,
            0,
            Graphics.FONT_MEDIUM,
            "Test App",
            Graphics.TEXT_JUSTIFY_LEFT
        );
        // Get today's date for showing current reminders
        var today = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var todayKey = today.value().toString();
        var reminder = remindersData.get(todayKey);

        // Count reminders for today
        var reminderCount = reminder != null ? reminder.size() : 0;

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
