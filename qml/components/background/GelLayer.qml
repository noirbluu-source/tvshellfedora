import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    // Liquid Purple / Violet Pool (Top-Left under Rotary Menu)
    Rectangle {
        x: -Theme.px(200)
        y: -Theme.px(200)
        width: Theme.px(1200)
        height: Theme.px(1200)
        radius: width / 2
        opacity: 0.18
        gradient: Gradient {
            orientation: Gradient.Radial
            GradientStop { position: 0.0; color: Theme.neonPurpleBright }
            GradientStop { position: 0.45; color: Theme.neonPurple }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // Cyber Aqua Light Pool (Center App Shelf Ambience)
    Rectangle {
        x: parent.width * 0.45 - (width / 2)
        y: parent.height * 0.4 - (height / 2)
        width: Theme.px(1400)
        height: Theme.px(900)
        radius: width / 2
        opacity: 0.14
        gradient: Gradient {
            orientation: Gradient.Radial
            GradientStop { position: 0.0; color: Theme.neonAquaBright }
            GradientStop { position: 0.5; color: Theme.neonAqua }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // Hot Neon Pink Specular Pool (Bottom Right corner)
    Rectangle {
        x: parent.width - Theme.px(800)
        y: parent.height - Theme.px(700)
        width: Theme.px(1100)
        height: Theme.px(1100)
        radius: width / 2
        opacity: 0.12
        gradient: Gradient {
            orientation: Gradient.Radial
            GradientStop { position: 0.0; color: Theme.neonPinkBright }
            GradientStop { position: 0.4; color: Theme.neonPink }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // Top Gloss Arc Reflection (Simulating curved acrylic glass face)
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.px(400)
        opacity: 0.06
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Theme.chromeHighlight }
            GradientStop { position: 0.3; color: Theme.neonAqua }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }
}
