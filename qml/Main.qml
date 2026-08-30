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

    Connections {
        target: FocusManager
        function onItemActivated(zone, index) {
            if (zone === FocusManager.Zone.MainAppList) {
                var app = appLauncherModel.get(index)
                eventFeedback.text = "SELECTED: " + app.title + " (CMD: " + app.command + ")"
            } else {
                eventFeedback.text = "ACTIVATE -> " + FocusManager.zoneName(zone) + " [INDEX " + index + "]"
            }
        }
        function onBackRequested() {
            eventFeedback.text = "EVENT -> BACK TRIGGERED (ESC / BACK)"
        }
        function onMenuRequested() {
            eventFeedback.text = "EVENT -> MENU TRIGGERED (M / MENU)"
        }
    }

    // =========================================================================
    // BACKGROUND COMPOSITE (PHASE 2)
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

        // ZONE 3: TOP CONTROLS
        Item {
            id: zone3Container
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(100)

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.px(20)

                Text {
                    text: "TV SHELL // APP SUBSYSTEM"
                    color: Theme.neonAqua
                    font.pixelSize: Theme.px(32)
                    font.bold: true
                }
            }

            ZoneFocusScope {
                id: zone3
                zoneId: FocusManager.Zone.TopControls
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.px(600)
                height: Theme.px(70)
                isHorizontal: true
                itemSpacing: Theme.px(16)
                model: ["INPUT", "NETWORK", "POWER"]
            }
        }

        // =====================================================================
        // ZONE 1: ROTARY DIAL RAIL (PHASE 5)
        // =====================================================================
        Item {
            id: zone1Container
            anchors.top: zone3Container.bottom
            anchors.bottom: zone4Container.top
            anchors.left: parent.left
            anchors.topMargin: Theme.px(20)
            anchors.bottomMargin: Theme.px(20)
            width: Theme.px(520)

            RotaryDialRail {
                id: rotaryDial
                anchors.fill: parent
                model: ["ALL APPS", "MEDIA", "SYSTEM", "UTILITIES"]
                onItemSelected: function(idx) {
                    eventFeedback.text = "CATEGORY: " + model[idx]
                }
            }
        }

        // ZONE 2: MAIN APPLICATION LIST
        Item {
            id: zone2Container
            anchors.top: zone3Container.bottom
            anchors.bottom: zone4Container.top
            anchors.left: zone1Container.right
            anchors.right: parent.right
            anchors.topMargin: Theme.px(20)
            anchors.bottomMargin: Theme.px(20)
            anchors.leftMargin: Theme.px(40)

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

        // ZONE 4: BOTTOM BAR
        Item {
            id: zone4Container
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Theme.px(120)

            Rectangle {
                anchors.fill: parent
                color: Theme.smokedGlassDeep
                radius: Theme.radiusMD
                border.color: Theme.chromeDark
                border.width: Theme.px(1)

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.px(30)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.px(20)

                    Text {
                        id: eventFeedback
                        text: "STATUS: READY"
                        color: Theme.neonAqua
                        font.pixelSize: Theme.px(24)
                        font.bold: true
                    }
                }

                ZoneFocusScope {
                    id: zone4
                    zoneId: FocusManager.Zone.BottomBar
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.px(20)
                    anchors.verticalCenter: parent.verticalCenter
                    width: Theme.px(540)
                    height: Theme.px(60)
                    isHorizontal: true
                    itemSpacing: Theme.px(16)
                    model: ["GUIDE", "SEARCH", "INFO"]
                }
            }
        }
    }
}
