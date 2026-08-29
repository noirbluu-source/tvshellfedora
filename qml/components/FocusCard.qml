import QtQuick
import TVShell

Item {
    id: root

    property string itemLabel: ""
    property string itemSubtitle: ""
    property string itemCategory: ""
    property bool isCurrent: false
    signal cardClicked()

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.px(8)
        color: root.isCurrent ? Theme.surfaceFocused : Theme.surfaceBase
        border.color: root.isCurrent ? Theme.borderFocused : Theme.borderBase
        border.width: root.isCurrent ? Theme.px(4) : Theme.px(2)

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.px(28)
            anchors.rightMargin: Theme.px(28)
            spacing: Theme.px(6)

            Row {
                spacing: Theme.px(16)
                width: parent.width

                Text {
                    text: root.itemLabel
                    color: root.isCurrent ? Theme.textPrimary : Theme.textSecondary
                    font.pixelSize: Theme.px(26)
                    font.bold: root.isCurrent
                    elide: Text.ElideRight
                }

                Rectangle {
                    visible: root.itemCategory.length > 0
                    width: catText.implicitWidth + Theme.px(16)
                    height: catText.implicitHeight + Theme.px(6)
                    radius: Theme.px(4)
                    color: root.isCurrent ? Theme.borderFocused : Theme.borderBase
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: catText
                        anchors.centerIn: parent
                        text: root.itemCategory
                        color: Theme.textPrimary
                        font.pixelSize: Theme.px(14)
                        font.bold: true
                    }
                }
            }

            Text {
                visible: root.itemSubtitle.length > 0
                width: parent.width
                text: root.itemSubtitle
                color: Theme.textSecondary
                font.pixelSize: Theme.px(16)
                elide: Text.ElideRight
            }
        }
    }

    scale: root.isCurrent ? 1.02 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
    }
}
