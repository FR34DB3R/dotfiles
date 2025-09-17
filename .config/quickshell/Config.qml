pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
        id: root
        readonly property var json: JSON.parse(configFile.text())

        function write() {
                configFile.setText(JSON.stringify(json, null, 8))
        }
        
        FileView {
                id: configFile
                path: "/home/user/.config/quickshell/config.json"

                watchChanges: true
                onFileChanged: reload()

                onAdapterUpdated: writeAdapter()
        }
}
