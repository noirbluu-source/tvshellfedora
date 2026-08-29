import QtQuick
import QtQuick.Window
import TVShell

Window {
    id: mainWindow
    visible: true
    title: "TVShell"
    color: Theme.bgDark
    flags: Qt.FramelessWindowHint | Qt.Window

    // Fullscreen behavior for TV Shell
    visibility: Window.FullScreen

    // Calculate scale factor relative to 4K (3840x2160)
    onWidthChanged: updateScale()
    onHeightChanged: updateScale()
    Component.onCompleted: updateScale()

    function updateScale() {
        var scaleW = width / Theme.baseWidth
        var scaleH = height / Theme.baseHeight
        Theme.scaleFactor = Math.min(scaleW, scaleH) > 0 ? Math.min(scaleW, scaleH) : 1.0
    }

    // Signal handlers connected from C++ RemoteKeyFilter
    function handleBack() {
        statusText.text = "EVENT: BACK / ESCAPE TRIGGERED"
    }

    function handleMenu() {
        statusText.text = "EVENT: MENU (M) TRIGGERED"
    }

    Item {
        id: rootContainer
        anchors.fill: parent
        focus: true

        // Header Section
        Item {
            id: headerArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(200)

            Row {
                anchors.left: parent.left
                anchors.leftMargin: Theme.px(100)
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.px(30)

                Text {
                    text: "TV SHELL // BASE ARCHITECTURE"
                    color: Theme.textPrimary
                    font.pixelSize: Theme.px(44)
                    font.bold: true
                }

                Rectangle {
                    width: Theme.px(3)
                    height: Theme.px(40)
                    color: Theme.textSecondary
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: statusText
                    text: "READY (USE D-PAD / ARROWS)"
                    color: Theme.textAccent
                    font.pixelSize: Theme.px(26)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Horizontal Focus Rail
        Row {
            id: contentRail
            anchors.centerIn: parent
            spacing: Theme.px(50)

            ShellFocusScope {
                id: card1
                labelText: "SHELF ITEM 1"
                focus: true
                KeyNavigation.right: card2
                onActivated: statusText.text = "ACTIVATED: SHELF ITEM 1"
            }

            ShellFocusScope {
                id: card2
                labelText: "SHELF ITEM 2"
                KeyNavigation.left: card1
                KeyNavigation.right: card3
                onActivated: statusText.text = "ACTIVATED: SHELF ITEM 2"
            }

            ShellFocusScope {
                id: card3
                labelText: "SHELF ITEM 3"
                KeyNavigation.left: card2
                onActivated: statusText.text = "ACTIVATED: SHELF ITEM 3"
            }
        }

        // 10-foot UX Safe Zone Overlay Guide (Bottom HUD)
        Item {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(120)

            Text {
                anchors.centerIn: parent
                text: "NAVIGATE: [LEFT/RIGHT]   |   SELECT: [ENTER]   |   MENU: [M]   |   BACK: [ESC]"
                color: Theme.textSecondary
                font.pixelSize: Theme.px(22)
                font.letterSpacing: 1.5
            }
        }
    }
}
