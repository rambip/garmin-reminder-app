import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;

var counter = 0;

class Hello extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [new MinimalWidgetView(), new MyWidgetDelegate()];
    }

    function getGlanceView() {
        return [new MinimalGlanceView()];
    }
}

class MinimalGlanceView extends WatchUi.GlanceView {
    function initialize() {
        GlanceView.initialize();
    }
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        //dc.fillCircle(
        //    dc.getWidth() / 2,
        //    dc.getHeight() / 2,
        //    dc.getHeight() / 2
        //);
        dc.drawText(
            0,
            0,
            Graphics.FONT_MEDIUM,
            "Test App",
            Graphics.TEXT_JUSTIFY_LEFT
        );
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_SMALL,
            Lang.format("c = $1$", [counter]),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}

class MinimalWidgetView extends WatchUi.View {
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
        dc.drawText(
            dc.getWidth()/2,
            0.4*dc.getHeight(),
            Graphics.FONT_MEDIUM,
            Lang.format("Inside the app\nc=$1$", [counter]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}

class MyWidgetDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        // Handle "enter" button press
        System.println("Enter pressed!");
        counter += 1;
        WatchUi.requestUpdate();  // Refresh the view
        return true;  // Indicate event was handled
    }

    function onNextPage() {
        // Handle swipe up or next button
        return true;
    }

    function onPreviousPage() {
        // Handle swipe down or back button
        return true;
    }

    function onBack() {
        // Handle back button
        return false;  // Let system handle (usually exits widget)
    }
}
