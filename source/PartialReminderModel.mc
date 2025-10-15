import Toybox.Time;

class PartialReminder {
    hidden var category;
    hidden var timeScope;
    hidden var letter1;
    hidden var letter2;

    function initialize() {
        category = null;
        timeScope = null;
        letter1 = null;
        letter2 = null;
    }

    function save() {
        var today = Time.today();
        var dateKey = formatDateKey(today);
        var reminder = {
            "category" => getCategoryString(category),
            "timeScope" => getTimeScopeString(timeScope),
            "letters" => letter1 + letter2,
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
        return (category != null) && (timeScope != null) && (letter1 != null) && (letter2 != null);
    }

    function categoryText() {
        return getCategoryString(category);
    }

    function timeScopeText() {
        return getTimeScopeString(timeScope);
    }

    function letterText() {
        return letter1 + " " + letter2;
    }

    function setCategory(categoryValue) {
        category = categoryValue;
    }

    function setTimeScope(timeScopeValue) {
        timeScope = timeScopeValue;
    }

    function setLetter1(letter1Value) {
        letter1 = letter1Value;
    }

    function setLetter2(letter2Value) {
        letter2 = letter2Value;
    }

    function hasCategory() {
        return category != null;
    }

    function hasTimeScope() {
        return timeScope != null;
    }

    function hasLetter1() {
        return letter1 != null;
    }

    function hasLetter2() {
        return letter2 != null;
    }
}
