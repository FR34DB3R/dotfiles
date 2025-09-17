pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
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

                McSlider {
                        text: "Brightness"
                        initialValue: root.brightness

                        onPercentageChanged: () => {
                                root.brightness = percentage
                                setBrightness.running = true
                        }
                }

                McButton {
                        property var wallpapers: root.config.videos.wallpaper.sources
                        property var index: root.config.videos.wallpaper.index
                        text: `Wallpaper: ${wallpapers[index]}`
                        func: () => {
                                index++
                                if (index >= wallpapers.length) {
                                        index = 0
                                }
                                root.config.videos.wallpaper.index = index
                                Config.write()
                        }
                }
        }

        Row {
                spacing: 10
                McButton {
                        text: "SystemTray: " + (root.config.systemTray.visible ? "ON" : "OFF")
                        func: () => {
                                root.config.systemTray.visible = !root.config.systemTray.visible
                                Config.write()
                        }
                }

                McButton {
                        text: "Bar " + (root.config.bar.aboveWindows ? "Above Windows" : "Under Windows")
                        func: () => {
                                root.config.bar.aboveWindows = !root.config.bar.aboveWindows
                                Config.write()
                        }
                }
        }

        /* BRIGHTNESS PROCESSES */
        Process {
                id: getBrightnessMax
                running: true
                command: ["brightnessctl", "m"]

                stdout: StdioCollector {
                        onStreamFinished: {
                                root.maxBrightness = parseInt(this.text)
                                getBrightness.running = true
                        }
                }
        }

        Process {
                id: getBrightness
                running: false
                command: ["brightnessctl", "g"]

                stdout: StdioCollector {
                        onStreamFinished: {
                                root.brightness = parseInt(this.text) / root.maxBrightness * 100
                        }
                }
        }

        Process {
                id: setBrightness
                running: false
                command: ["brightnessctl", "s", `${root.brightness}%`]
        }
}
