pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell.Services.UPower
import ".."

Item {
        id: root
        property var prevState: null
        property bool notifiedLowBat: false
        property bool notifiedFullBat: false

        Row {
                spacing: -1
                Repeater {
                        model: 10
                        Image {
                                source: "assets/hunger/food_empty.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: false
                        }
                }
        }
        Row {
                id: hunger
                readonly property real percentage: UPower.displayDevice.percentage
                LayoutMirroring.enabled: true
                spacing: -1
        
                Repeater {
                        model: 10
                        Image {
                                required property int index
                                
                                source:
                                        100*hunger.percentage - (10 * index)  >= 10 ? 
                                        "assets/hunger/food_full.png" :
                                        100*hunger.percentage - (10 * index)  >= 5 ?
                                        "assets/hunger/food_half.png" :
                                        "assets/hunger/food_empty.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: false        
                        }
                }
        }

        property var iconPath: "/home/hooss/.config/quickshell/assets/redstone.png"
        property var notifTitle: "Battery"

        Process {
                id: sendLowBat
                command: ["notify-send", root.notifTitle, "Low Battery!", "--urgency", "critical", "-i", root.iconPath, "-a", "Battery"]
                running: false
        }

        Process {
                id: sendUnplug
                command: ["notify-send", root.notifTitle, "Stopped charging", "-i", root.iconPath, "-a", "Battery"]
                running: false
        }

        Process {
                id: sendCharging
                command: ["notify-send", root.notifTitle, "Charging...", "-i", root.iconPath, "-a", "Battery"]
                running: false
        }

        Process {
                id: sendFullyCharged
                command: ["notify-send", root.notifTitle, "Fully Charged!", "-i", root.iconPath, "-a", "Battery"]
                running: false
        }

        Timer {
                id: checkBat
                interval: 500; running: true; repeat: true

                onTriggered: () => {
                        let percentage = UPower.displayDevice.percentage;

                        if (Config.json.battery.lowNotify && percentage <= Config.json.battery.low / 100) {
                                if (!root.notifiedLowBat) {
                                        root.notifiedLowBat = true
                                        sendLowBat.running = true
                                }
                        } else {
                                root.notifiedLowBat = false
                        }

                        let state = UPower.displayDevice.state;
                        if (state == root.prevState) return;

                        if (state == UPowerDeviceState.Charging) {
                                sendCharging.running = true
                                if (percentage >= 1) {
                                        if (!root.notifiedFullBat) {
                                                root.notifiedFullBat = true
                                                sendFullyCharged.running = true
                                        }
                                } else {
                                        root.notifiedFullBat = false
                                }
                        }

                        else if (root.prevState == UPowerDeviceState.Charging && state == UPowerDeviceState.Discharging) {
                                sendUnplug.running = true
                        }

                        root.prevState = state;
                }
        }
}
