import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    property bool active: false
    property real cornerRadius: Theme.radiusMD
    property real glowSpread: Theme.px(12)

    // Outer Diffuse Glow Halo (Aqua/Pink/Purple chromatic dispersion)
    Rectangle {
        anchors.fill: parent
        anchors.margins: -root.glowSpread
        radius: root.cornerRadius + root.glowSpread
        color: "transparent"
        opacity: root.active ? 0.75 : 0.0
        border.width: Theme.px(6)
        border.color: Theme.neonAqua

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: Theme.neonAqua }
            GradientStop { position: 0.35; color: Theme.neonPink }
            GradientStop { position: 0.70; color: Theme.neonPurple }
            GradientStop { position: 1.00; color: Theme.chromeBright }
        }

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
        }
    }

    // High-Intensity Focused Inner Rim (Crisp 10-foot TV Edge)
    Rectangle {
        anchors.fill: parent
        anchors.margins: -Theme.px(2)
        radius: root.cornerRadius + Theme.px(2)
        color: "transparent"
        opacity: root.active ? 1.0 : 0.0
        border.width: Theme.px(3)
        border.color: Theme.chromeHighlight

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: Theme.neonAquaBright }
            GradientStop { position: 0.40; color: Theme.neonPinkBright }
            GradientStop { position: 0.75; color: Theme.neonPurpleBright }
            GradientStop { position: 1.00; color: Theme.chromeHighlight }
        }

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
        }
    }

    // Dynamic Sheen Sweep on Initial Focus
    Rectangle {
        id: sheenSweep
        width: parent.width * 0.35
        height: parent.height * 2
        y: -parent.height * 0.5
        rotation: 25
        opacity: 0.0
        clip: true

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: "rgba(255, 255, 255, 0.45)" }
            GradientStop { position: 1.0; color: "transparent" }
        }

        SequentialAnimation {
            id: sweepAnim
            NumberAnimation { target: sheenSweep; property: "opacity"; from: 0.0; to: 0.8; duration: 40 }
            NumberAnimation { target: sheenSweep; property: "x"; from: -sheenSweep.width; to: root.width + sheenSweep.width; duration: 280; easing.type: Easing.OutCubic }
            NumberAnimation { target: sheenSweep; property: "opacity"; to: 0.0; duration: 60 }
        }
    }

    onActiveChanged: {
        if (active) {
            sweepAnim.restart()
        }
    }
}
