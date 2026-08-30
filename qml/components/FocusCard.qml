import QtQuick
import TVShell

Item {
    id: root

    property string itemLabel: ""
    property string itemSubtitle: ""
    property string itemCategory: ""
    property bool isCurrent: false
    property bool isPressed: false
    signal cardClicked()

    // 1. Holographic Glow Layer (Behind chassis)
    HolographicBorder {
        id: holoGlow
        active: root.isCurrent
        cornerRadius: Theme.radiusMD
    }

    // 2. Brushed Chrome & Neumorphic Chassis Layer
    FocusChromeFrame {
        id: chromeFrame
        active: root.isCurrent
        cornerRadius: Theme.radiusMD
    }

    // 3. Card Content & 10-Foot Typography
    Item {
        anchors.fill: parent
        anchors.margins: Theme.px(24)

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.px(8)

            // Header Row: Title & Chromatic Category Pill
            Row {
                width: parent.width
                spacing: Theme.px(16)

                Text {
                    id: mainTitle
                    text: root.itemLabel
                    color: root.isCurrent ? Theme.textPrimary : Theme.textSecondary
                    font.pixelSize: Theme.fontTitle
                    font.bold: true
                    elide: Text.ElideRight
                    width: parent.width - (catBadge.visible ? catBadge.width + parent.spacing : 0)

                    // Text drop shadow for TV contrast
                    style: Text.Outline
                    styleColor: root.isCurrent ? "rgba(0, 0, 0, 0.85)" : "transparent"
                }

                // Category Badge Pill
                Rectangle {
                    id: catBadge
                    visible: root.itemCategory.length > 0
                    width: catLabel.implicitWidth + Theme.px(20)
                    height: catLabel.implicitHeight + Theme.px(8)
                    radius: Theme.radiusPill
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.isCurrent ? Theme.neonPurple : Theme.surfaceRecessed
                    border.color: root.isCurrent ? Theme.neonAqua : Theme.chromeDark
                    border.width: Theme.px(1)

                    Text {
                        id: catLabel
                        anchors.centerIn: parent
                        text: root.itemCategory.toUpperCase()
                        color: root.isCurrent ? Theme.chromeHighlight : Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                        font.bold: true
                        font.letterSpacing: 1.2
                    }
                }
            }

            // Subtitle Description
            Text {
                visible: root.itemSubtitle.length > 0
                width: parent.width
                text: root.itemSubtitle
                color: root.isCurrent ? Theme.chromeBright : Theme.textMuted
                font.pixelSize: Theme.fontBody
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
            }
        }
    }

    // 4. Focus Elevation & Depression Transforms
    scale: root.isPressed ? Theme.pressedScale : (root.isCurrent ? Theme.focusScaleCard : 1.0)
    z: root.isCurrent ? 10 : 1

    Behavior on scale {
        NumberAnimation {
            duration: root.isPressed ? Theme.animInstant : Theme.animFast
            easing.type: Easing.OutQuad
        }
    }

    // Mouse fallback handler for desktop dev testing
    MouseArea {
        anchors.fill: parent
        onPressed: root.isPressed = true
        onReleased: root.isPressed = false
        onClicked: root.cardClicked()
    }
}
