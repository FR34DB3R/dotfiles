pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import "../components"
import ".."

Rectangle {
        id: root

        required property ShellScreen screen
        required property Context context
        required property var lock

        color: "transparent"

        property string username: "hooss"

        Image {
                id: bg
                source: `../assets/wallpapers/${Config.json.videos.wallpaper.sources[Config.json.videos.wallpaper.index]}`
                smooth: false
                scale: 1.3

                layer.enabled: true
                layer.effect: MultiEffect {
                        blurEnabled: true
                        brightness: -0.1
                        blur: 1
                        blurMax: 32
                }
        }

        Column {
                anchors.centerIn: parent
                spacing: 20
                Text {
                        text: "Game Menu"
                        color: "black"
                        font.family: minecraft.font.family
                        font.pixelSize: 14
                        x: parent.width / 2 - width / 2
                        Text {
                                text: "Game Menu"
                                color: "white"
                                font.family: minecraft.font.family
                                font.pixelSize: 14
                                x: -1
                                y: -1
                        }
                }
                Column {
                        spacing: 8

                        McButton {
                                text: "Back To Game"
                                func: () => {
                                        loginBook.visible = true
                                }
                        }

                        McButton {
                                text: "Save and Quit to Title"
                                func: () => {
                                        exitGame.running = true
                                }
                        }
                        
                        // Use it when you make some dangerous changes for exit from lockscreen.
                        /*
                        McButton {
                                text: "EXIT!!!!!"
                                func: () => {
                                        root.context.unlocked()
                                }
                        }
                        */
                }
        }
        
        Rectangle {
                anchors.fill: parent
                color: "#35000000"
                id: loginBook
                visible: false

                Column {
                        x: parent.width / 2 - width / 2
                        y: parent.height / 2 - height / 2

                        spacing: 100
                        Image {
                                x: parent.width / 2 - width / 2
                                scale: 2.0
                                source: "assets/book.png"
                                smooth: false

                                Item {
                                        x: 20
                                        y: 26
                                        width: 24 * 2
                                        Text {
                                                text: "Enter the Password:"
                                                font.family: minecraft.font.family
                                                font.pixelSize: 8
                                        }

                                        TextInput {
                                                id: passwdInput
                                                x:10
                                                y:10
                                                focus: loginBook.visible
                                                font.family: minecraft.font.family
                                                echoMode: TextInput.Password
                                                font.pixelSize: 8

                                                color: root.context.showFailure ? "#FF5555" : "black"

                                                onTextChanged: () => {
                                                        if (text != "") root.context.showFailure = false;
                                                        loginBtn.disabled = text == ""
                                                }

                                                onAccepted: {
                                                        loginBtn.clicked(null)
                                                }

                                                Keys.onEscapePressed: {
                                                        text = "";
                                                }
                                        }

                                        Text {
                                                y: 20
                                                text: `of ${root.username}`
                                                color: "#555555"
                                                font.family: minecraft.font.family
                                                font.pixelSize: 8
                                        }

                                        Text {
                                                y: 40
                                                text: root.context.unlockInProgress ? "trying to login..." : ""
                                                color: "#AAAAAA"
                                                font.family: minecraft.font.family
                                                font.pixelSize: 8
                                        }
                                }
                        }

                        Row {
                                spacing: 5
                                McHalfButton {
                                        id: loginBtn
                                        text: "Sign and Close"
                                        disabled: true
                                        func: () => {
                                                root.context.currentText = passwdInput.text;
                                                root.context.tryUnlock();
                                        }
                                }

                                McHalfButton {
                                        text: "Cancel"
                                        func: () => { loginBook.visible = false; }
                                }
                        }
                }
        }

        Process {
                id: exitGame
                running: false
                command: ["sh", "/home/hooss/.config/quickshell/pause/exit.sh"]
        }

        Process {
                id: runOption
                running: false
                command: ["qs", "ipc", "call", "settings", "open"]
        }

        Connections {
                target: root.context

                function onPamSuccess() {
                        root.context.unlocked()
                }
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }
}
