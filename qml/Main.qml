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
                dockBar.statusMessage = "EXEC // " + app.title + " (CMD: " + app.command + ")"
            } else if (zone === FocusManager.Zone.TopControls) {
                dockBar.statusMessage = "SYS CONTROL // " + topBar.buttonModel[index].label
            } else if (zone === FocusManager.Zone.BottomBar) {
                dockBar.statusMessage = "DOCK ACTION // " + dockBar.actionModel[index].label
            } else if (zone === FocusManager.Zone.RotaryMenu) {
                dockBar.statusMessage = "FILTER // CATEGORY [" + rotaryDial.model[index] + "]"
            }
        }
        function onBackRequested() {
            dockBar.statusMessage = "INTERRUPT // BACK KEY DISPATCHED"
        }
        function onMenuRequested() {
            dockBar.statusMessage = "INTERRUPT // SYSTEM MENU TRIGGERED"
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

        // =====================================================================
        // ZONE 3: INDUSTRIAL TOP BAR (PHASE 6)
        // =====================================================================
        IndustrialTopBar {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            onControlTriggered: function(action) {
                dockBar.statusMessage = "TRIGGER // " + action + " CMD"
            }
        }

        // =====================================================================
        // ZONE 1: ROTARY DIAL RAIL (PHASE 5)
        // =====================================================================
        Item {
            id: zone1Container
            anchors.top: topBar.bottom
            anchors.bottom: dockBar.top
            anchors.left: parent.left
            anchors.topMargin: Theme.px(24)
            anchors.bottomMargin: Theme.px(24)
            width: Theme.px(520)

            RotaryDialRail {
                id: rotaryDial
                anchors.fill: parent
                model: ["ALL APPS", "MEDIA", "SYSTEM", "UTILITIES"]
                onItemSelected: function(idx) {
                    dockBar.statusMessage = "FILTER // " + model[idx]
                }
            }
        }

        // =====================================================================
        // ZONE 2: MAIN APPLICATION LIST (PHASE 4 FOCUS CARDS)
        // =====================================================================
        Item {
            id: zone2Container
            anchors.top: topBar.bottom
            anchors.bottom: dockBar.top
            anchors.left: zone1Container.right
            anchors.right: parent.right
            anchors.topMargin: Theme.px(24)
            anchors.bottomMargin: Theme.px(24)
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

        // =====================================================================
        // ZONE 4: RETRO CRT GLASS DOCK BAR (PHASE 6)
        // =====================================================================
        GlassDockBar {
            id: dockBar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            onActionTriggered: function(action) {
                dockBar.statusMessage = "TRIGGER // " + action + " CMD"
            }
        }
    }
}
