pragma Singleton
pragma ComponentBehavior: Bound


import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
        IpcHandler {
                target: "pause"

                function lock() {
                        lock.locked = true;
                }
        }
        
        WlSessionLock {
                id: lock
                locked: false

                WlSessionLockSurface {
                        id: lockSurface
                        color: "transparent"
                        Surface {
                                anchors.fill: parent
                                screen: lockSurface.screen
                                lock: lock
                                context: lockContext
                        }
                }
        }

        Context {
                id: lockContext
                onUnlocked: lock.locked = false
        }

        // Empty function to define first reference to singleton
        function init() {
        }
}
