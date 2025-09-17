pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import "../components"

MouseArea {
        id: root
        
        required property var notif
        signal dismissed

        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
                visible = false
                dismissed()
        }

        Rectangle {
                z: -1
                anchors.fill: parent
                color: "#55000000"
        }

        Item {
                x: parent.width / 2 - 234
                y: parent.height / 2 - 300

                Image {
                        x: 234/2
                        y: 300/2
                        scale: 2.0
                        source: "assets/popup.png"
                        smooth: false
                }

                Column {
                        x: 20
                        y: 20
                        spacing: 10
                        Text {
                                id: appName
                                text: root.notif.appName
                                color: "#FFFFFF"
                                font.family: minecraft.font.family
                                smooth: false
                        }

                        Text {
                                id: summary
                                text: root.notif.summary
                                color: "#FFFF55"
                                font.family: minecraft.font.family
                                font.pixelSize: 16
                                smooth: false
                        }

                        Text {
                                id: body
                                text: root.notif.body
                                width: 234*2 - 20*2
                                wrapMode: Text.WordWrap
                                color: "#FFFFFF"
                                font.family: minecraft.font.family
                                font.pixelSize: 16
                                smooth: false
                        }

                        Repeater {
                                model: root.notif.actions

                                McButton {
                                        required property var modelData

                                        text: modelData.text
                                        func: () => {
                                                root.visible = false
                                                modelData.invoke();
                                                root.dismissed()
                                        }
                                }
                        }

                        McButton {
                                text: "Copy!"
                                func: () => {
                                        copy.running = true;
                                }
                        }
                }
        }

        Process {
                id: copy
                running: false
                command: ["wl-copy", root.notif.body]
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }
}
