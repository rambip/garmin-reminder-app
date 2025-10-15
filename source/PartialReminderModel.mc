import Toybox.Time;

class PartialReminder {
    var category;
    var timeScope;
    var letter;

    function initialize() {
        category = null;
        timeScope = null;
        letter = null;
    }

    function save() {
        var today = Time.today();
        var dateKey = formatDateKey(today);
        var reminder = {
            "category" => getCategoryString(category),
            "timeScope" => getTimeScopeString(timeScope),
            "firstLetter" => letter,
            "date" => dateKey,
        };
        // Get all existing reminders
        var reminders = getReminders();

        // Add the new reminder
        reminders.add(reminder);

        // Save the updated list of all reminders
        return saveReminders(reminders);
    }
    function isComplete() {
        return (category != null) && (timeScope != null) && (letter != null);
    }

    function categoryText() {
        return getCategoryString(category);
    }

    function timeScopeText() {
        return getTimeScopeString(timeScope);
    }

    function letterText() {
        return letter;
    }
}
