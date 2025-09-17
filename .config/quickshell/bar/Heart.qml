pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

Item {
        id: root
        property real percentage: 0

        Row {
                spacing: -1
                Repeater {
                        model: 10
                        Image {
                                source: "assets/heart/container.png"
                                smooth: false
                        }
                }
        }
        Row {
                spacing: -1
                Repeater {
                        model: 10
                        Image {
                                required property int index

                                source: 
                                        100*root.percentage - (10 * index)  >= 10 ? 
                                        "assets/heart/full.png" :
                                        100*root.percentage - (10 * index)  >= 5 ?
                                        "assets/heart/half.png" :
                                        "assets/heart/container.png"
                                smooth: false
                        }
                }
        }

        Process {
                id: proc
                running: true
                command: ["cat", "/proc/meminfo"]

                stdout: StdioCollector {
                        onStreamFinished: () => {

                                const memTotal = this.text.match(/^MemTotal:\s*([0-9]+)/m)[1];
                                const memAvai  = this.text.match(/^MemAvailable:\s*([0-9]+)/m)[1];


                                root.percentage = memAvai / memTotal
                        }
                }
        }

        Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: proc.running = true
        }
}
