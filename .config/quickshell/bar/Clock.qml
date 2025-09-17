import QtQuick
import Quickshell

Item {
        id: root

        Rectangle {
                color: "#85000000"
                width: clockText.width+10
                height: clockText.height+10
                y: 50

                Text {
                        id: clockText
                        x: 5
                        y: 5
                        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd dddd hh:mm:ss AP")
                        color: "white"
                        font.family: minecraft.font.family
                        font.pixelSize: 20
                }
        }
        
        SystemClock {
                id: clock
                precision: SystemClock.Seconds
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }
}
