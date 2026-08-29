import QtQuick
import TVShell

FocusScope {
    id: root
    signal activated()

    property string title: ""
    property string tag: ""
    property color accentColor: StyleTokens.neonAqua

    implicitWidth: 480
    implicitHeight: 320

    // Accessible key handling
    Keys.onReturnPressed: root.activated()
    Keys.onEnterPressed: root.activated()
    Keys.onSpacePressed: root.activated()

    // Outer Smoked Surface with Neumorphic Ridge
    Rectangle {
        id: bodySurface
        anchors.fill: parent
        radius: StyleTokens.cornerRadius
        color: root.activeFocus ? StyleTokens.surfacePlateRaised : StyleTokens.surfacePlate
        border.width: root.activeFocus ? 4 : 2
        border.color: root.activeFocus ? root.accentColor : StyleTokens.chromeShadow

        // Holographic Bottom Edge Highlight
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 3
            radius: StyleTokens.cornerRadius
            color: root.activeFocus ? StyleTokens.chromeHighlight : "transparent"
            opacity: 0.6
        }

        Column {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 16

            NeonBadge {
                text: root.tag
                accentColor: root.accentColor
            }

            Item { width: 1; height: 1; Layout.fillHeight: true }

            Text {
                width: parent.width
                text: root.title
                color: root.activeFocus ? StyleTokens.textPrimary : StyleTokens.textSecondary
                font.pixelSize: StyleTokens.fontBody
                font.bold: true
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
            }
        }
    }

    // Hardware-accelerated dynamic scaling on focus
    scale: root.activeFocus ? 1.05 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 140
            easing.type: Easing.OutQuad
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 120 }
    }
}
