import QtQuick
import TVShell

FocusScope {
    id: root

    property int currentIndex: 0
    property var buttonModel: [
        { label: "INPUT", glyph: "⎋", brass: true },
        { label: "NETWORK", glyph: "☵", brass: false },
        { label: "POWER", glyph: "⏻", brass: true }
    ]
    readonly property int count: buttonModel.length
    readonly property bool isZoneFocused: FocusManager.currentZone === FocusManager.Zone.TopControls

    signal controlTriggered(string action)

    implicitHeight: Theme.px(90)

    Component.onCompleted: {
        FocusManager.registerZone(FocusManager.Zone.TopControls, root)
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            FocusManager.currentZone = FocusManager.Zone.TopControls
        }
    }

    // D-Pad navigation across Top Bar buttons
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
        else if (event.key === Qt.Key_Down) {
            FocusManager.handleDirection("DOWN")
            event.accepted = true
        }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            var action = buttonModel[currentIndex].label
            root.controlTriggered(action)
            FocusManager.itemActivated(FocusManager.Zone.TopControls, currentIndex)
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

    // System Telemetry Clock Timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var d = new Date()
            var hh = String(d.getHours()).padStart(2, '0')
            var mm = String(d.getMinutes()).padStart(2, '0')
            var ss = String(d.getSeconds()).padStart(2, '0')
            clockText.text = hh + ":" + mm + ":" + ss
        }
    }

    // Industrial Top Frame Chassis
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMD
        color: Theme.smokedGlassDeep
        border.color: Theme.chromeDark
        border.width: Theme.px(1)

        // Top Highlight Chamfer
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Theme.px(1)
            color: Theme.bevelLight
        }

        // Left Status & Machine Telemetry
        Row {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(28)
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.px(20)

            // Blinking Hardware CRT LED Dot
            Rectangle {
                width: Theme.px(12)
                height: Theme.px(12)
                radius: width / 2
                color: Theme.phosphorGreen
                anchors.verticalCenter: parent.verticalCenter

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 0.3; duration: 800; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 0.3; to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                }
            }

            // OS Subsystem Title
            Text {
                text: "SYSTEM // TV-OS"
                color: Theme.chromeBright
                font.pixelSize: Theme.fontTitle
                font.bold: true
                font.letterSpacing: 2
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: Theme.px(2)
                height: Theme.px(24)
                color: Theme.chromeDark
                anchors.verticalCenter: parent.verticalCenter
            }

            // DRM Driver Telemetry Badge
            Rectangle {
                width: drmLabel.implicitWidth + Theme.px(16)
                height: drmLabel.implicitHeight + Theme.px(6)
                radius: Theme.radiusSharp
                color: Theme.surfaceRecessed
                border.color: Theme.chromeDark
                border.width: Theme.px(1)
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: drmLabel
                    anchors.centerIn: parent
                    text: "MESA / DRM 4K60"
                    color: Theme.neonAqua
                    font.pixelSize: Theme.fontMicro
                    font.bold: true
                    font.letterSpacing: 1
                }
            }

            // Digital HUD Clock
            Text {
                id: clockText
                text: "12:00:00"
                color: Theme.textSecondary
                font.pixelSize: Theme.fontBody
                font.bold: true
                font.letterSpacing: 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Right Physical Hardware Control Buttons (Zone 3 Focusable Row)
        Row {
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(20)
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.px(16)

            Repeater {
                model: root.buttonModel

                delegate: TactileButton {
                    labelText: modelData.label
                    glyph: modelData.glyph
                    isBrass: modelData.brass
                    isCurrent: (root.currentIndex === index) && root.isZoneFocused
                    width: Theme.px(160)
                    height: Theme.px(54)

                    onClicked: {
                        root.currentIndex = index
                        root.forceActiveFocus()
                        root.controlTriggered(modelData.label)
                    }
                }
            }
        }
    }
}
