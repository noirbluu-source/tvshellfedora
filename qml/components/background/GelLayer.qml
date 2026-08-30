import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    // Ambient Purple Glow behind Dial
    Rectangle {
        x: -Theme.px(150)
        y: Theme.px(150)
        width: Theme.px(600)
        height: Theme.px(600)
        radius: width / 2
        color: Theme.neonPurple
        opacity: 0.08
    }

    // Ambient Aqua Glow behind Center Shelf
    Rectangle {
        anchors.centerIn: parent
        width: Theme.px(700)
        height: Theme.px(500)
        radius: width / 2
        color: Theme.neonAqua
        opacity: 0.05
    }

    // Ambient Pink Glow on Bottom Right
    Rectangle {
        x: parent.width - Theme.px(500)
        y: parent.height - Theme.px(450)
        width: Theme.px(500)
        height: Theme.px(500)
        radius: width / 2
        color: Theme.neonPink
        opacity: 0.05
    }
}
