pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../components"

PanelWindow {
        id: root

        required property var controller

        color: "#55000000"

        exclusionMode: ExclusionMode.Ignore

        property var menuDepth: [[firstMenu, "Options"]]
        property string title: root.menuDepth[root.menuDepth.length - 1][1]

        anchors {
                left: true
                right: true
                top: true
                bottom: true
        }

        Text {
                property var init: true
                id: titleText
                text: root.title
                color: "#555555"
                x: parent.width / 2 - width / 2
                y: 50
                font.family: minecraft.font.family
                font.pixelSize: 14
                
                onTextChanged: {
                        if (init) {
                                init = false
                                return
                        }
                        x = parent.width / 2 - width / 2
                }

                Text {
                        text: root.title
                        color: "white"
                        x: -1
                        y: -1
                        font.family: minecraft.font.family
                        font.pixelSize: 14
                }
        }

        Column {
                anchors.centerIn: parent
                Column {
                        id: firstMenu
                        visible: true
                        spacing: 5
                        Row {
                                spacing: 10
                                
                                McButton {
                                        text: "Video Settings..."
                                        func: () => {
                                                firstMenu.visible = false
                                                videoMenu.visible = true
                                                root.menuDepth.push([videoMenu, "Vidoes"]);
                                                root.title = root.menuDepth[root.menuDepth.length - 1][1]
                                        }
                                }
                                McButton {
                                        text: "Music & Sounds..."
                                        func: () => {
                                                firstMenu.visible = false
                                                soundMenu.visible = true
                                                root.menuDepth.push([soundMenu, "Music & Sounds"]);
                                                root.title = root.menuDepth[root.menuDepth.length - 1][1]
                                        }
                                }
                        }
                        Row {
                                spacing: 10
                                
                                McButton {
                                        text: "Internet..."
                                        func: () => {
                                                firstMenu.visible = false
                                                internetMenu.visible = true
                                                root.menuDepth.push([internetMenu, "Internet"]);
                                                root.title = root.menuDepth[root.menuDepth.length - 1][1]
                                        }
                                }
                                McButton {
                                        text: "Bluetooth..."
                                        func: () => {
                                        }
                                }
                        }
                        Row {
                                spacing: 10
                                
                                McButton {
                                        text: "Battery..."
                                        func: () => {
                                                firstMenu.visible = false
                                                batteryMenu.visible = true
                                                root.menuDepth.push([batteryMenu, "Bettery"]);
                                                root.title = root.menuDepth[root.menuDepth.length - 1][1]
                                        }
                                }
                                McButton {
                                        text: "Working..."
                                        disabled: true
                                        func: () => {
                                                firstMenu.visible = false
                                        }
                                }
                        }
                }

                SoundMenu {
                        id: soundMenu
                }

                VideoMenu {
                        id: videoMenu
                }

                InternetMenu {
                        id: internetMenu
                        wifiMenu: wifiMenu
                        menuDepth: root.menuDepth
                }

                BatteryMenu {
                        id: batteryMenu
                }

                WifiMenu {
                        id: wifiMenu
                        stationName: null
                        wifi: null
                }
        }
        
        McButton {
                x: parent.width / 2 - width / 2
                y: parent.height - 100
                text: "Done"
                func: () => {
                        if (root.menuDepth[root.menuDepth.length - 1][1] == "Options") {
                                root.controller.isOpen = false;
                        } else {
                                let menu = root.menuDepth.pop();
                                menu[0].visible = false;

                                root.menuDepth[root.menuDepth.length - 1][0].visible = true;
                                root.title = root.menuDepth[root.menuDepth.length - 1][1];
                        }
                }
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }
}
