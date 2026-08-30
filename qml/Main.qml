import QtQuick
import QtQuick.Window
import TVShell

Window {
    id: mainWindow
    visible: true
    title: "TVShell"
    color: Theme.bgVoid
    flags: Qt.FramelessWindowHint | Qt.Window
    visibility: Window.FullScreen

    // Dynamic resolution scaling calculation
    onWidthChanged: updateScale()
    onHeightChanged: updateScale()
    Component.onCompleted: updateScale()

    function updateScale() {
        var scaleW = width / Theme.baseWidth
        var scaleH = height / Theme.baseHeight
        var calculated = Math.min(scaleW, scaleH)
        Theme.scaleFactor = calculated > 0 ? calculated : (height <= 1080 ? 0.5 : 1.0)
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
    // 1. VISUAL BACKGROUND COMPOSITE (GPU-OPTIMIZED)
    // =========================================================================
    Item {
        id: visualBackground
        anchors.fill: parent

        IndustrialBackground { id: concreteBase }
        GelLayer { id: gelPlates }
        NeonTubes { id: cathodeTubes }
        StructuralGrid { id: techGrid }
    }

    // =========================================================================
    // 2. 10-FOOT TV APPLICATION SHELL
    // =========================================================================
    Item {
        id: shellContainer
        anchors.fill: parent
        anchors.margins: Theme.px(60)

        // ZONE 3: TOP CONTROL BAR (Raw Brass <---> Liquid Mercury)
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
        // ZONE 1: ROTARY DIAL RAIL (LEFT RAIL)
        // =====================================================================
        Item {
            id: zone1Container
            anchors.top: topBar.bottom
            anchors.bottom: dockBar.top
            anchors.left: parent.left
            anchors.topMargin: Theme.px(20)
            anchors.bottomMargin: Theme.px(20)
            width: Theme.px(540)

            RotaryDialRail {
                id: rotaryDial
                anchors.fill: parent
                onItemSelected: function(idx) {
                    dockBar.statusMessage = "CATEGORY // " + model[idx]
                }
            }
        }

        // ZONE 2: MAIN BRUTALIST APPLICATION SHELF
        Item {
            id: zone2Container
            anchors.top: topBar.bottom
            anchors.bottom: dockBar.top
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
                itemSpacing: Theme.px(18)
                model: appLauncherModel
            }
        }

        // ZONE 4: RETRO CRT GLASS DOCK BAR
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
