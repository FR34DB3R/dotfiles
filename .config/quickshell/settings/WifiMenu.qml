pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import "../components"

Column {
        id: root
        
        visible: false
        spacing: 5

        required property var stationName
        required property var wifi


        Row {
                spacing: 10

                McButton {
                        id: wifiBtn
                        text: "Wifi: " + (root.wifi.connectedNetwork)
                        func: () => {
                                sendCopyNotif.running = true
                                copyWifiName.running = true
                        }
                }

                McButton {
                        id: ipv4
                        text: "IPv4: " + (root.wifi.ipv4)
                        func: () => {
                                sendCopyNotif.running = true
                                copyIpv4Name.running = true
                        }
                }
        }

        Row {
                spacing: 10

                McButton {
                        text: "Disconnect"
                        func: () => {
                                disconnectWifi.running = true
                        }
                }

                McButton {
                        text: "Forget"
                        func: () => {
                        }
                }
        }

        Process {
                id: disconnectWifi
                running: false
                command: ["iwctl", "station", root.stationName, "disconnect"]
        }

        Process {
                id: copyWifiName
                running: false
                command: ["wl-copy", root.wifi.connectedNetwork]
        }

        Process {
                id: copyIpv4Name
                running: false
                command: ["wl-copy", root.wifi.ipv4]
        }

        Process {
                id: sendCopyNotif
                running: false
                command: ["notify-send", "Advancement Made!", "Copy."]
        }
}
