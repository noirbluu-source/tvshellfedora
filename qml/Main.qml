import QtQuick
import QtQuick.Window
import TVShell

Window {
    id: rootWindow
    width: 3840
    height: 2160
    visible: true
    title: "Y2K Shell"
    color: StyleTokens.bgConcrete

    function handleGlobalBack() {
        console.log("Global Back received");
    }

    function handleGlobalMenu() {
        console.log("Global Menu overlay triggered");
    }

    // Industrial Header
    Item {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 180

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 80
            anchors.verticalCenter: parent.verticalCenter
            spacing: 24

            Text {
                text: "SYSTEM // TV-OS"
                color: StyleTokens.neonAqua
                font.pixelSize: StyleTokens.fontTitle
                font.bold: true
            }

            Rectangle {
                width: 4
                height: 40
                color: StyleTokens.chromeHighlight
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "4K 60HZ DRIVER READY"
                color: StyleTokens.textSecondary
                font.pixelSize: StyleTokens.fontCaption
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // Primary 10-foot Horizontal App Shelf
    Item {
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 80
        anchors.rightMargin: 80

        ListView {
            id: appGrid
            anchors.fill: parent
            orientation: ListView.Horizontal
            spacing: 40
            model: launcherModel
            focus: true
            clip: false

            // Snapping behavior tailored for TV remotes
            snapMode: ListView.SnapToItem
            keyNavigationEnabled: true
            keyNavigationWraps: true

            delegate: FocusCard {
                id: card
                title: model.title
                tag: model.tag
                accentColor: index % 2 === 0 ? StyleTokens.neonAqua : StyleTokens.neonPurple

                onActivated: {
                    launcherModel.launchApp(index)
                }

                // D-Pad Focus chain
                focus: index === 0
            }
        }
    }
}
