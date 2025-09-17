import QtQuick

Item {
        x: parent.width / 2 - 182 // 182 = width of hotbar

        scale: 2.0
        id: hotbar

        Hunger {
                x: 100
                y: 1
        }

        Heart {
                y: 1
        }

        Cpu {
                y:12
        }

        Workstations {
                y: 18
        }
}
