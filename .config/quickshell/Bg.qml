import QtQuick
import Quickshell

PanelWindow {
        id: root
        
        property var config: Config.json

        aboveWindows: false
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
                top: true
                left: true
                bottom: true
                right: true
        }
        
        Image {
                property var wallpapers: root.config.videos.wallpaper.sources
                property var index: root.config.videos.wallpaper.index
                id: wallpaper
                source: `assets/wallpapers/${wallpapers[index]}`
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                smooth: false
        }
}
