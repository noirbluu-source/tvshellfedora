import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    // Translucent Purple Gel Body (Under Rotary Dial & Navigation Zone)
    Rectangle {
        x: -Theme.px(80)
        y: Theme.px(140)
        width: Theme.px(680)
        height: root.height - Theme.px(280)
        radius: Theme.radiusLG
        color: Theme.gelPurpleTranslucent
        opacity: 0.40

        // Specular Top-Edge Reflection
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(2)
            color: Theme.neonPurpleBright
            opacity: 0.35
        }

        // Inner Refraction Lip
        Rectangle {
            anchors.fill: parent
            anchors.margins: Theme.px(4)
            radius: Math.max(0, Theme.radiusLG - Theme.px(4))
            color: "transparent"
            border.color: Theme.neonPurple
            border.width: Theme.px(1)
            opacity: 0.15
        }
    }

    // Translucent Acid-Green Gel Accent (Behind Center Content Shelf)
    Rectangle {
        x: root.width * 0.32
        y: Theme.px(160)
        width: root.width * 0.62
        height: root.height - Theme.px(320)
        radius: Theme.radiusLG
        color: Theme.gelAcidGreenTranslucent
        opacity: 0.28

        // Acid-Green Subtle Rim Highlight
        Rectangle {
            anchors.fill: parent
            radius: Theme.radiusLG
            color: "transparent"
            border.color: Theme.neonAcidGreen
            border.width: Theme.px(1)
            opacity: 0.12
        }

        // Specular Diagonal Light Band
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(40)
            radius: Theme.radiusLG
            color: Theme.gelSpecularSheen
            opacity: 0.04
        }
    }
}
