import QtQuick
import TVShell

FocusScope {
    id: root

    property var itemsModel: [
        { label: "LAUNCHER", symbol: "✦" },
        { label: "MEDIA",    symbol: "▶" },
        { label: "CONSOLE",  symbol: "▲" },
        { label: "STORAGE",  symbol: "📁" },
        { label: "SYSTEM",   symbol: "⚙" }
    ]

    property int currentIndex: 0
    readonly property int count: itemsModel.length
    readonly property bool isZoneFocused: FocusManager.currentZone === FocusManager.Zone.RotaryMenu

    signal itemActivated(int index)

    implicitWidth: Theme.px(640)
    implicitHeight: Theme.px(940)

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

    // =========================================================================
    // D-PAD ROTATIONAL NAVIGATION
    // =========================================================================
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
            root.itemActivated(currentIndex)
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

    // =========================================================================
    // 1. PARTIALLY HIDDEN CIRCULAR CHASSIS & MACHINED DIAL
    // =========================================================================
    Item {
        anchors.fill: parent

        // Main Heavy Rotor Disk (Anchored 50% past the left bezel)
        Rectangle {
            id: mainRotorDisk
            x: -Theme.px(540)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(960)
            height: Theme.px(960)
            radius: width / 2
            color: Theme.concreteChassis
            border.width: Theme.px(6)
            border.color: root.isZoneFocused ? Theme.neonAcidGreen : Theme.chromeDark

            Behavior on border.color {
                ColorAnimation { duration: Theme.animFast }
            }

            // Concentric Machined Metal Groove (Audio Turntable Track)
            Rectangle {
                anchors.fill: parent
                anchors.margins: Theme.px(24)
                radius: width / 2
                color: Theme.bgConcreteDark
                border.width: Theme.px(2)
                border.color: Theme.bevelLight
                opacity: 0.65

                // Inner Smoked Acrylic Track Cavity
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: Theme.px(48)
                    radius: width / 2
                    color: Theme.surfaceRecessed
                    border.width: Theme.px(1)
                    border.color: Theme.chromeDark
                }
            }

            // High-Precision Machined Calibration Ticks
            Canvas {
                id: tickMarks
                anchors.fill: parent
                renderTarget: Canvas.FramebufferObject

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    var cx = width / 2;
                    var cy = height / 2;
                    var r = width / 2 - Theme.px(16);

                    ctx.lineWidth = Theme.px(2);
                    for (var a = -80; a <= 80; a += 5) {
                        var rad = a * Math.PI / 180.0;
                        var isMajor = (a % 20 === 0);
                        var isSemi = (a % 10 === 0);
                        var tickLen = isMajor ? Theme.px(22) : (isSemi ? Theme.px(14) : Theme.px(8));

                        var x1 = cx + (r - tickLen) * Math.cos(rad);
                        var y1 = cy + (r - tickLen) * Math.sin(rad);
                        var x2 = cx + r * Math.cos(rad);
                        var y2 = cy + r * Math.sin(rad);

                        ctx.strokeStyle = isMajor
                            ? "rgba(57, 255, 20, 0.70)"
                            : (isSemi ? "rgba(220, 229, 237, 0.45)" : "rgba(143, 163, 181, 0.15)");
                        ctx.beginPath();
                        ctx.moveTo(x1, y1);
                        ctx.lineTo(x2, y2);
                        ctx.stroke();
                    }
                }
            }
        }
    }

    // =========================================================================
    // 2. CENTER SELECTION LENS & EMISSION PROJECTION NEEDLE
    // =========================================================================
    Item {
        id: centerLens
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Theme.px(140)
        z: 10

        // Hardware Needle Projection Bar (Pointing directly into the active item)
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(240)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(42)
            height: Theme.px(8)
            radius: Theme.radiusSharp
            color: root.isZoneFocused ? Theme.neonAcidGreenBright : Theme.chromeMid

            // Neon Halo flare
            Rectangle {
                anchors.centerIn: parent
                width: parent.width + Theme.px(16)
                height: parent.height + Theme.px(14)
                radius: Theme.radiusSM
                color: "transparent"
                border.color: Theme.neonAcidGreen
                border.width: Theme.px(2)
                opacity: root.isZoneFocused ? 0.95 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: Theme.animFast }
                }
            }
        }

        // Active Category Readout Plaque
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(400)
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(16)
            anchors.verticalCenter: parent.verticalCenter
            height: Theme.px(64)
            radius: Theme.radiusSM
            color: root.isZoneFocused ? Theme.surfacePlateRaised : Theme.surfacePlate
            border.width: Theme.px(2)
            border.color: root.isZoneFocused ? Theme.neonAcidGreen : Theme.chromeDark

            // Machined Top-Left Chamfer
            Rectangle {
                anchors.fill: parent
                radius: Theme.radiusSM
                color: "transparent"
                border.width: Theme.px(1)
                border.color: Theme.bevelLight
                opacity: 0.6
            }

            // High-Contrast Category Label
            Text {
                anchors.centerIn: parent
                text: root.itemsModel[root.currentIndex].label
                color: root.isZoneFocused ? Theme.textPrimary : Theme.chromeBright
                font.pixelSize: Theme.fontSection
                font.bold: true
                font.letterSpacing: 2.5
            }
        }
    }

    // =========================================================================
    // 3. CIRCULAR ARC TRACK (5 Tactile Bubble Icons)
    // =========================================================================
    Item {
        id: iconsTrack
        anchors.fill: parent

        Repeater {
            model: root.itemsModel

            delegate: RotaryIcon {
                id: rIcon
                symbol: modelData.symbol
                label: modelData.label
                isSelected: (index === root.currentIndex)
                isZoneFocused: root.isZoneFocused

                // Angular spacing: 24 degrees between items along the arc
                readonly property real itemAngle: (index - root.currentIndex) * 24.0
                readonly property real rad: itemAngle * Math.PI / 180.0
                readonly property real radiusPx: Theme.px(440)

                // Trigonometric trajectory mapped from left-center dial origin
                x: -Theme.px(100) + (radiusPx * Math.cos(rad)) - (width / 2)
                y: (root.height / 2) + (radiusPx * Math.sin(rad)) - (height / 2)

                Behavior on x {
                    NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic }
                }
                Behavior on y {
                    NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.currentIndex = index
                        root.forceActiveFocus()
                        root.itemActivated(index)
                    }
                }
            }
        }
    }
}
