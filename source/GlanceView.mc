import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Rez;

class MinimalView extends WatchUi.GlanceView {
    hidden var _countLabel;

    function initialize() {
        GlanceView.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MinimalLayout(dc));
    }

    function onShow() {
        // Get a reference to the count label
        _countLabel = View.findDrawableById("reminderCount") as WatchUi.Text;
    }

    function onUpdate(dc) {
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

        // Update the reminder count text if label exists
        if (_countLabel != null) {
            _countLabel.setText(Lang.format("Reminders: $1$", [reminderCount]));
        }

        // Let the layout handle the rendering
        View.onUpdate(dc);
    }

    function onHide() {
        _countLabel = null;
    }
}
