import QtQuick
import Quickshell.Io

Item {
        id: root
        
        property int prevTotal: 0
        property int prevIdle: 0
        property real cpuUsage: 0

        Process {
                id: cpuProc
                command: ["sh", "-c", "grep '^cpu ' /proc/stat"]
                running: true

                stdout: StdioCollector {
                        onStreamFinished: {
                                var out = this.text.trim()
                                if (!out) return

                                var parts = out.split(/\s+/).filter(function(p){ return p.length > 0 })
                                var nums = parts.slice(1).map(function(p){ return parseInt(p, 10) })

                                var idle = nums[3]
                                var total = nums.reduce(function(a,b){ return a + b }, 0)

                                var diffIdle = idle - root.prevIdle
                                var diffTotal = total - root.prevTotal

                                if (root.prevTotal !== 0 && diffTotal > 0) {
                                        root.cpuUsage = (1 - diffIdle / diffTotal)
                                }

                                root.prevIdle = idle
                                root.prevTotal = total
                        }
                }
        }

        Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                        cpuProc.running = true
                }
        }

        Image {
                source: "assets/experience_bar_background.png"
        }

        Item {
                width: 182 * root.cpuUsage
                height: 5
                clip: true
                Image {
                        source: "assets/experience_bar_progress.png"
                        smooth: false
                }
        }

}
