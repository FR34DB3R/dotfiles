pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

PanelWindow {
        id: root

        property list<Notification> notifs;

        WlrLayershell.namespace: "shell:notifications"
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
                top: true
                bottom: true
                left: true
                right: true
        }
        
        NotificationServer {
                actionsSupported: true

                onNotification: notif => {
                        notif.tracked = true;
                        
                        root.notifs = [...root.notifs, notif];
                }
        }


        visible: stack.children.length != 0

        mask: Region {
                item: popup.visible ? popup : stack
        }

        ListView {
                id: stack

                model: ScriptModel {
                        values: [...root.notifs]
                }

                anchors.right: parent.right
                implicitWidth: 200
                implicitHeight: children.reduce((h, c) => h + c.height, 0)
                interactive: false

                delegate: Notif {
                        required property Notification modelData
                        notif: modelData
                        popup: popup

                        onDismissed: () => {
                                const index = root.notifs.indexOf(notif)
                                if (index > -1) root.notifs.splice(index, 1);

                                root.notifs = root.notifs.filter(notif => notif != null)

                                if (notif != null) modelData.dismiss();
                        }
                }
        }

        Popup {
                id: popup
                notif: null
                visible: false
                onDismissed: () => {
                         const index = root.notifs.indexOf(notif)
                         if (index > -1) root.notifs.splice(index, 1);

                         notif.dismiss();
                }
        }
}
