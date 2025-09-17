import QtQuick
import Quickshell.Io
import Quickshell.Services.Notifications

Item {
        id: root

        signal dismissed

        required property var notif
        required property var popup

        property var lifetime: 5000

        enum AnimState {
                Starting,
                Positioned,
                Dismissing
        }
        property var state: Notif.Starting
        property bool playedOut: false

        property int velocityX: 0

        implicitWidth: display.width
        implicitHeight: display.height
        anchors.fill: display

        property int targetX: -40
        property int dismissX: 300
        property bool popedUp: false

        FrameAnimation {
                running: true
                onTriggered: () => {
                        if (root.notif == null) root.dismissed();

                        if (root.state == Notif.Starting) {
                                if (display.x > root.targetX) {
                                        display.x -= root.velocityX * frameTime
                                        root.velocityX += 20
                                }
                                else {
                                        display.x = root.targetX
                                        root.state = Notif.Positioned
                                        root.velocityX = 0
                                        if (root.notif.urgency == NotificationUrgency.Critical) playSoundCritical.running = true
                                }
                        }

                        if (root.state == Notif.Dismissing) {
                                if (!root.playedOut) {
                                        playSoundOut.running = true
                                        root.playedOut = true
                                }
                                if (display.x < root.dismissX) {
                                        display.x += root.velocityX * frameTime
                                        root.velocityX += 20
                                }
                                else {
                                        if(!root.popedUp) root.dismissed();
                                }
                        }
                }
        }

        Display {
                id: display
                notif: root.notif
        }

        MouseArea {
                x: display.x - 160/2
                y: display.y - display.height/2 + 17

                width: display.width
                height: display.height


                enabled: root.state == Notif.Positioned

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: e => {
                        if (e.button == Qt.RightButton) root.state = Notif.Dismissing
                        else {
                                root.popup.notif = root.notif
                                root.popup.visible = true
                                root.popedUp = true
                        }
                }
        }

        Process {
                id: playSoundCritical
                running: false
                command: ["play", "~/.config/quickshell/notifications/assets/challenge_complete.ogg", "--no-show-progress"]
        }

        Process {
                id: playSoundIn
                running: true
                command: ["play", "~/.config/quickshell/notifications/assets/in.ogg", "--no-show-progress"]
        }

        Process {
                id: playSoundOut
                running: false
                command: ["play", "~/.config/quickshell/notifications/assets/out.ogg", "--no-show-progress"]
        }

        Process {
                id: showPopup
                command: ["qs", "ipc", "call", "popup", "open", root.notif.summary, root.notif.body, root.notif.appName]
                running: false
        }

        Timer {
                id: timer
                interval: root.lifetime
                repeat: false
                running: root.state == Notif.Positioned
                onTriggered: () => {
                        root.state = Notif.Dismissing
                }
        }
}
