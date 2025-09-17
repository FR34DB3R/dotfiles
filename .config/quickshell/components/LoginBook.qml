import QtQuick

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
                                func: () => { root.visible = false; }
                        }
                }
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }
}
