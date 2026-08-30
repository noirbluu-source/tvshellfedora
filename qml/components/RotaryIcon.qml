import QtQuick
import TVShell

Item {
    id: root

    property string label: ""
    property string symbol: "■"
    property bool isSelected: false
    property bool isZoneFocused: false

    implicitWidth: Theme.px(110)
    implicitHeight: Theme.px(110)

    // 1. Ambient Holographic Halo when selected and focused
    Rectangle {
        anchors.fill: parent
        anchors.margins: -Theme.px(8)
        radius: width / 2
        color: "transparent"
        border.width: Theme.px(3)
        border.color: Theme.neonAqua
        opacity: (root.isSelected && root.isZoneFocused) ? 0.9 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
        }
    }

    // 2. Extruded Metal Housing (Chunky physical socket)
    Rectangle {
        id: socketBase
        anchors.fill: parent
        radius: width / 2
        color: root.isSelected ? Theme.surfacePlateRaised : Theme.concreteChassis
        border.width: root.isSelected ? Theme.px(3) : Theme.px(2)
        border.color: root.isSelected ? (root.isZoneFocused ? Theme.neonAqua : Theme.neonPurple) : Theme.chromeDark

        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }

        // 3. Top-Left Incident Bevel (45° light chamfer)
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.width: Theme.px(1)
            border.color: root.isSelected ? Theme.chromeHighlight : Theme.bevelLight
            opacity: root.isSelected ? 0.85 : 0.35
        }

        // 4. Translucent Purple Gel Inset Body
        Rectangle {
            anchors.fill: parent
            anchors.margins: Theme.px(6)
            radius: width / 2
            color: root.isSelected ? Qt.rgba(0.61, 0.36, 0.90, 0.45) : Qt.rgba(0.08, 0.09, 0.12, 0.85)

            // Inner Specular Glass Reflection
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.px(2)
                height: parent.height * 0.45
                radius: width / 2
                color: Qt.rgba(1.0, 1.0, 1.0, root.isSelected ? 0.22 : 0.06)
            }

            // Chunky Hardware Glyph
            Text {
                anchors.centerIn: parent
                text: root.symbol
                color: root.isSelected
                       ? (root.isZoneFocused ? Theme.neonAquaBright : Theme.chromeHighlight)
                       : Theme.chromeMid
                font.pixelSize: Theme.px(38)
                font.bold: true
            }
        }
    }

    // Physical Elevation & Depth
    scale: root.isSelected ? (root.isZoneFocused ? 1.18 : 1.08) : 0.88
    opacity: root.isSelected ? 1.0 : 0.65
    z: root.isSelected ? 10 : 1

    Behavior on scale {
        NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutBack }
    }
    Behavior on opacity {
        NumberAnimation { duration: Theme.animFast }
    }
}
