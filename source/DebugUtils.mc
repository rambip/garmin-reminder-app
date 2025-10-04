import Toybox.System;

// Debug logging function that only exists in debug builds
(:debug)
function log(message) {
    System.println("DEBUG: " + message);
}

(:release)
function log(message) {
}
