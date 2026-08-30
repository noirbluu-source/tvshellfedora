import QtQuick
import QtQuick.Window
import TVShell

Window {
    id: mainWindow
    visible: true
    title: "TVShell"
    color: "#080A0D"
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
    // 1. VISUAL BACKGROUND FOUNDATION (INLINE GPU PRIMITIVES)
    // =========================================================================
    Item {
        id: backgroundLayer
        anchors.fill: parent

        // Base Industrial Concrete Gradient
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.00; color: "#14181F" }
                GradientStop { position: 0.50; color: "#0D1015" }
                GradientStop { position: 1.00; color: "#06080A" }
            }
        }

        // Translucent Purple Gel Layer (Top-Left under Rotary Dial)
        Rectangle {
            x: -Theme.px(100)
            y: Theme.px(80)
            width: Theme.px(700)
            height: Theme.px(700)
            radius: width / 2
            color: "#9B5DE5"
            opacity: 0.07
        }

        // Translucent Green / Aqua Gel Layer (Bottom-Right Ambient Glow)
        Rectangle {
            x: parent.width - Theme.px(650)
            y: parent.height - Theme.px(550)
            width: Theme.px(650)
            height: Theme.px(650)
            radius: width / 2
            color: "#00F5D4"
            opacity: 0.05
        }

        // Subtle Concrete Grid Texture / Metric Overlay
        Item {
            anchors.fill: parent
            opacity: 0.35

            Repeater {
                model: Math.ceil(mainWindow.width / Theme.px(120))
                Rectangle {
                    x: index * Theme.px(120)
                    y: 0
                    width: 1
                    height: mainWindow.height
                    color: "#FFFFFF"
                    opacity: 0.03
                }
            }

            Repeater {
                model: Math.ceil(mainWindow.height / Theme.px(120))
                Rectangle {
                    x: 0
                    y: index * Theme.px(120)
                    width: mainWindow.width
                    height: 1
                    color: "#FFFFFF"
                    opacity: 0.03
                }
            }
        }

        // Edge Vignette (Framing the 10-foot TV Screen)
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: Theme.px(3)
            border.color: "#000000"
            opacity: 0.6
        }
    }

    // =========================================================================
    // 2. UI APPLICATION LAYER (PRESERVED ARCHITECTURE & NAVIGATION)
    // =========================================================================
    Item {
        id: shellContainer
        anchors.fill: parent
        anchors.margins: Theme.px(60)

        // ZONE 3: TOP HEADER & CONTROLS
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
                    text: "SYSTEM // TV-OS"
                    color: Theme.neonAqua
                    font.pixelSize: Theme.fontTitle
                    font.bold: true
                    font.letterSpacing: 2
                }

                Rectangle {
                    width: Theme.px(2)
                    height: Theme.px(24)
                    color: Theme.chromeDark
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "4K / 1080P COMPOSITOR READY"
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // ZONE 1: ROTARY MENU
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

        // ZONE 2: MAIN APPLICATION LIST
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

        // ZONE 4: STATUS / DOCK BAR
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
                        text: "STATUS: READY // 60HZ RENDER ENGINE"
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
