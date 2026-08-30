import QtQuick
import TVShell

Item {
    id: root

    property string itemTitle: ""
    property string itemSubtitle: ""
    property string itemCategory: ""
    property string itemGlyph: "▶"
    property bool isCurrent: false
    property bool isPressed: false

    signal cardClicked()

    implicitWidth: 860
    implicitHeight: 120

    // Outer Neon Glow Aura when focused
    Rectangle {
        anchors.fill: parent
        anchors.margins: -4
        radius: 12
        color: "transparent"
        border.width: 3
        border.color: "#39FF14"
        opacity: root.isCurrent ? 0.85 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: 120 }
        }
    }

    // Industrial Plate Base (Dark Brushed Metal)
    Rectangle {
        id: cardBase
        anchors.fill: parent
        radius: 10
        color: root.isCurrent ? "#222A36" : "#14181F"
        border.width: root.isCurrent ? 2 : 1
        border.color: root.isCurrent ? "#39FF14" : "#3E4954"

        // Top-Left Incident Light Rim
        Rectangle {
            anchors.fill: parent
            radius: 10
            color: "transparent"
            border.width: 1
            border.color: root.isCurrent ? "#FFFFFF" : "rgba(255,255,255,0.15)"
            opacity: root.isCurrent ? 0.9 : 0.4
        }

        // Bottom Shadow Bevel
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 2
            radius: 10
            color: "#000000"
            opacity: 0.8
        }
    }

    // Card Content Row
    Row {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 18

        // Left Icon Box
        Rectangle {
            id: iconBox
            width: 76
            height: 76
            radius: 8
            anchors.verticalCenter: parent.verticalCenter
            color: root.isCurrent ? "#0D1117" : "#1A202C"
            border.color: root.isCurrent ? "#39FF14" : "#3E4954"
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: {
                    var t = root.itemTitle.toUpperCase();
                    if (t.indexOf("YOUTUBE") !== -1) return "▶";
                    if (t.indexOf("VLC") !== -1) return "▲";
                    if (t.indexOf("FILE") !== -1) return "📁";
                    if (t.indexOf("SETTINGS") !== -1) return "⚙";
                    if (t.indexOf("STORE") !== -1) return "✦";
                    return "■";
                }
                color: root.isCurrent ? "#80FF66" : "#8FA3B5"
                font.pixelSize: 32
                font.bold: true
            }
        }

        // Center Titles
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconBox.width - glyphBox.width - 36
            spacing: 4

            Row {
                width: parent.width
                spacing: 12

                Text {
                    text: root.itemTitle.toUpperCase()
                    color: root.isCurrent ? "#FFFFFF" : "#DCE5ED"
                    font.pixelSize: 24
                    font.bold: true
                    font.letterSpacing: 1.5
                    elide: Text.ElideRight
                }

                Rectangle {
                    visible: root.itemCategory.length > 0
                    width: catText.implicitWidth + 14
                    height: catText.implicitHeight + 4
                    radius: 4
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.isCurrent ? "#9B5DE5" : "#090C10"
                    border.color: root.isCurrent ? "#C77DFF" : "#3E4954"
                    border.width: 1

                    Text {
                        id: catText
                        anchors.centerIn: parent
                        text: root.itemCategory.toUpperCase()
                        color: "#FFFFFF"
                        font.pixelSize: 11
                        font.bold: true
                    }
                }
            }

            Text {
                text: root.itemSubtitle
                color: root.isCurrent ? "#80FF66" : "#8FA3B5"
                font.pixelSize: 15
                elide: Text.ElideRight
                width: parent.width
                opacity: root.isCurrent ? 1.0 : 0.7
            }
        }

        // Right Direction Arrow
        Item {
            id: glyphBox
            width: 36
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.centerIn: parent
                width: 32
                height: 32
                radius: 6
                color: root.isCurrent ? "#39FF14" : "#090C10"
                border.color: root.isCurrent ? "#FFFFFF" : "#3E4954"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: root.itemGlyph
                    color: root.isCurrent ? "#06080A" : "#505C6A"
                    font.pixelSize: 14
                    font.bold: true
                }
            }
        }
    }

    // Scale on Focus
    scale: root.isPressed ? 0.97 : (root.isCurrent ? 1.04 : 1.0)
    z: root.isCurrent ? 10 : 1

    Behavior on scale {
        NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: root.isPressed = true
        onReleased: root.isPressed = false
        onClicked: root.cardClicked()
    }
}
