import Quickshell
import QtQuick

import "bar" as Bar
import "notifications" as Notifs
import "launcher" as Launcher
import "pause" as Pause
import "settings" as Settings

ShellRoot {
        Bg {}

        Bar.Bar { }

        Notifs.Overlay { }

        Component.onCompleted: () => {
                Launcher.Controller.init();
                Pause.Controller.init();
                Settings.Controller.init();
        }
}
