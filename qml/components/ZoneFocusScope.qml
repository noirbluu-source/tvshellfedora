import QtQuick
import TVShell

FocusScope {
    id: root

    property int zoneId: FocusManager.Zone.MainAppList
    property var model: null
    property int currentIndex: 0
    readonly property int count: repeaterLoader.item ? repeaterLoader.item.count : 0
    property bool isHorizontal: false
    property real itemSpacing: Theme.px(20)

    signal itemSelected(int index)

    function isAtBottom() {
        return currentIndex >= count - 1
    }

    Component.onCompleted: {
        FocusManager.registerZone(root.zoneId, root)
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            FocusManager.currentZone = root.zoneId
        }
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Up) {
            if (isHorizontal) {
                FocusManager.handleDirection("UP")
            } else {
                if (currentIndex > 0) {
                    currentIndex--
                } else {
                    FocusManager.handleDirection("UP")
                }
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Down) {
            if (isHorizontal) {
                FocusManager.handleDirection("DOWN")
            } else {
                if (currentIndex < count - 1) {
                    currentIndex++
                } else {
                    FocusManager.handleDirection("DOWN")
                }
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Left) {
            if (isHorizontal) {
                if (currentIndex > 0) {
                    currentIndex--
                } else {
                    FocusManager.handleDirection("LEFT")
                }
            } else {
                FocusManager.handleDirection("LEFT")
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Right) {
            if (isHorizontal) {
                if (currentIndex < count - 1) {
                    currentIndex++
                } else {
                    FocusManager.handleDirection("RIGHT")
                }
            } else {
                FocusManager.handleDirection("RIGHT")
            }
            event.accepted = true
        }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            root.itemSelected(currentIndex)
            FocusManager.itemActivated(root.zoneId, currentIndex)
            event.accepted = true
        }
        else if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
            FocusManager.backRequested()
            event.accepted = true
        }
        else if (event.key === Qt.Key_M || event.key === Qt.Key_Menu) {
            FocusManager.menuRequested()
            event.accepted = true
        }
    }

    Loader {
        id: repeaterLoader
        anchors.fill: parent
        sourceComponent: root.isHorizontal ? rowComponent : colComponent
    }

    Component {
        id: rowComponent
        Row {
            spacing: root.itemSpacing
            property alias count: rep.count

            Repeater {
                id: rep
                model: root.model
                delegate: FocusCard {
                    width: root.width > 0 ? (root.width - (root.itemSpacing * (rep.count - 1))) / rep.count : Theme.px(200)
                    height: root.height
                    itemLabel: (typeof model.title !== "undefined") ? model.title : (typeof modelData !== "undefined" ? modelData : "")
                    itemSubtitle: (typeof model.subtitle !== "undefined") ? model.subtitle : ""
                    itemCategory: (typeof model.category !== "undefined") ? model.category : ""
                    isCurrent: (root.currentIndex === index) && root.activeFocus
                    onCardClicked: {
                        root.currentIndex = index
                        root.forceActiveFocus()
                        root.itemSelected(index)
                    }
                }
            }
        }
    }

    Component {
        id: colComponent
        Column {
            spacing: root.itemSpacing
            property alias count: rep.count

            Repeater {
                id: rep
                model: root.model
                delegate: FocusCard {
                    width: root.width
                    height: root.height > 0 ? (root.height - (root.itemSpacing * (rep.count - 1))) / rep.count : Theme.px(100)
                    itemLabel: (typeof model.title !== "undefined") ? model.title : (typeof modelData !== "undefined" ? modelData : "")
                    itemSubtitle: (typeof model.subtitle !== "undefined") ? model.subtitle : ""
                    itemCategory: (typeof model.category !== "undefined") ? model.category : ""
                    isCurrent: (root.currentIndex === index) && root.activeFocus
                    onCardClicked: {
                        root.currentIndex = index
                        root.forceActiveFocus()
                        root.itemSelected(index)
                    }
                }
            }
        }
    }
}
