import QtQuick
import TVShell

Item {
    id: root

    property string itemLabel: ""
    property bool isCurrent: false
    signal cardClicked()

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.px(8)
        color: root.isCurrent ? Theme.surfaceFocused : Theme.surfaceBase
        border.color: root.isCurrent ? Theme.borderFocused : Theme.borderBase
        border.width: root.isCurrent ? Theme.px(5) : Theme.px(2)

        Text {
            anchors.centerIn: parent
            text: root.itemLabel
            color: root.isCurrent ? Theme.textPrimary : Theme.textSecondary
            font.pixelSize: Theme.px(26)
            font.bold: root.isCurrent
            elide: Text.ElideRight
        }
    }

    scale: root.isCurrent ? 1.03 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
    }
}
