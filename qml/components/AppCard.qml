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

    implicitWidth: Theme.px(860)
    implicitHeight: Theme.px(136)

    // =========================================================================
    // STAGE 2 & 6: CONTRAST SUPPRESSION BED & DEEP NEUMORPHIC SHADOW
    // =========================================================================
    Rectangle {
        id: depthShadow
        anchors.fill: parent
        anchors.topMargin: root.isCurrent ? Theme.px(10) : Theme.px(4)
        anchors.leftMargin: -Theme.px(4)
        anchors.rightMargin: -Theme.px(4)
        anchors.bottomMargin: root.isCurrent ? -Theme.px(12) : -Theme.px(4)
        radius: Theme.radiusMD + Theme.px(4)
        color: Theme.bgVoid
        opacity: root.isCurrent ? 0.95 : 0.40

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast }
        }
    }

    // =========================================================================
    // STAGE 5: DIFFUSE PERIMETER AURA & EDGE GLOW
    // =========================================================================
    Rectangle {
        id: edgeGlow
        anchors.fill: parent
        anchors.margins: -Theme.px(10)
        radius: Theme.radiusMD + Theme.px(6)
        color: "transparent"
        border.width: Theme.px(6)
        border.color: Theme.neonAqua
        opacity: root.isCurrent ? 0.70 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
        }
    }

    // =========================================================================
    // STAGE 3: BRUTALIST CHASSIS BASE WITH STRENGTHENED CHROME BEVELS
    // =========================================================================
    Rectangle {
        id: chassisBase
        anchors.fill: parent
        radius: Theme.radiusMD
        color: root.isCurrent ? Theme.surfacePlateRaised : Theme.surfacePlate

        // Outer Structural Machined Frame
        border.width: root.isCurrent ? Theme.px(4) : Theme.px(2)
        border.color: root.isCurrent ? Theme.chromeHighlight : Theme.chromeDark

        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }
        Behavior on color {
            ColorAnimation { duration: Theme.animFast }
        }

        // Top/Left Incident Chrome Bezel (45-degree Specular Chamfer)
        Rectangle {
            anchors.fill: parent
            radius: Theme.radiusMD
            color: "transparent"
            border.width: root.isCurrent ? Theme.px(2) : Theme.px(1)
            border.color: root.isCurrent ? Theme.chromeHighlight : Theme.bevelLight
            opacity: root.isCurrent ? 1.0 : 0.35
        }

        // Inner Gel & Smoked Acrylic Core
        Rectangle {
            anchors.fill: parent
            anchors.margins: Theme.px(3)
            radius: Math.max(0, Theme.radiusMD - Theme.px(3))
            color: root.isCurrent ? Theme.gelAcidGreenTranslucent : Theme.surfaceRecessed
            opacity: root.isCurrent ? 0.90 : 0.95

            // Top Specular Glass Lip Reflection
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height * 0.45
                radius: Math.max(0, Theme.radiusMD - Theme.px(3))
                color: Qt.rgba(1.0, 1.0, 1.0, root.isCurrent ? 0.18 : 0.03)
            }
        }

        // Halftone Matrix Tech Decal (Right Side)
        Canvas {
            id: halftoneDecal
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: Theme.px(12)
            width: Theme.px(140)
            opacity: root.isCurrent ? 0.65 : 0.18

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var step = Theme.px(10);
                ctx.fillStyle = root.isCurrent ? "#00F5D4" : "#8FA3B5";

                for (var x = 0; x < width; x += step) {
                    for (var y = 0; y < height; y += step) {
                        ctx.fillRect(x, y, 1.5, 1.5);
                    }
                }
            }
        }

        // Glitch Tech Striations
        Row {
            anchors.top: parent.top
            anchors.topMargin: Theme.px(6)
            anchors.right: parent.right
            anchors.rightMargin: Theme.px(24)
            spacing: Theme.px(4)
            opacity: root.isCurrent ? 0.9 : 0.2

            Repeater {
                model: 6
                Rectangle {
                    width: (index % 2 === 0) ? Theme.px(8) : Theme.px(3)
                    height: Theme.px(3)
                    color: root.isCurrent ? Theme.neonPinkBright : Theme.chromeMid
                }
            }
        }

        // Bottom/Right Deep Occlusion Chamfer (Physical 3D Drop)
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.px(3)
            radius: Theme.radiusMD
            color: root.isCurrent ? Theme.neonPurple : Theme.bevelDark
            opacity: 0.95
        }
    }

    // =========================================================================
    // STAGE 4 & 7: HOLOGRAPHIC PINK/AQUA/SILVER LIGHTING & SHEEN SWEEP
    // =========================================================================
    HolographicBorder {
        id: holoLayer
        active: root.isCurrent
        cornerRadius: Theme.radiusMD
    }

    // =========================================================================
    // 10-FOOT TV HIGH-CONTRAST TYPOGRAPHY & HARDWARE WELLS
    // =========================================================================
    Row {
        anchors.fill: parent
        anchors.leftMargin: Theme.px(24)
        anchors.rightMargin: Theme.px(24)
        spacing: Theme.px(22)

        // Left Hardware Socket Well
        Rectangle {
            id: iconSocket
            width: Theme.px(88)
            height: Theme.px(88)
            radius: Theme.radiusSM
            anchors.verticalCenter: parent.verticalCenter
            color: root.isCurrent ? Theme.surfacePlateRaised : Theme.surfaceRecessed
            border.color: root.isCurrent ? Theme.neonAquaBright : Theme.chromeDark
            border.width: Theme.px(2)

            Rectangle {
                anchors.fill: parent
                radius: Theme.radiusSM
                color: "transparent"
                border.color: root.isCurrent ? Theme.chromeHighlight : Theme.bevelLight
                border.width: Theme.px(1)
                opacity: 0.6
            }

            Text {
                anchors.centerIn: parent
                text: {
                    var t = root.itemTitle.toUpperCase();
                    if (t.indexOf("YOUTUBE") !== -1) return "▶";
                    if (t.indexOf("VLC") !== -1) return "▲";
                    if (t.indexOf("FILE") !== -1) return "📁";
                    if (t.indexOf("SETTINGS") !== -1) return "⚙";
                    if (t.indexOf("STORE") !== -1) return "✦";
                    return "■";
                }
                color: root.isCurrent ? Theme.neonAquaBright : Theme.chromeBright
                font.pixelSize: Theme.px(38)
                font.bold: true

                style: root.isCurrent ? Text.Outline : Text.Normal
                styleColor: Theme.bevelDark
            }
        }

        // Center Titles and Badges
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconSocket.width - rightWell.width - (parent.spacing * 2)
            spacing: Theme.px(4)

            Row {
                width: parent.width
                spacing: Theme.px(14)

                Text {
                    id: titleText
                    text: root.itemTitle.toUpperCase()
                    color: root.isCurrent ? Theme.textPrimary : Theme.chromeBright
                    font.pixelSize: Theme.fontTitle
                    font.bold: true
                    font.letterSpacing: 1.5
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, parent.width - (catPill.visible ? catPill.width + parent.spacing : 0))

                    style: root.isCurrent ? Text.Outline : Text.Normal
                    styleColor: Qt.rgba(0, 0, 0, 0.95)
                }

                Rectangle {
                    id: catPill
                    visible: root.itemCategory.length > 0
                    width: catLabel.implicitWidth + Theme.px(18)
                    height: catLabel.implicitHeight + Theme.px(6)
                    radius: Theme.radiusSharp
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.isCurrent ? Theme.neonPink : Theme.surfaceRecessed
                    border.color: root.isCurrent ? Theme.neonPinkBright : Theme.chromeDark
                    border.width: Theme.px(1)

                    Text {
                        id: catLabel
                        anchors.centerIn: parent
                        text: root.itemCategory.toUpperCase()
                        color: root.isCurrent ? Theme.chromeHighlight : Theme.textSecondary
                        font.pixelSize: Theme.fontMicro
                        font.bold: true
                        font.letterSpacing: 1.5
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

        // Right Directional Trigger Well
        Item {
            id: rightWell
            width: Theme.px(48)
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.centerIn: parent
                width: Theme.px(42)
                height: Theme.px(42)
                radius: Theme.radiusSM
                color: root.isCurrent ? Theme.neonAquaBright : Theme.surfaceRecessed
                border.color: root.isCurrent ? Theme.chromeHighlight : Theme.chromeDark
                border.width: Theme.px(1)

                Rectangle {
                    anchors.fill: parent
                    radius: Theme.radiusSM
                    color: "transparent"
                    border.color: Theme.bevelLight
                    border.width: Theme.px(1)
                    opacity: 0.5
                }

                Text {
                    anchors.centerIn: parent
                    text: root.itemGlyph
                    color: root.isCurrent ? Theme.textInverse : Theme.textDisabled
                    font.pixelSize: Theme.px(18)
                    font.bold: true
                }
            }
        }
    }

    // =========================================================================
    // STAGE 1: SMOOTH SCALE & ELEVATION POP
    // =========================================================================
    scale: root.isPressed ? Theme.pressedScale : (root.isCurrent ? Theme.focusScaleCard : 1.0)
    z: root.isCurrent ? 25 : 1

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
