import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
// Main module contains the application foundation

// Dictionary to store reminders with dates as keys
// Each date key maps to an array of reminder objects
var remindersData = {};

// Initialize with default reminders (Sept 30th)
function initializeDefaultData() {
    // Create date (Sept 30th, 2023)
    var date = Time.Gregorian.moment({
        :year => 2023,
        :month => 9,  // September (1-12)
        :day => 30    // 30th
    });

    // Convert to seconds since epoch for dictionary key
    var dateKey = date.value().toString();

    // Add default reminders for the date with more details
    remindersData.put(dateKey, [
        {:text => "Default reminder for Sept 30th", :priority => "high"},
        {:text => "Task to complete", :priority => "medium"},
        {:text => "Third reminder item", :priority => "low"}
    ]);

    // We only handle reminders for a single date in this version
    // Future versions could support multiple dates and notifications
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

        // Get date for showing reminders
        var date = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var dateKey = date.value().toString();
        var reminder = remindersData.get(dateKey);

        // Count reminders
        var reminderCount = reminder != null ? reminder.size() : 0;

        // Draw the reminder count
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
