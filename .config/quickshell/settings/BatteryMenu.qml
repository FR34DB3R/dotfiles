pragma ComponentBehavior: Bound

import QtQuick
import "../components"
import ".."

Column {
        id: root
        
        visible: false
        spacing: 5

        property int maxBrightness: 0
        property int brightness: 0

        property var config: Config.json

        Row {
                spacing: 10

                McButton {
                        text: `Notfify on Low: ${root.config.battery.lowNotify ? "ON" : "OFF"}`
                        func: () => {
                                root.config.battery.lowNotify = !root.config.battery.lowNotify
                                Config.write()
                        }
                }

                McSlider {
                        text: "Low Battery"
                        initialValue: root.config.battery.low

                        onPercentageChanged: () => {
                                root.config.battery.low = percentage
                                Config.write()
                        }
                }
        }
}
