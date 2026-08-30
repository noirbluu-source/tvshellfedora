import QtQuick
import TVShell

Item {
    id: root

    property string itemTitle: ""
    property string itemSubtitle: ""
    property string itemCategory: ""
    property string itemGlyph: "▶"
    property bool isCurrent: false
    property bool isPressed: false

    signal cardClicked()

    implicitWidth: Theme.px(820)
    implicitHeight: Theme.px(120)

    // Outer Ambient Glow on Focus
    Rectangle {
        anchors.fill: parent
        anchors.margins: -Theme.px(4)
        radius: Theme.radiusMD + Theme.px(2)
        color: "transparent"
        border.width: Theme.px(2)
        border.color: Theme.neonAqua
        opacity: root.isCurrent ? 0.6 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
        }
    }

    // Industrial Chassis Base Plate
    Rectangle {
        id: chassisBase
        anchors.fill: parent
        radius: Theme.radiusMD
        color: root.isCurrent ? Theme.surfacePlateRaised : Theme.surfacePlate
        border.width: root.isCurrent ? Theme.px(3) : Theme.px(1)
        border.color: root.isCurrent ? Theme.neonAqua : Theme.chromeDark

        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }
        Behavior on color {
            ColorAnimation { duration: Theme.animFast }
        }

        // Top-Left 45-degree Specular Rim Chamfer
        Rectangle {
            anchors.fill: parent
            radius: Theme.radiusMD
            color: "transparent"
            border.width: Theme.px(1)
            border.color: root.isCurrent ? Theme.chromeHighlight : Theme.bevelLight
            opacity: root.isCurrent ? 0.8 : 0.25
        }

        // Bottom Occlusion Line for Physical Depth
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.px(2)
            radius: Theme.radiusMD
            color: root.isCurrent ? Theme.chromeDark : Theme.bevelDarkDeep
            opacity: 0.8
        }
    }

    // Card Content Row
    Row {
        anchors.fill: parent
        anchors.leftMargin: Theme.px(24)
        anchors.rightMargin: Theme.px(24)
        spacing: Theme.px(20)

        // Left: Chunky Hardware Icon Well
        Rectangle {
            id: iconWell
            width: Theme.px(74)
            height: Theme.px(74)
            radius: Theme.radiusSM
            anchors.verticalCenter: parent.verticalCenter
            color: root.isCurrent ? Theme.surfaceRecessed : Theme.concreteChassis
            border.color: root.isCurrent ? Theme.neonAqua : Theme.chromeDark
            border.width: Theme.px(2)

            Text {
                anchors.centerIn: parent
                text: {
                    if (root.itemTitle.indexOf("YouTube") !== -1) return "▶";
                    if (root.itemTitle.indexOf("VLC") !== -1) return "▲";
                    if (root.itemTitle.indexOf("File") !== -1) return "📁";
                    if (root.itemTitle.indexOf("Settings") !== -1) return "⚙";
                    if (root.itemTitle.indexOf("Store") !== -1) return "✦";
                    return "■";
                }
                color: root.isCurrent ? Theme.neonAquaBright : Theme.chromeMid
                font.pixelSize: Theme.px(30)
                font.bold: true
            }
        }

        // Center: Title, Subtitle, and Category Pill
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconWell.width - rightControl.width - (parent.spacing * 2)
            spacing: Theme.px(4)

            Row {
                width: parent.width
                spacing: Theme.px(14)

                Text {
                    id: titleText
                    text: root.itemTitle
                    color: root.isCurrent ? Theme.textPrimary : Theme.chromeBright
                    font.pixelSize: Theme.fontTitle
                    font.bold: true
                    letterSpacing: 1.0
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, parent.width - (catBadge.visible ? catBadge.width + parent.spacing : 0))

                    style: root.isCurrent ? Text.Outline : Text.Normal
                    styleColor: Qt.rgba(0, 0, 0, 0.9)
                }

                Rectangle {
                    id: catBadge
                    visible: root.itemCategory.length > 0
                    width: catLabel.implicitWidth + Theme.px(16)
                    height: catLabel.implicitHeight + Theme.px(6)
                    radius: Theme.radiusSharp
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.isCurrent ? Theme.neonPurple : Theme.surfaceRecessed
                    border.color: root.isCurrent ? Theme.neonPink : Theme.chromeDark
                    border.width: Theme.px(1)

                    Text {
                        id: catLabel
                        anchors.centerIn: parent
                        text: root.itemCategory.toUpperCase()
                        color: root.isCurrent ? Theme.chromeHighlight : Theme.textSecondary
                        font.pixelSize: Theme.fontMicro
                        font.bold: true
                        font.letterSpacing: 1.2
                    }
                }
            }

            Text {
                text: root.itemSubtitle
                color: root.isCurrent ? Theme.neonAquaBright : Theme.textSecondary
                font.pixelSize: Theme.fontBody
                elide: Text.ElideRight
                width: parent.width
                opacity: root.isCurrent ? 0.95 : 0.65
            }
        }

        // Right: Focus Glyph Well
        Item {
            id: rightControl
            width: Theme.px(40)
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.centerIn: parent
                width: Theme.px(36)
                height: Theme.px(36)
                radius: width / 2
                color: root.isCurrent ? Theme.neonAqua : Theme.surfaceRecessed
                border.color: root.isCurrent ? Theme.chromeHighlight : Theme.chromeDark
                border.width: Theme.px(1)

                Text {
                    anchors.centerIn: parent
                    text: root.itemGlyph
                    color: root.isCurrent ? Theme.textInverse : Theme.textDisabled
                    font.pixelSize: Theme.px(16)
                    font.bold: true
                }
            }
        }
    }

    // Scale & Elevation on Focus
    scale: root.isPressed ? Theme.pressedScale : (root.isCurrent ? Theme.focusScaleCard : 1.0)
    z: root.isCurrent ? 10 : 1

    Behavior on scale {
        NumberAnimation {
            duration: root.isPressed ? Theme.animInstant : Theme.animFast
            easing.type: Easing.OutQuad
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: root.isPressed = true
        onReleased: root.isPressed = false
        onClicked: root.cardClicked()
    }
}
