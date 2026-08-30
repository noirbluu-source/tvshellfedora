import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent
    clip: true
    visible: root.active || opacity > 0.0
    opacity: root.active ? 1.0 : 0.0

    property bool active: false
    property real cornerRadius: Theme.radiusMD

    Behavior on opacity {
        NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
    }

    // Outer Spectral Halo (Pink -> Aqua -> Violet -> Chrome)
    Rectangle {
        anchors.fill: parent
        radius: root.cornerRadius
        color: "transparent"
        border.width: Theme.px(4)

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: Theme.neonPink }
            GradientStop { position: 0.35; color: Theme.neonAqua }
            GradientStop { position: 0.70; color: Theme.neonPurple }
            GradientStop { position: 1.00; color: Theme.chromeBright }
        }
    }

    // Inner Specular Rim
    Rectangle {
        anchors.fill: parent
        anchors.margins: Theme.px(2)
        radius: Math.max(0, root.cornerRadius - Theme.px(2))
        color: "transparent"
        border.width: Theme.px(2)

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: Theme.neonPinkBright }
            GradientStop { position: 0.40; color: Theme.neonAquaBright }
            GradientStop { position: 0.75; color: Theme.neonPurpleBright }
            GradientStop { position: 1.00; color: Theme.chromeHighlight }
        }
    }

    // Sheen Sweep
    Item {
        anchors.fill: parent
        clip: true

        Rectangle {
            id: sheenSweep
            width: root.width * 0.35
            height: root.height * 3.0
            y: -root.height * 0.9
            x: -width * 1.5
            rotation: 25
            opacity: 0.0

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: Qt.rgba(1.0, 1.0, 1.0, 0.45) }
                GradientStop { position: 1.0; color: "transparent" }
            }

            SequentialAnimation {
                id: sweepAnim
                NumberAnimation { target: sheenSweep; property: "opacity"; from: 0.0; to: 0.85; duration: 40 }
                NumberAnimation { target: sheenSweep; property: "x"; from: -sheenSweep.width * 1.2; to: root.width + sheenSweep.width; duration: 260; easing.type: Easing.OutCubic }
                NumberAnimation { target: sheenSweep; property: "opacity"; to: 0.0; duration: 50 }
            }
        }
    }

    onActiveChanged: {
        if (active) {
            sweepAnim.restart()
        }
    }
}
