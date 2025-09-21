import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;

class Hello extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [new MinimalWidgetView()];
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
            "Merci pour \n ce cadeau\n Papa !",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            0.75*dc.getHeight(),
            Graphics.FONT_SMALL,
            "Antonin",
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
