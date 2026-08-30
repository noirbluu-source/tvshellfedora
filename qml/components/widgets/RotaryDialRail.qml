import QtQuick
import TVShell

FocusScope {
    id: root

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

    // =========================================================================
    // D-PAD ROTARY KEY HANDLER
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

    // =========================================================================
    // 1. MECHANICAL BEZEL & CHROME ARC TRACK
    // =========================================================================
    Item {
        anchors.fill: parent
        clip: false

        // Outer Dark Steel Flange
        Rectangle {
            x: -Theme.px(260)
            y: 0
            width: Theme.px(420)
            height: parent.height
            radius: Theme.radiusLG
            color: Theme.concreteChassis
            border.color: Theme.chromeDark
            border.width: Theme.px(2)

            // Inner Bevel Highlight
            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: Theme.px(2)
                color: Theme.bevelLight
            }
        }

        // Circular Chrome Dial Rotor Arc (Visible half-ring)
        Rectangle {
            x: -Theme.px(440)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(700)
            height: Theme.px(700)
            radius: width / 2
            color: Theme.smokedGlassDeep
            border.color: root.isZoneFocused ? Theme.neonPurple : Theme.chromeDark
            border.width: Theme.px(4)

            Behavior on border.color {
                ColorAnimation { duration: Theme.animFast }
            }

            // Outer Machined Chamfer
            Rectangle {
                anchors.fill: parent
                anchors.margins: Theme.px(6)
                radius: width / 2
                color: "transparent"
                border.color: Theme.bevelLightSharp
                border.width: Theme.px(1)
                opacity: 0.5
            }

            // Radial Halftone Notches / Calibration Ticks
            Canvas {
                id: dialTicks
                anchors.fill: parent
                renderTarget: Canvas.FramebufferObject

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    var cx = width / 2;
                    var cy = height / 2;
                    var r = width / 2 - Theme.px(14);

                    ctx.lineWidth = Theme.px(2);
                    for (var a = -70; a <= 70; a += 10) {
                        var rad = a * Math.PI / 180.0;
                        var isMajor = (a % 20 === 0);
                        var tickLen = isMajor ? Theme.px(18) : Theme.px(10);
                        
                        var x1 = cx + (r - tickLen) * Math.cos(rad);
                        var y1 = cy + (r - tickLen) * Math.sin(rad);
                        var x2 = cx + r * Math.cos(rad);
                        var y2 = cy + r * Math.sin(rad);

                        ctx.strokeStyle = isMajor ? "rgba(220, 229, 237, 0.45)" : "rgba(143, 163, 181, 0.20)";
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
    // 2. ACTIVE SELECTION LENS & INDICATOR NEEDLE
    // =========================================================================
    Item {
        id: centerLens
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Theme.px(110)
        z: 5

        // Glowing Holographic Pointer Needle (Projecting into active item)
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(100)
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(28)
            height: Theme.px(6)
            radius: Theme.radiusSharp
            color: root.isZoneFocused ? Theme.neonAqua : Theme.chromeMid

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Theme.neonPurple }
                GradientStop { position: 1.0; color: root.isZoneFocused ? Theme.neonAquaBright : Theme.chromeBright }
            }

            // Active Needle Glow Flare
            Rectangle {
                anchors.centerIn: parent
                width: parent.width + Theme.px(14)
                height: parent.height + Theme.px(12)
                radius: Theme.radiusSM
                color: "transparent"
                border.color: Theme.neonAquaGlow
                border.width: Theme.px(3)
                opacity: root.isZoneFocused ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: Theme.animFast }
                }
            }
        }

        // Lens Aperture Glass Frame (Highlights the focused category item)
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Theme.px(124)
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(20)
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            radius: Theme.radiusMD
            color: root.isZoneFocused ? Theme.smokedGlassBg : "transparent"
            border.color: root.isZoneFocused ? Theme.neonAqua : "transparent"
            border.width: Theme.px(2)

            // Specular Lens Glass Reflection
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.45
                radius: Theme.radiusMD
                color: Theme.liquidGelSurface
                opacity: root.isZoneFocused ? 0.8 : 0.0
            }

            Behavior on border.color {
                ColorAnimation { duration: Theme.animFast }
            }
        }
    }

    // =========================================================================
    // 3. ROTATING CATEGORY ITEMS (Arc Projection & Radial Falloff)
    // =========================================================================
    Item {
        id: itemsContainer
        anchors.fill: parent

        Repeater {
            model: root.model

            delegate: Item {
                id: dialItem
                width: root.width
                height: Theme.px(90)

                readonly property int indexOffset: index - root.currentIndex
                readonly property bool isSelected: index === root.currentIndex

                // Radial curved offset calculation:
                // Items curve outwards along an arc as they approach the center lens
                x: {
                    var dist = Math.abs(indexOffset);
                    if (dist === 0) return Theme.px(36);
                    if (dist === 1) return Theme.px(18);
                    if (dist === 2) return Theme.px(4);
                    return -Theme.px(10);
                }

                y: (root.height / 2) - (height / 2) + (indexOffset * Theme.px(120))

                // Radial Angular Scale & Opacity Falloff
                scale: isSelected ? (root.isZoneFocused ? 1.12 : 1.05) : Math.max(0.78, 1.0 - (Math.abs(indexOffset) * 0.14))
                opacity: isSelected ? 1.0 : Math.max(0.25, 0.85 - (Math.abs(indexOffset) * 0.30))
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

                // Item Container
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.px(146)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.px(16)

                    // Index Digital Counter
                    Text {
                        text: "0" + (index + 1)
                        color: dialItem.isSelected ? (root.isZoneFocused ? Theme.neonAqua : Theme.chromeHighlight) : Theme.textDisabled
                        font.pixelSize: Theme.fontCaption
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Category Name
                    Text {
                        text: modelData
                        color: dialItem.isSelected ? (root.isZoneFocused ? Theme.textPrimary : Theme.chromeBright) : Theme.textSecondary
                        font.pixelSize: dialItem.isSelected ? Theme.fontSection : Theme.fontBody
                        font.bold: dialItem.isSelected
                        font.letterSpacing: dialItem.isSelected ? 1.5 : 0.5
                        anchors.verticalCenter: parent.verticalCenter

                        style: dialItem.isSelected && root.isZoneFocused ? Text.Outline : Text.Normal
                        styleColor: Theme.neonPurple
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
