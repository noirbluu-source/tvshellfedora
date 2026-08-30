import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    // 1. Top Horizontal Acid-Green Cathode Channel
    Item {
        anchors.top: parent.top
        anchors.topMargin: Theme.px(116)
        anchors.left: parent.left
        anchors.leftMargin: Theme.px(600)
        anchors.right: parent.right
        anchors.rightMargin: Theme.px(80)
        height: Theme.px(6)

        // Recessed Dark Slit Channel
        Rectangle {
            anchors.fill: parent
            radius: Theme.radiusSM
            color: Theme.surfaceRecessed
            border.color: Theme.bevelDark
            border.width: Theme.px(1)
        }

        // Core Glowing Neon Tube
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: Theme.px(2)
            color: Theme.neonAcidGreenBright

            // Diffuse Ambient Halo
            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: Theme.px(10)
                radius: Theme.radiusSM
                color: "transparent"
                border.color: Theme.neonAcidGreen
                border.width: Theme.px(2)
                opacity: 0.45
            }
        }
    }

    // 2. Vertical Purple Cathode Tube Separator (Between Dial and App Shelf)
    Item {
        anchors.top: parent.top
        anchors.topMargin: Theme.px(160)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.px(160)
        x: Theme.px(590)
        width: Theme.px(6)

        // Recessed Slit
        Rectangle {
            anchors.fill: parent
            radius: Theme.radiusSM
            color: Theme.surfaceRecessed
        }

        // Glowing Tube
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: Theme.px(2)
            color: Theme.neonPurpleBright

            Rectangle {
                anchors.centerIn: parent
                width: Theme.px(12)
                height: parent.height
                radius: Theme.radiusSM
                color: "transparent"
                border.color: Theme.neonPurple
                border.width: Theme.px(2)
                opacity: 0.40
            }
        }
    }
}
