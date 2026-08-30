import QtQuick
import TVShell

FocusScope {
    id: root
    clip: true

    property var model: ["ALL APPS", "MEDIA", "SYSTEM", "UTILITIES"]
    property int currentIndex: 0
    readonly property int count: model ? model.length : 0
    property bool isZoneFocused: FocusManager.currentZone === FocusManager.Zone.RotaryMenu

    signal itemSelected(int index)

    implicitWidth: Theme.px(520)
    implicitHeight: Theme.px(800)

    Component.onCompleted: {
        FocusManager.registerZone(FocusManager.Zone.RotaryMenu, root)
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            FocusManager.currentZone = FocusManager.Zone.RotaryMenu
        }
    }

    function isAtBottom() {
        return currentIndex >= count - 1
    }

    // D-PAD ROTARY KEY HANDLER
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Up) {
            if (currentIndex > 0) {
                currentIndex--
            } else {
                FocusManager.handleDirection("UP")
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Down) {
            if (currentIndex < count - 1) {
                currentIndex++
            } else {
                FocusManager.handleDirection("DOWN")
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Right) {
            FocusManager.handleDirection("RIGHT")
            event.accepted = true
        }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            root.itemSelected(currentIndex)
            FocusManager.itemActivated(FocusManager.Zone.RotaryMenu, currentIndex)
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

    // 1. MECHANICAL BEZEL & CHROME ARC TRACK
    Item {
        anchors.fill: parent

        // Outer Dark Steel Flange
        Rectangle {
            x: -Theme.px(200)
            y: 0
            width: Theme.px(360)
            height: parent.height
            radius: Theme.radiusLG
            color: Theme.concreteChassis
            border.color: Theme.chromeDark
            border.width: Theme.px(2)

            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: Theme.px(2)
                color: Theme.bevelLight
                opacity: 0.4
            }
        }

        // Circular Chrome Dial Rotor Arc
        Rectangle {
            x: -Theme.px(340)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(600)
            height: Theme.px(600)
            radius: width / 2
            color: Theme.smokedGlassDeep
            border.color: root.isZoneFocused ? Theme.neonPurple : Theme.chromeDark
            border.width: Theme.px(3)

            Behavior on border.color {
                ColorAnimation { duration: Theme.animFast }
            }

            // Radial Calibration Ticks
            Canvas {
                id: dialTicks
                anchors.fill: parent
                renderTarget: Canvas.FramebufferObject

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    var cx = width / 2;
                    var cy = height / 2;
                    var r = width / 2 - Theme.px(12);

                    ctx.lineWidth = Theme.px(2);
                    for (var a = -60; a <= 60; a += 10) {
                        var rad = a * Math.PI / 180.0;
                        var isMajor = (a % 20 === 0);
                        var tickLen = isMajor ? Theme.px(16) : Theme.px(8);

                        var x1 = cx + (r - tickLen) * Math.cos(rad);
                        var y1 = cy + (r - tickLen) * Math.sin(rad);
                        var x2 = cx + r * Math.cos(rad);
                        var y2 = cy + r * Math.sin(rad);

                        ctx.strokeStyle = isMajor ? "rgba(220, 229, 237, 0.40)" : "rgba(143, 163, 181, 0.18)";
                        ctx.beginPath();
                        ctx.moveTo(x1, y1);
                        ctx.lineTo(x2, y2);
                        ctx.stroke();
                    }
                }
            }
        }
    }

    // 2. ACTIVE SELECTION LENS & INDICATOR NEEDLE
    Item {
        id: centerLens
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Theme.px(100)
        z: 5

        // Glowing Pointer Needle
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(100)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(26)
            height: Theme.px(6)
            radius: Theme.radiusSharp
            color: root.isZoneFocused ? Theme.neonAquaBright : Theme.chromeMid

            Rectangle {
                anchors.centerIn: parent
                width: parent.width + Theme.px(8)
                height: parent.height + Theme.px(6)
                radius: Theme.radiusSM
                color: "transparent"
                border.color: Theme.neonAqua
                border.width: Theme.px(1)
                opacity: root.isZoneFocused ? 0.8 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: Theme.animFast }
                }
            }
        }

        // Lens Aperture Glass Frame
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(130)
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(16)
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            radius: Theme.radiusMD
            color: root.isZoneFocused ? Theme.surfacePlateRaised : Theme.surfacePlate
            border.color: root.isZoneFocused ? Theme.neonAqua : Theme.chromeDark
            border.width: Theme.px(2)

            Behavior on border.color {
                ColorAnimation { duration: Theme.animFast }
            }
        }
    }

    // 3. ROTATING CATEGORY ITEMS
    Item {
        id: itemsContainer
        anchors.fill: parent

        Repeater {
            model: root.model

            delegate: Item {
                id: dialItem
                width: root.width
                height: Theme.px(80)

                readonly property int indexOffset: index - root.currentIndex
                readonly property bool isSelected: index === root.currentIndex

                x: {
                    var dist = Math.abs(indexOffset);
                    if (dist === 0) return Theme.px(28);
                    if (dist === 1) return Theme.px(14);
                    return Theme.px(0);
                }

                y: (root.height / 2) - (height / 2) + (indexOffset * Theme.px(110))

                scale: isSelected ? (root.isZoneFocused ? 1.08 : 1.02) : Math.max(0.80, 1.0 - (Math.abs(indexOffset) * 0.15))
                opacity: isSelected ? 1.0 : Math.max(0.30, 0.80 - (Math.abs(indexOffset) * 0.25))
                z: isSelected ? 10 : (5 - Math.abs(indexOffset))

                Behavior on y {
                    NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic }
                }
                Behavior on x {
                    NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
                }
                Behavior on opacity {
                    NumberAnimation { duration: Theme.animFast }
                }

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.px(150)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.px(14)

                    Text {
                        text: "0" + (index + 1)
                        color: dialItem.isSelected ? (root.isZoneFocused ? Theme.neonAqua : Theme.chromeHighlight) : Theme.textDisabled
                        font.pixelSize: Theme.fontCaption
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: modelData
                        color: dialItem.isSelected ? (root.isZoneFocused ? Theme.textPrimary : Theme.chromeBright) : Theme.textSecondary
                        font.pixelSize: dialItem.isSelected ? Theme.fontSection : Theme.fontBody
                        font.bold: dialItem.isSelected
                        font.letterSpacing: dialItem.isSelected ? 1.5 : 0.5
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.currentIndex = index
                        root.forceActiveFocus()
                        root.itemSelected(index)
                    }
                }
            }
        }
    }
}
