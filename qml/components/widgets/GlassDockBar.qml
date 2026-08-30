import QtQuick
import TVShell

FocusScope {
    id: root

    property string statusMessage: "STATUS: READY // 60 HZ DRM ENGINE ACTIVE"
    property int currentIndex: 0
    property var actionModel: [
        { label: "GUIDE", glyph: "☷" },
        { label: "SEARCH", glyph: "⌕" },
        { label: "INFO", glyph: "ℹ" }
    ]
    readonly property int count: actionModel.length
    readonly property bool isZoneFocused: FocusManager.currentZone === FocusManager.Zone.BottomBar

    signal actionTriggered(string action)

    implicitHeight: Theme.px(94)

    Component.onCompleted: {
        FocusManager.registerZone(FocusManager.Zone.BottomBar, root)
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            FocusManager.currentZone = FocusManager.Zone.BottomBar
        }
    }

    // D-PAD Navigation in Bottom Dock
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

    // Smoked Glass Chassis
    SmokedGlassPanel {
        anchors.fill: parent
        cornerRadius: Theme.radiusMD
        isHighlighted: root.isZoneFocused
    }

    // Left Terminal Screen (Scanlines + Phosphor Readout)
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: Theme.px(24)
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.54
        height: Theme.px(58)
        radius: Theme.radiusSM
        color: Theme.surfaceRecessed
        border.color: Theme.bevelDarkDeep
        border.width: Theme.px(2)
        clip: true

        // Batched Scanlines
        Canvas {
            anchors.fill: parent
            opacity: 0.30
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.fillStyle = "#000000";
                for (var y = 0; y < height; y += Theme.px(4)) {
                    ctx.fillRect(0, y, width, 1);
                }
            }
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(16)
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(16)
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.px(12)

            Text {
                text: "▶"
                color: Theme.neonAcidGreen
                font.pixelSize: Theme.fontCaption
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.statusMessage
                color: Theme.neonAcidGreenBright
                font.pixelSize: Theme.fontBody
                font.bold: true
                font.letterSpacing: 1.2
                elide: Text.ElideRight
                width: parent.width - Theme.px(40)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // Right Action Buttons
    Row {
        anchors.right: parent.right
        anchors.rightMargin: Theme.px(20)
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.px(14)

        Repeater {
            model: root.actionModel

            delegate: TactileButton {
                labelText: modelData.label
                glyph: modelData.glyph
                isCurrent: (root.currentIndex === index) && root.isZoneFocused
                width: Theme.px(146)
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
