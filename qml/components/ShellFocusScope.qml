import QtQuick
import TVShell

FocusScope {
    id: root

    property string labelText: "Card"
    signal activated()

    implicitWidth: Theme.px(600)
    implicitHeight: Theme.px(360)

    // Keyboard action hooks
    Keys.onReturnPressed: root.activated()
    Keys.onEnterPressed: root.activated()
    Keys.onSpacePressed: root.activated()

    Rectangle {
        id: visualBody
        anchors.fill: parent
        radius: Theme.px(12)
        color: root.activeFocus ? Theme.surfaceFocused : Theme.surfaceBase
        border.color: root.activeFocus ? Theme.borderFocused : Theme.borderBase
        border.width: root.activeFocus ? Theme.px(6) : Theme.px(2)

        Column {
            anchors.centerIn: parent
            spacing: Theme.px(16)

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.labelText
                color: root.activeFocus ? Theme.textPrimary : Theme.textSecondary
                font.pixelSize: Theme.px(36)
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.activeFocus ? "ACTIVE FOCUS (PRESS ENTER)" : "UNFOCUSED"
                color: root.activeFocus ? Theme.textAccent : Theme.textSecondary
                font.pixelSize: Theme.px(20)
                font.letterSpacing: 2
            }
        }
    }

    // Dynamic scale feedback for focus confirmation
    scale: root.activeFocus ? 1.04 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
    }
}
