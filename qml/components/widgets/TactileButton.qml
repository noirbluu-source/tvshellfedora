import QtQuick
import TVShell

Item {
    id: root

    property string labelText: "ACTION"
    property string glyph: ""
    property bool isCurrent: false
    property bool isPressed: false
    signal clicked()

    implicitWidth: Theme.px(170)
    implicitHeight: Theme.px(64)

    // =========================================================================
    // 1. RECESSED MOUNTING SOCKET (Dark Glass / Acrylic Cavity)
    // =========================================================================
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusSM
        color: Theme.surfaceRecessed
        border.color: Theme.bevelDarkDeep
        border.width: Theme.px(2)

        // Lower socket bevel highlight
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.px(1)
            color: Theme.bevelLight
            opacity: 0.35
        }
    }

    // =========================================================================
    // 2. HOLOGRAPHIC FOCUS FRAME & VOLUMETRIC GLOW
    // =========================================================================
    Rectangle {
        id: holoAura
        anchors.fill: parent
        anchors.margins: -Theme.px(6)
        radius: Theme.radiusSM + Theme.px(4)
        color: "transparent"
        border.width: Theme.px(3)
        opacity: root.isCurrent ? 0.95 : 0.0

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: Theme.neonPinkBright }
            GradientStop { position: 0.35; color: Theme.neonAquaBright }
            GradientStop { position: 0.70; color: Theme.neonPurpleBright }
            GradientStop { position: 1.00; color: Theme.chromeHighlight }
        }

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
        }
    }

    // =========================================================================
    // 3. PHYSICAL BUTTON CAP (Raw Brass <---> Liquid Mercury Transformation)
    // =========================================================================
    Item {
        id: buttonCap
        anchors.fill: parent
        anchors.margins: root.isPressed ? Theme.px(5) : Theme.px(3)

        // Core Cap Body
        Rectangle {
            id: capBody
            anchors.fill: parent
            radius: Theme.radiusSM
            color: root.isCurrent ? Theme.chromeHighlight : Theme.brassPrimary

            // Material Gradient Switch (Machined Raw Brass -> Glossy Liquid Mercury)
            gradient: Gradient {
                orientation: Gradient.Vertical
                // Top Specular Highlight
                GradientStop {
                    position: 0.00
                    color: root.isCurrent ? "#FFFFFF" : "#FFF2C4"
                }
                // Mid Convex Body
                GradientStop {
                    position: 0.45
                    color: root.isCurrent ? "#D0DCE5" : "#C8963E"
                }
                // Lower Bevel Shadow
                GradientStop {
                    position: 1.00
                    color: root.isCurrent ? "#5A6E82" : "#604212"
                }
            }

            // Top-Left Incident 45-degree Bevel (Specular Chamfer)
            Rectangle {
                anchors.fill: parent
                radius: Theme.radiusSM
                color: "transparent"
                border.width: root.isCurrent ? Theme.px(2) : Theme.px(1)
                border.color: root.isCurrent ? Theme.chromeHighlight : Theme.brassHighlight
                opacity: root.isCurrent ? 1.0 : 0.65
            }

            // =================================================================
            // 4. ANIMATED LIQUID MERCURY SHIMMER (Continuous wave when focused)
            // =================================================================
            Item {
                anchors.fill: parent
                clip: true
                visible: root.isCurrent

                Rectangle {
                    id: mercuryShimmer
                    width: parent.width * 0.4
                    height: parent.height * 2.5
                    y: -parent.height * 0.75
                    x: -width * 1.5
                    rotation: 20
                    opacity: 0.0

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.5; color: Qt.rgba(1.0, 1.0, 1.0, 0.65) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }

                    SequentialAnimation {
                        id: shimmerLoop
                        running: root.isCurrent
                        loops: Animation.Infinite
                        PauseAnimation { duration: 400 }
                        NumberAnimation { target: mercuryShimmer; property: "opacity"; from: 0.0; to: 0.9; duration: 40 }
                        NumberAnimation { target: mercuryShimmer; property: "x"; from: -mercuryShimmer.width * 1.2; to: buttonCap.width + mercuryShimmer.width; duration: 380; easing.type: Easing.InOutCubic }
                        NumberAnimation { target: mercuryShimmer; property: "opacity"; to: 0.0; duration: 60 }
                        PauseAnimation { duration: 1800 }
                    }
                }
            }

            // =================================================================
            // 5. BUTTON GLYPH & HIGH-CONTRAST LABEL
            // =================================================================
            Row {
                anchors.centerIn: parent
                spacing: Theme.px(10)

                Text {
                    visible: root.glyph.length > 0
                    text: root.glyph
                    color: root.isCurrent ? Theme.bgVoid : Theme.brassRecessed
                    font.pixelSize: Theme.px(26)
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: root.labelText
                    color: root.isCurrent ? Theme.bgVoid : Theme.brassRecessed
                    font.pixelSize: Theme.fontCaption
                    font.bold: true
                    font.letterSpacing: 2
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // =========================================================================
    // 6. TACTILE ELEVATION & DEPRESSION DYNAMICS
    // =========================================================================
    scale: root.isPressed ? Theme.pressedScale : (root.isCurrent ? Theme.focusScaleButton : 1.0)
    z: root.isCurrent ? 15 : 1

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
        onClicked: root.clicked()
    }
}
