import Toybox.Graphics;
import Toybox.WatchUi;

// A simple drawable class that creates a rectangular background
class Background extends WatchUi.Drawable {

    function initialize() {
        Drawable.initialize({});
    }

    function draw(dc) {
        // Draw the header background
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), 50);
    }
}
