import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    property bool active: false
    property real cornerRadius: Theme.radiusMD

    // Base Heavy Chassis Slab
    Rectangle {
        id: chassis
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.active ? Theme.surfacePlateRaised : Theme.surfacePlate

        // Neumorphic Top/Left 45-degree Bevel (Light Incident Chamfer)
        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            color: "transparent"
            border.width: root.active ? Theme.px(2) : Theme.px(1)
            border.color: root.active ? Theme.chromeBright : Theme.bevelLight
            opacity: root.active ? 0.9 : 0.4
        }

        // Inner Recessed Shadow / Smoked Acrylic Gel Body
        Rectangle {
            anchors.fill: parent
            anchors.margins: Theme.px(2)
            radius: Math.max(0, root.cornerRadius - Theme.px(2))
            color: root.active ? Theme.smokedGlassBg : Theme.smokedGlassDeep

            // Chrome Metallic Gradient Plate
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0.00
                    color: root.active ? "rgba(220, 229, 237, 0.16)" : "rgba(62, 73, 84, 0.08)"
                }
                GradientStop {
                    position: 0.48
                    color: "transparent"
                }
                GradientStop {
                    position: 1.00
                    color: root.active ? "rgba(155, 93, 229, 0.12)" : "rgba(0, 0, 0, 0.40)"
                }
            }
        }

        // Bottom/Right Occlusion Ridge
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.px(2)
            radius: root.cornerRadius
            color: root.active ? Theme.chromeDark : Theme.bevelDarkDeep
            opacity: 0.8
        }
    }
}
