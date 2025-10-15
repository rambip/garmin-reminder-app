import Toybox.WatchUi;
import Toybox.Graphics;
import Rez;
using Toybox.Lang;

class ReminderAddedView extends WatchUi.View {
    hidden var _categoryLabel;
    hidden var _timeScopeLabel;
    hidden var _partialReminder;

    function initialize(partialReminder) {
        View.initialize();
        _partialReminder = partialReminder;
    }

    function onLayout(dc) {
        log("ReminderAddedView.onLayout called");
        setLayout(Rez.Layouts.ReminderAddedLayout(dc));
    }

    // Load strings into memory
    function onShow() {
        log("ReminderAddedView.onShow called");
        // No string resources need to be loaded here, but we maintain the lifecycle pattern
    }

    function onUpdate(dc) {
        log("ReminderAddedView.onUpdate called");
        // Get references to the labels we need to update
        _categoryLabel = View.findDrawableById("category") as WatchUi.Text;
        _timeScopeLabel = View.findDrawableById("timeScope") as WatchUi.Text;

        // Set the dynamic text content (_category and _timeScope are already strings)
        if (_categoryLabel != null) {
            _categoryLabel.setText(_partialReminder.categoryText() + " [" + _partialReminder.letterText() + "]");
        }
        if (_timeScopeLabel != null) {
            _timeScopeLabel.setText(_partialReminder.timeScopeText());
        }

        // Let the layout handle the rendering
        View.onUpdate(dc);
    }

    function onHide() {
        log("ReminderAddedView.onHide called");
        // Free resources
        _categoryLabel = null;
        _timeScopeLabel = null;
    }
}

class ReminderAddedDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
    function onStart() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
    function onSelect() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
