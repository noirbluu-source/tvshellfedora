import QtQuick
import QtQuick.Window
import TVShell

Window {
    id: mainWindow
    visible: true
    title: "TVShell"
    color: Theme.bgDark
    flags: Qt.FramelessWindowHint | Qt.Window
    visibility: Window.FullScreen

    onWidthChanged: updateScale()
    onHeightChanged: updateScale()
    Component.onCompleted: updateScale()

    function updateScale() {
        var scaleW = width / Theme.baseWidth
        var scaleH = height / Theme.baseHeight
        Theme.scaleFactor = Math.min(scaleW, scaleH) > 0 ? Math.min(scaleW, scaleH) : 1.0
    }

    function handleBack() {
        FocusManager.backRequested()
    }
    function handleMenu() {
        FocusManager.menuRequested()
    }

    // =========================================================================
    // BACKGROUND COMPOSITE
    // =========================================================================
    Item {
        id: backgroundLayer
        anchors.fill: parent

        IndustrialBackground { id: industrialBg }
        GelLayer { id: gelGlow }
        HalftoneGrid { id: halftoneGrid }
    }

    // =========================================================================
    // UI APPLICATION LAYER
    // =========================================================================
    Item {
        id: shellContainer
        anchors.fill: parent
        anchors.margins: Theme.px(60)

        // ZONE 3: TOP HEADER
        Item {
            id: zone3Container
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(80)

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.px(20)

                Text {
                    text: "TV SHELL // APP SUBSYSTEM"
                    color: Theme.neonAqua
                    font.pixelSize: Theme.fontTitle
                    font.bold: true
                    font.letterSpacing: 2
                }
            }
        }

        // =====================================================================
        // ZONE 1: ROTARY MENU
        // =====================================================================
        Item {
            id: zone1Container
            anchors.top: zone3Container.bottom
            anchors.bottom: zone4Container.top
            anchors.left: parent.left
            anchors.topMargin: Theme.px(20)
            anchors.bottomMargin: Theme.px(20)
            width: Theme.px(560)

            RotaryMenu {
                id: rotaryMenu
                anchors.fill: parent
                onItemActivated: function(idx) {
                    statusText.text = "CATEGORY // " + itemsModel[idx].label
                }
            }
        }

        // =====================================================================
        // ZONE 2: MAIN APPLICATION SHELF (AppCard)
        // =====================================================================
        Item {
            id: zone2Container
            anchors.top: zone3Container.bottom
            anchors.bottom: zone4Container.top
            anchors.left: zone1Container.right
            anchors.right: parent.right
            anchors.topMargin: Theme.px(20)
            anchors.bottomMargin: Theme.px(20)
            anchors.leftMargin: Theme.px(30)

            Text {
                id: zone2Header
                text: "APPLICATIONS"
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                font.bold: true
                font.letterSpacing: 2
            }

            ZoneFocusScope {
                id: zone2
                zoneId: FocusManager.Zone.MainAppList
                anchors.top: zone2Header.bottom
                anchors.topMargin: Theme.px(16)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                isHorizontal: false
                itemSpacing: Theme.px(20)
                model: appLauncherModel
            }
        }

        // =====================================================================
        // ZONE 4: STATUS BAR
        // =====================================================================
        Item {
            id: zone4Container
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(90)

            Rectangle {
                anchors.fill: parent
                color: Theme.smokedGlassDeep
                radius: Theme.radiusMD
                border.color: Theme.chromeDark
                border.width: Theme.px(1)

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.px(24)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.px(16)

                    Text {
                        text: "▶"
                        color: Theme.neonAqua
                        font.pixelSize: Theme.fontCaption
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: statusText
                        text: "STATUS: READY // 4K 60HZ RENDER ENGINE"
                        color: Theme.phosphorGreen
                        font.pixelSize: Theme.fontBody
                        font.bold: true
                        font.letterSpacing: 1.2
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
