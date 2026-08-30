import QtQuick
import TVShell

Item {
    id: root

    property string label: ""
    property string symbol: "■"
    property bool isSelected: false
    property bool isZoneFocused: false

    // Base dimensions scale dramatically on focus
    implicitWidth: Theme.px(130)
    implicitHeight: Theme.px(130)

    // =========================================================================
    // 1. VOLUMETRIC HALO & DROP SHADOW
    // =========================================================================
    Rectangle {
        anchors.fill: parent
        anchors.margins: -Theme.px(12)
        radius: width / 2
        color: "transparent"
        border.width: Theme.px(4)
        border.color: Theme.neonAcidGreen
        opacity: (root.isSelected && root.isZoneFocused) ? 0.85 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
        }
    }

    // =========================================================================
    // 2. POLISHED CHROME BEZEL (Luxury Audio Knob Ring)
    // =========================================================================
    Rectangle {
        id: chromeBezel
        anchors.fill: parent
        radius: width / 2
        color: root.isSelected ? Theme.chromeBright : Theme.chromeDark
        border.width: Theme.px(2)
        border.color: root.isSelected ? Theme.chromeHighlight : Theme.concreteChassis

        Behavior on color {
            ColorAnimation { duration: Theme.animFast }
        }

        // Top-Left Incident Specular Light Arc (45-degree polish)
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.width: Theme.px(2)
            border.color: Theme.chromeHighlight
            opacity: root.isSelected ? 0.95 : 0.40
        }

        // Bottom-Right Ambient Occlusion Shadow
        Rectangle {
            anchors.fill: parent
            anchors.margins: Theme.px(1)
            radius: width / 2
            color: "transparent"
            border.width: Theme.px(2)
            border.color: Theme.bevelDark
            opacity: 0.80
        }
    }

    // =========================================================================
    // 3. TRANSLUCENT GEL BUBBLE & TINTED PLASTIC BODY
    // =========================================================================
    Rectangle {
        id: gelBubble
        anchors.fill: parent
        anchors.margins: Theme.px(8)
        radius: width / 2
        color: root.isSelected
               ? (root.isZoneFocused ? Theme.gelAcidGreenTranslucent : Theme.gelPurpleTranslucent)
               : Theme.bgConcreteDark

        border.width: Theme.px(1)
        border.color: root.isSelected ? Theme.neonAcidGreenBright : Theme.chromeMid

        // High-Gloss Convex Specular Dome (Top Gel Reflection)
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Theme.px(4)
            height: parent.height * 0.44
            radius: width / 2
            color: Qt.rgba(1.0, 1.0, 1.0, root.isSelected ? 0.35 : 0.08)

            // Inner crescent highlight
            Rectangle {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: Theme.px(2)
                width: parent.width * 0.55
                height: Theme.px(3)
                radius: width / 2
                color: Theme.chromeHighlight
                opacity: root.isSelected ? 0.90 : 0.20
            }
        }

        // Secondary Sub-surface Reflection
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Theme.px(4)
            width: parent.width * 0.45
            height: Theme.px(3)
            radius: width / 2
            color: root.isSelected ? Theme.neonAcidGreenBright : Theme.chromeDark
            opacity: root.isSelected ? 0.60 : 0.15
        }

        // =====================================================================
        // 4. CHUNKY METALLIC ICON GLYPH
        // =====================================================================
        Text {
            anchors.centerIn: parent
            text: root.symbol
            color: root.isSelected
                   ? (root.isZoneFocused ? Theme.neonAcidGreenBright : Theme.textPrimary)
                   : Theme.chromeMid
            font.pixelSize: Theme.px(42)
            font.bold: true

            style: root.isSelected ? Text.Outline : Text.Normal
            styleColor: Theme.bevelDark
        }
    }

    // =========================================================================
    // 5. DRAMATIC 10-FOOT ELEVATION & DEPTH TRANSFORMS
    // =========================================================================
    scale: root.isSelected ? (root.isZoneFocused ? 1.32 : 1.16) : 0.84
    opacity: root.isSelected ? 1.0 : 0.45
    z: root.isSelected ? 20 : 1

    Behavior on scale {
        NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutBack }
    }
    Behavior on opacity {
        NumberAnimation { duration: Theme.animFast }
    }
}
