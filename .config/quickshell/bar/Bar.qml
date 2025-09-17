import Quickshell
import QtQuick

import ".."

PanelWindow {
        id: bar
        aboveWindows: Config.json.bar.aboveWindows
	anchors {
		bottom: true
		left: true
		right: true
        }

	implicitHeight: 80
        color: "transparent"

        Clock {
        }

        Hotbar {
        }

        Trays {
        }

}
