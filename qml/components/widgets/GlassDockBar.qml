import QtQuick
import TVShell

FocusScope {
    id: root

    property string statusMessage: "STATUS: READY // 4K RENDER DRIVER ACTIVE"
    property int currentIndex: 0
    property var actionModel: [
        { label: "GUIDE", glyph: "☷" },
        { label: "SEARCH", glyph: "⌕" },
        { label: "INFO", glyph: "ℹ" }
    ]
    readonly property int count: actionModel.length
    readonly property bool isZoneFocused: FocusManager.currentZone === FocusManager.Zone.BottomBar

    signal actionTriggered(string action)

    implicitHeight: Theme.px(100)

    Component.onCompleted: {
        FocusManager.registerZone(FocusManager.Zone.BottomBar, root)
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            FocusManager.currentZone = FocusManager.Zone.BottomBar
        }
    }

    // D-Pad navigation across Bottom Bar actions
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Left) {
            if (currentIndex > 0) {
                currentIndex--
            } else {
                FocusManager.handleDirection("LEFT")
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Right) {
            if (currentIndex < count - 1) {
                currentIndex++
            } else {
                FocusManager.handleDirection("RIGHT")
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Up) {
            FocusManager.handleDirection("UP")
            event.accepted = true
        }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            var action = actionModel[currentIndex].label
            root.actionTriggered(action)
            FocusManager.itemActivated(FocusManager.Zone.BottomBar, currentIndex)
            event.accepted = true
        }
        else if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
            FocusManager.backRequested()
            event.accepted = true
        }
        else if (event.key === Qt.Key_M || event.key === Qt.Key_Menu) {
            FocusManager.menuRequested()
            event.accepted = true
        }
    }

    // Floating Smoked Glass Capsule Dock
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusLG
        color: Theme.smokedGlassDeep
        border.color: root.isZoneFocused ? Theme.neonPurple : Theme.chromeDark
        border.width: root.isZoneFocused ? Theme.px(2) : Theme.px(1)

        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }

        // Top Specular Glass Lip Reflection
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Theme.px(1)
            color: Theme.bevelLightSharp
            opacity: 0.6
        }

        // Left Terminal / CRT Phosphor Log Screen
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(24)
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.52
            height: Theme.px(60)
            radius: Theme.radiusSM
            color: Theme.surfaceRecessed
            border.color: Theme.bevelDarkDeep
            border.width: Theme.px(2)
            clip: true

            // Scanline lines over CRT screen
            Column {
                anchors.fill: parent
                opacity: 0.25
                Repeater {
                    model: Math.ceil(parent.height / Theme.px(4))
                    Rectangle {
                        width: parent.width
                        height: Theme.px(1)
                        color: "#000000"
                        Rectangle {
                            anchors.top: parent.bottom
                            width: parent.width
                            height: Theme.px(3)
                            color: "transparent"
                        }
                    }
                }
            }

            // CRT Text Readout
            Row {
                anchors.left: parent.left
                anchors.leftMargin: Theme.px(16)
                anchors.right: parent.right
                anchors.rightMargin: Theme.px(16)
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.px(12)

                Text {
                    text: "▶"
                    color: Theme.neonAqua
                    font.pixelSize: Theme.fontCaption
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: root.statusMessage
                    color: Theme.phosphorGreen
                    font.pixelSize: Theme.fontBody
                    font.bold: true
                    font.letterSpacing: 1.2
                    elide: Text.ElideRight
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Right Quick Action Buttons (Zone 4 Focusable Row)
        Row {
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(24)
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.px(16)

            Repeater {
                model: root.actionModel

                delegate: TactileButton {
                    labelText: modelData.label
                    glyph: modelData.glyph
                    isBrass: false
                    isCurrent: (root.currentIndex === index) && root.isZoneFocused
                    width: Theme.px(150)
                    height: Theme.px(54)

                    onClicked: {
                        root.currentIndex = index
                        root.forceActiveFocus()
                        root.actionTriggered(modelData.label)
                    }
                }
            }
        }
    }
}
