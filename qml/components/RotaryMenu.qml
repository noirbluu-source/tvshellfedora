import QtQuick
import TVShell

FocusScope {
    id: root

    // 5 Application Categories / Quick Apps
    property var itemsModel: [
        { label: "ALL APPS", symbol: "✦" },
        { label: "MEDIA", symbol: "▶" },
        { label: "CONSOLE", symbol: "▲" },
        { label: "STORAGE", symbol: "📁" },
        { label: "SYSTEM", symbol: "⚙" }
    ]

    property int currentIndex: 0
    readonly property int count: itemsModel.length
    readonly property bool isZoneFocused: FocusManager.currentZone === FocusManager.Zone.RotaryMenu

    signal itemActivated(int index)

    implicitWidth: Theme.px(560)
    implicitHeight: Theme.px(860)

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
    // D-PAD ROTATION HANDLER
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
    // 1. MECHANICAL STRUCTURE & HALF-VISIBLE CHROME DIAL RING
    // =========================================================================
    Item {
        anchors.fill: parent

        // Outer Dark Structural Ring
        Rectangle {
            x: -Theme.px(440)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(740)
            height: Theme.px(740)
            radius: width / 2
            color: Theme.smokedGlassDeep
            border.width: Theme.px(4)
            border.color: root.isZoneFocused ? Theme.neonPurple : Theme.chromeDark

            Behavior on border.color {
                ColorAnimation { duration: Theme.animFast }
            }

            // Inner Machined Bevel Ring
            Rectangle {
                anchors.fill: parent
                anchors.margins: Theme.px(10)
                radius: width / 2
                color: "transparent"
                border.width: Theme.px(1)
                border.color: Theme.bevelLightSharp
                opacity: 0.4
            }

            // Radial Calibration Tick Marks
            Canvas {
                id: tickMarks
                anchors.fill: parent
                renderTarget: Canvas.FramebufferObject

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    var cx = width / 2;
                    var cy = height / 2;
                    var r = width / 2 - Theme.px(14);

                    ctx.lineWidth = Theme.px(2);
                    for (var a = -75; a <= 75; a += 7.5) {
                        var rad = a * Math.PI / 180.0;
                        var isMajor = (Math.abs(a % 15) < 0.1);
                        var tickLen = isMajor ? Theme.px(16) : Theme.px(8);

                        var x1 = cx + (r - tickLen) * Math.cos(rad);
                        var y1 = cy + (r - tickLen) * Math.sin(rad);
                        var x2 = cx + r * Math.cos(rad);
                        var y2 = cy + r * Math.sin(rad);

                        ctx.strokeStyle = isMajor ? "rgba(0, 245, 212, 0.45)" : "rgba(143, 163, 181, 0.20)";
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
    // 2. ACTIVE CENTER INDICATOR NEEDLE & MAGNIFICATION LENS
    // =========================================================================
    Item {
        id: centerLens
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Theme.px(120)
        z: 4

        // Glowing Mechanical Indicator Needle
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(175)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(30)
            height: Theme.px(6)
            radius: Theme.radiusSharp
            color: root.isZoneFocused ? Theme.neonAquaBright : Theme.chromeMid

            // Neon Halo on Focus
            Rectangle {
                anchors.centerIn: parent
                width: parent.width + Theme.px(12)
                height: parent.height + Theme.px(10)
                radius: Theme.radiusSM
                color: "transparent"
                border.color: Theme.neonAqua
                border.width: Theme.px(2)
                opacity: root.isZoneFocused ? 0.9 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: Theme.animFast }
                }
            }
        }

        // Active Label Callout Frame
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(310)
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(10)
            anchors.verticalCenter: parent.verticalCenter
            height: Theme.px(54)
            radius: Theme.radiusSM
            color: root.isZoneFocused ? Theme.surfacePlateRaised : Theme.surfacePlate
            border.width: Theme.px(2)
            border.color: root.isZoneFocused ? Theme.neonAqua : Theme.chromeDark

            // Active Category Label
            Text {
                anchors.centerIn: parent
                text: root.itemsModel[root.currentIndex].label
                color: root.isZoneFocused ? Theme.textPrimary : Theme.chromeBright
                font.pixelSize: Theme.fontBody
                font.bold: true
                font.letterSpacing: 2
            }
        }
    }

    // =========================================================================
    // 3. 5 PHYSICAL ROTARY ICONS POSITIONED ALONG CIRCULAR ARC
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

                // Angular displacement calculation:
                // Spacing angle is 28 degrees between items
                readonly property real itemAngle: (index - root.currentIndex) * 28.0
                readonly property real rad: itemAngle * Math.PI / 180.0
                readonly property real radiusPx: Theme.px(320)

                // Arc path positioning relative to dial origin
                x: -Theme.px(70) + (radiusPx * Math.cos(rad)) - (width / 2)
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
