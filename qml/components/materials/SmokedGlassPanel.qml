import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    property real cornerRadius: Theme.radiusMD
    property bool hasGelSheen: true
    property bool isHighlighted: false

    Rectangle {
        id: glassBody
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.isHighlighted ? Theme.gelAcidGreenTranslucent : Theme.smokedGlassDeep
        border.width: Theme.px(1)
        border.color: root.isHighlighted ? Theme.neonAcidGreenBright : Theme.chromeDark

        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

        // Top Glass Refraction Horizon
        Rectangle {
            visible: root.hasGelSheen
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.44
            radius: root.cornerRadius
            color: Qt.rgba(1.0, 1.0, 1.0, root.isHighlighted ? 0.16 : 0.04)
        }

        // 1px Inner Glass Refraction Lip
        Rectangle {
            anchors.fill: parent
            anchors.margins: Theme.px(1)
            radius: Math.max(0, root.cornerRadius - Theme.px(1))
            color: "transparent"
            border.width: Theme.px(1)
            border.color: Theme.bevelLightSharp
            opacity: root.isHighlighted ? 0.70 : 0.25
        }
    }
}
