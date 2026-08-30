import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    property bool isElevated: false
    property bool isPressed: false
    property real cornerRadius: Theme.radiusMD
    property color plateColor: root.isElevated ? Theme.surfacePlateRaised : Theme.surfacePlate

    // Base Chassis Slab
    Rectangle {
        id: slab
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.plateColor
        border.width: root.isElevated ? Theme.px(3) : Theme.px(1)
        border.color: root.isElevated ? Theme.chromeHighlight : Theme.chromeDark

        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

        // Top-Left Incident Light Chamfer (45-degree Specular Rim)
        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            color: "transparent"
            border.width: Theme.px(1)
            border.color: root.isElevated ? Theme.chromeHighlight : Theme.bevelLight
            opacity: root.isElevated ? 0.95 : 0.35
        }

        // Bottom-Right Occlusion Ridge
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: root.isElevated ? Theme.px(3) : Theme.px(1)
            radius: root.cornerRadius
            color: root.isElevated ? Theme.neonPurple : Theme.bevelDark
            opacity: 0.90
        }
    }
}
