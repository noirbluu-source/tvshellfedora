import QtQuick
import TVShell

Item {
    id: root

    property string labelText: "ACTION"
    property string glyph: ""
    property bool isCurrent: false
    property bool isPressed: false
    property bool isBrass: true
    signal clicked()

    implicitWidth: Theme.px(180)
    implicitHeight: Theme.px(64)

    // Outer Recessed Mounting Socket (Dark debossed cavity)
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusSM
        color: Theme.surfaceRecessed
        border.color: Theme.bevelDarkDeep
        border.width: Theme.px(2)

        // Socket Rim Highlight (Simulating metal bevel)
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.px(1)
            color: Theme.bevelLight
            opacity: 0.3
        }
    }

    // Physical Raised Button Cap
    Item {
        id: buttonCap
        anchors.fill: parent
        anchors.margins: root.isPressed ? Theme.px(4) : Theme.px(2)

        // 1. Holographic / Mercury Halo on Focus
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.px(6)
            radius: Theme.radiusSM + Theme.px(4)
            color: "transparent"
            border.width: Theme.px(3)
            border.color: Theme.neonAqua
            opacity: root.isCurrent ? 0.9 : 0.0

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Theme.neonAquaBright }
                GradientStop { position: 0.5; color: Theme.neonPink }
                GradientStop { position: 1.0; color: Theme.neonPurpleBright }
            }

            Behavior on opacity {
                NumberAnimation { duration: Theme.animFast }
            }
        }

        // 2. Button Body Material (Brass vs Brushed Dark Metal)
        Rectangle {
            id: capBody
            anchors.fill: parent
            radius: Theme.radiusSM
            color: root.isBrass ? Theme.brassMid : Theme.surfacePlateRaised

            gradient: Gradient {
                orientation: Gradient.Vertical
                // Top Highlight
                GradientStop {
                    position: 0.0
                    color: root.isCurrent
                           ? (root.isBrass ? Theme.brassHighlight : Theme.chromeHighlight)
                           : (root.isBrass ? Theme.brassPrimary : Theme.chromeMid)
                }
                // Mid Surface
                GradientStop {
                    position: 0.45
                    color: root.isBrass ? Theme.brassMid : Theme.surfacePlate
                }
                // Deep Bottom Chamfer
                GradientStop {
                    position: 1.0
                    color: root.isCurrent
                           ? (root.isBrass ? Theme.brassShadow : Theme.neonPurple)
                           : (root.isBrass ? Theme.brassRecessed : Theme.chromeShadow)
                }
            }

            // Top-Left Incident Bevel (45-degree Specular Light)
            Rectangle {
                anchors.fill: parent
                radius: Theme.radiusSM
                color: "transparent"
                border.width: Theme.px(1)
                border.color: root.isBrass ? Theme.brassHighlight : Theme.chromeBright
                opacity: root.isCurrent ? 0.9 : 0.45
            }

            // Button Label & Glyph
            Row {
                anchors.centerIn: parent
                spacing: Theme.px(8)

                Text {
                    visible: root.glyph.length > 0
                    text: root.glyph
                    color: root.isBrass ? Theme.textInverse : (root.isCurrent ? Theme.chromeHighlight : Theme.textPrimary)
                    font.pixelSize: Theme.fontBody
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: root.labelText
                    color: root.isBrass ? Theme.textInverse : (root.isCurrent ? Theme.chromeHighlight : Theme.textPrimary)
                    font.pixelSize: Theme.fontCaption
                    font.bold: true
                    font.letterSpacing: 1.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // Physical Elevation & Press Transforms
    scale: root.isPressed ? Theme.pressedScale : (root.isCurrent ? Theme.focusScaleButton : 1.0)
    z: root.isCurrent ? 5 : 1

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
