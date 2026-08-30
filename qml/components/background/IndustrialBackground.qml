import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    // Base Deep Void
    Rectangle {
        anchors.fill: parent
        color: Theme.bgDark
    }

    // Industrial Cast Concrete Gradient (Subtle vertical lighting)
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Theme.bgConcrete }
            GradientStop { position: 0.5; color: Theme.bgDark }
            GradientStop { position: 1.0; color: "#060709" }
        }
    }

    // Heavy Radial Vignette (Corners fall off into deep pitch black)
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Radial
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.65; color: "#40000000" }
            GradientStop { position: 1.0; color: "#EE000000" }
        }
    }

    // Industrial Bevel Border Framing (Hardware Display Enclosure)
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.bevelDark
        border.width: Theme.px(2)

        // Top-Left Inset Highlight
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Theme.px(1)
            color: Theme.bevelLight
        }

        // Left Inset Highlight
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Theme.px(1)
            color: Theme.bevelLight
        }
    }
}
