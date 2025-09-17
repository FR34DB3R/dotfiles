pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

MouseArea {
        id: root

        required property string text
        required property var initialValue
        property var value: initialValue * 0.01 * maxValue
        property int percentage: value / maxValue * 100

        property bool isDragging: false

        width: sliderImg.width*2
        height: sliderImg.height*2

        property int maxValue: width - sliderHandleImg.width*2

        hoverEnabled: true

        onPressed: e => {
                value = e.x
                if (value > maxValue) value = maxValue
                percentage = value / maxValue * 100
                isDragging = true
        }

        onPositionChanged: e => {
                if (!isDragging) return
                value = e.x
                if (value > maxValue) value = maxValue
                if (value < 0) value = 0
                percentage = value / maxValue * 100
        }

        onReleased: () => {
                isDragging = false
                playClick.running = true
        }


        Image {
                x: width/2
                y: height/2
                scale: 2
                id: sliderImg
                source: "assets/slider.png"
                smooth: false
        }

        Image {
                x: width/2 + root.value
                y: height/2
                scale: 2
                id: sliderHandleImg
                source: root.containsMouse ? "assets/slider_handle_highlighted.png" : "assets/slider_handle.png"
                smooth: false
        }

        Text {
                anchors.centerIn: parent
                text: `${root.text}: ${root.percentage}%`
                font.family: minecraft.font.family
                font.pixelSize: 14
                color: "black"

                Text {
                        x: -1
                        y: -1
                        text:`${root.text}: ${root.percentage}%`
                        font.family: minecraft.font.family
                        font.pixelSize: 14
                        color: "white"
                }
        }

        Process {
                id: playClick
                running: false
                command: ["play", "--no-show-progress", "/home/hooss/.config/quickshell/components/assets/click.ogg"]
        }

        FontLoader {
                id: minecraft
                source: "../assets/Minecraft.otf"
        }
}
