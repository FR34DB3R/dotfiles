pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
        id: root
        
        required property var controller

        anchors {
                left: true
                right: true
                top: true
                bottom: true
        }

        exclusionMode: ExclusionMode.Ignore
        color: "#35000000"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        WlrLayershell.namespace: "shell:launcher"
        
        Item {
                x: parent.width / 2 - 256
                y: parent.height / 2 - 180
                Image {
                        x: 127
                        y: 128
                        scale: 2.0
                        source: "assets/book.png"
                        smooth: false
                        
                        Item {
                                x: 20
                                y: 15

                                TextInput {
                                        id: search

                                        focus: true
                                        Keys.forwardTo: [list]
                                        Keys.onEscapePressed: root.controller.isOpen = false

                                        Keys.onPressed: event => {
                                                if (event.modifiers & Qt.ControlModifier) {
                                                        if (event.key == Qt.Key_J) {
                                                                list.currentIndex = list.currentIndex == list.count - 1 ? 0 : list.currentIndex + 1;
                                                                event.accepted = true;
                                                        } else if (event.key == Qt.Key_K) {
                                                                list.currentIndex = list.currentIndex == 0 ? list.count - 1 : list.currentIndex - 1;
                                                                event.accepted = true;
                                                        }
                                                }
                                        }

                                        onAccepted: {
                                                if (list.currentItem) {
                                                        list.currentItem.clicked(null);
                                                }
                                        }

                                        onTextChanged: {
                                                list.currentIndex = 0;
                                        }

                                        font.family: minecraft.font.family
                                }

                                ListView {
                                        width: 95
                                        height: 125
                                        y: 20
                                        id: list
                                        cacheBuffer: 0
                                        model: ScriptModel {
                                                values: DesktopEntries.applications.values.map(object => {
                                                        const stxt = search.text.toLowerCase();
                                                        const ntxt = object.name.toLowerCase();

                                                        let si = 0;
                                                        let ni = 0;

                                                        let matches = [];
                                                        let startMatch = -1;

                                                        for (let si = 0; si != stxt.length; si++) {
                                                                const sc = stxt[si];
                                                                while (true) {
                                                                        if (ni == ntxt.length)
                                                                                return null;
                                                                        
                                                                        const nc = ntxt[ni++];

                                                                        if (nc == sc) {
                                                                                if (startMatch == -1) startMatch = ni;
                                                                                break;
                                                                        } else {
                                                                                if (startMatch == -1) {
                                                                                        matches.push({
                                                                                                index: startMatch,
                                                                                                length: ni - startMatch
                                                                                        });

                                                                                        startMatch = -1
                                                                                }
                                                                        }
                                                                }
                                                        }
                                                        
                                                        if (startMatch != -1) {
                                                                matches.push({
                                                                        index: startMatch,
                                                                        length: ni - startMatch + 1
                                                                })
                                                        }

                                                        return {
                                                                object: object,
                                                                matches: matches
                                                        }

                                                }).filter(entry => entry != null).sort((a, b) => {
                                                        let ai = 0;
                                                        let bi = 0;
                                                        let s = 0;

                                                        while (ai != a.matches.length && bi != b.matches.length) {
                                                                const am = a.matches[ai];
                                                                const bm = b.matches[bi];
                                                                
                                                                s = bm.length - am.length;
                                                                if (s != 0) return s;
                                                                
                                                                s = am.index - bm.index;
                                                                if (s != 0) return s;

                                                                ai++; bi++;
                                                        }

                                                        s = a.matches.length - b.matches.length;
                                                        if (s != 0) return s;

                                                        s = a.object.name.length - b.object.name.length;
                                                        if (s != 0) return s;

                                                        return a.object.name.localeCompare(b.object.name);
                                                }).map(entry => entry.object);

                                                onValuesChanged: list.currentIndex = 0
                                        }

                                        keyNavigationEnabled: true
                                        keyNavigationWraps: true
                                        highlightMoveVelocity: -1
                                        highlightMoveDuration: 100
                                        preferredHighlightBegin: list.topMargin
                                        preferredHighlightEnd: list.height - list.bottomMargin
                                        highlightRangeMode: ListView.ApplyRange
                                        snapMode: ListView.SnapToItem

                                        delegate: MouseArea {
                                                required property DesktopEntry modelData
                                                required property int index
                                                id: delegate
                                                
                                                implicitHeight: 10

                                                onClicked: {
                                                        if (modelData.runInTerminal) {
                                                                let command = ['kitty', ...modelData.command]

                                                                Quickshell.execDetached({
                                                                        command: command,
                                                                        workingDirectory: modelData.workingDirectory,
                                                                });
                                                        } else {
                                                                modelData.execute();
                                                        }
                                                        root.controller.isOpen = false
                                                }

                                                Row {
                                                        spacing: 5
                                                        Image {
                                                                width: 10
                                                                height: 10
                                                                asynchronous: true
                                                                smooth: false
                                                                source: Quickshell.iconPath(delegate.modelData.icon)
                                                        }

                                                        Text {
                                                                text: delegate.modelData.name
                                                                color: delegate.index == list.currentIndex ? "#FF55FF" : "black"
                                                                font.family: minecraft.font.family
                                                                font.pixelSize: 10
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }

}

