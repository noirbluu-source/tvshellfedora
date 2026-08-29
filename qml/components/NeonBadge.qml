import QtQuick
import TVShell

Item {
    id: root
    property alias text: label.text
    property color accentColor: StyleTokens.neonAqua

    implicitWidth: label.implicitWidth + 24
    implicitHeight: label.implicitHeight + 12

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: StyleTokens.surfacePlate
        border.color: root.accentColor
        border.width: 2

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: root.accentColor
            opacity: 0.15
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        font.pixelSize: StyleTokens.fontCaption
        font.bold: true
        font.capitalization: Font.AllUppercase
        color: root.accentColor
    }
}
