import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Item {
        id: root
        x: 300
        y: 15

        required property var notif

        implicitWidth: 160 * 2
        implicitHeight: background.height * 2

        function getText(text) {
                let length = 21;
                if (text.length > length) {
                        text = text.substring(0, length-3) + '...';
                }

                let index = text.indexOf('\n');
                if (index > -1) {
                        text = text.substring(0, index) + '...';
                }
                return text
        }

        Image {
                id: background
                source: "assets/advancement.png"
                scale: 2
                smooth: false
                 
                Image {
                        function getSource() {
                                if (root.notif.image != "") return root.notif.image
                                if (root.notif.appIcon != "") return Quickshell.iconPath(root.notif.appIcon)
                                return "assets/diamond.png"
                        }
                        source: getSource()
                        smooth: false
                        x: 8
                        y: 8
                        width: 16
                        height: 16
                }

                Column {
                        anchors.left: parent.left
                        padding: 5
                        leftPadding: 28
                        spacing: 2

                        Text {
                                
                                text: root.getText(root.notif.summary)
                                font.family: minecraft.font.family
                                font.pixelSize: 9
                                color: root.notif.urgency == NotificationUrgency.Critical ?
                                        "#FF55FF" :
                                        "#FFFF55"
                                smooth: false
                                lineHeight: 0
                        }

                        Text {
                                text: root.getText(root.notif.body)
                                font.family: minecraft.font.family
                                font.pixelSize: 9
                                color: "#FFFFFF"
                                smooth: false
                        }
                }
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }
}
