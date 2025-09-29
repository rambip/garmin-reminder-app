import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;

// The main view for the internal application
class ReminderView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        // No layout needed for this simple widget
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        // Display reminders in the main app view
        var today = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var todayKey = today.value().toString();
        var reminders = remindersData.get(todayKey);

        var tomorrow = Time.Gregorian.moment({:year => 2023, :month => 10, :day => 1});
        var tomorrowKey = tomorrow.value().toString();
        var tomorrowReminders = remindersData.get(tomorrowKey);

        dc.drawText(
            dc.getWidth()/2,
            0.2*dc.getHeight(),
            Graphics.FONT_TINY,
            "Today's Reminders:",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Display current reminder with index
        if (reminders != null && reminders.size() > 0) {
            // Make sure the current index is valid
            if (currentReminderIndex >= reminders.size()) {
                currentReminderIndex = 0;
            }

            // Show current reminder
            dc.drawText(
                dc.getWidth()/2,
                0.35*dc.getHeight(),
                Graphics.FONT_TINY,
                reminders[currentReminderIndex][:text],
                Graphics.TEXT_JUSTIFY_CENTER
            );

            // Show pagination indicator
            dc.drawText(
                dc.getWidth()/2,
                0.5*dc.getHeight(),
                Graphics.FONT_TINY,
                Lang.format("$1$ of $2$", [currentReminderIndex + 1, reminders.size()]),
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else {
            dc.drawText(
                dc.getWidth()/2,
                0.4*dc.getHeight(),
                Graphics.FONT_TINY,
                "No reminders for today",
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }

        // Tomorrow header
        dc.drawText(
            dc.getWidth()/2,
            0.65*dc.getHeight(),
            Graphics.FONT_TINY,
            "Tomorrow:",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Display count of tomorrow's reminders
        var tomorrowCount = tomorrowReminders != null ? tomorrowReminders.size() : 0;
        dc.drawText(
            dc.getWidth()/2,
            0.75*dc.getHeight(),
            Graphics.FONT_TINY,
            Lang.format("$1$ reminders", [tomorrowCount]),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}

// Event handler for the main app view
class ReminderDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        // Handle "enter" button press
        System.println("Enter pressed!");

        // Cycle to the next reminder
        var today = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var todayKey = today.value().toString();
        var reminders = remindersData.get(todayKey);

        if (reminders != null && reminders.size() > 0) {
            // Move to next reminder
            currentReminderIndex = (currentReminderIndex + 1) % reminders.size();
        }

        WatchUi.requestUpdate();  // Refresh the view
        return true;  // Indicate event was handled
    }

    function onNextPage() {
        // Handle swipe up or next button - move to next reminder
        var today = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var todayKey = today.value().toString();
        var reminders = remindersData.get(todayKey);

        if (reminders != null && reminders.size() > 0) {
            // Move to next reminder
            currentReminderIndex = (currentReminderIndex + 1) % reminders.size();
            WatchUi.requestUpdate();
        }
        return true;
    }

    function onPreviousPage() {
        // Handle swipe down or back button - move to previous reminder
        var today = Time.Gregorian.moment({:year => 2023, :month => 9, :day => 30});
        var todayKey = today.value().toString();
        var reminders = remindersData.get(todayKey);

        if (reminders != null && reminders.size() > 0) {
            // Move to previous reminder
            currentReminderIndex = (currentReminderIndex - 1 + reminders.size()) % reminders.size();
            WatchUi.requestUpdate();
        }
        return true;
    }

    function onBack() {
        // Handle back button
        return false;  // Let system handle (usually exits widget)
    }
}
