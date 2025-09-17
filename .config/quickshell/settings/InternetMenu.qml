pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import "../components"

Column {
        id: root
        
        visible: false
        spacing: 5

        required property var wifiMenu
        required property var menuDepth

        property var devices: []
        property var deviceIndex: 0

        property var wifi: null


        Row {
                spacing: 10

                McButton {
                        id: deviceBtn
                        text: `Device:`
                        func: () => {
                                root.deviceIndex++;
                                if (root.deviceIndex >= root.devices.length) root.deviceIndex = 0;
                                getWifi.running = true
                        }
                }

                McButton {
                        text: "Device Informations..."
                        func: () => {}
                }
        }

        Row {
                spacing: 10

                McButton {
                        id: wifiBtn
                        text: `Wifi:`
                        func: () => {
                        }
                }

                McButton {
                        text: "Wifi Informations..."
                        func: () => {
                                root.visible = false
                                root.wifiMenu.visible = true
                                root.menuDepth.push([root.wifiMenu, "Wifi"]);
                        }
                }
        }

        Process {
                id: getDevices
                running: true
                command: ["iwctl", "device", "list"]

                stdout: StdioCollector {
                        onStreamFinished: {
                                let lines = this.text.split('\n');

                                for (let i = 4; i < lines.length-2; i++) {
                                        let info = {};
                                        let txt = lines[i].split(' ').filter(str => str.length > 0);
                                        info.name = txt[1];
                                        info.address = txt[2];
                                        info.powered = txt[3];
                                        info.mode = txt[4];
                                        root.devices.push(info);
                                }
                                deviceBtn.text = `Device: ${root.devices[root.deviceIndex].name}`;
                                
                                getWifi.command = ["iwctl", "station", root.devices[root.deviceIndex].name, "show"]
                                getWifi.running = true;
                        }
                }
                
        }

        Process {
                id: getWifi
                running: false
                command: []

                stdout: StdioCollector {
                        onStreamFinished: {
                                let lines = this.text.split('\n');

                                let texts = []

                                for (let i = 4; i < lines.length-2; i++) {
                                        let txt = lines[i].split(' ').filter(str => str.length > 0);
                                        // console.log(txt);
                                        texts.push(txt)
                                }
                                let info = {};
                                
                                info.scanning = texts[0][2] == "yes"
                                info.state = texts[1][1]

                                if (info.state == "connected") {
                                        info.connectedNetwork = texts[2][2];
                                        wifiBtn.text = `Wifi: ${info.connectedNetwork}`;
                                        info.ipv4 = texts[3][2];
                                }

                                root.wifi = info

                                root.wifiMenu.stationName = root.devices[root.deviceIndex]
                                root.wifiMenu.wifi = root.wifi
                        }
                }
        }
}
