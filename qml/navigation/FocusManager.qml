pragma Singleton
import QtQuick

QtObject {
    id: root

    // Zone Enumerations
    enum Zone {
        RotaryMenu = 1,   // ZONE 1: Rotary application selector
        MainAppList = 2,  // ZONE 2: Main application list/grid
        TopControls = 3,  // ZONE 3: Top window & system controls
        BottomBar = 4     // ZONE 4: Bottom navigation/help actions
    }

    // Active State
    property int currentZone: FocusManager.Zone.MainAppList
    property string lastActionLog: "READY"

    // Signal broadcasted when OK is pressed in the active zone
    signal itemActivated(int zone, int index)
    signal backRequested()
    signal menuRequested()

    // Zone Reference Registry
    property var zoneItems: ({})

    function registerZone(zoneEnum, itemRef) {
        zoneItems[zoneEnum] = itemRef
        if (currentZone === zoneEnum) {
            itemRef.forceActiveFocus()
        }
    }

    function setZone(newZone) {
        if (zoneItems[newZone]) {
            currentZone = newZone
            zoneItems[newZone].forceActiveFocus()
            lastActionLog = "ZONE SWITCH -> " + zoneName(newZone)
        }
    }

    function zoneName(zoneEnum) {
        switch (zoneEnum) {
            case FocusManager.Zone.RotaryMenu: return "ZONE 1 (ROTARY MENU)"
            case FocusManager.Zone.MainAppList: return "ZONE 2 (MAIN APP LIST)"
            case FocusManager.Zone.TopControls: return "ZONE 3 (TOP CONTROLS)"
            case FocusManager.Zone.BottomBar: return "ZONE 4 (BOTTOM BAR)"
            default: return "UNKNOWN"
        }
    }

    // Deterministic D-Pad Route Resolver
    function handleDirection(direction) {
        switch (currentZone) {

            // --- ZONE 1: ROTARY MENU ---
            case FocusManager.Zone.RotaryMenu:
                if (direction === "RIGHT") {
                    setZone(FocusManager.Zone.MainAppList)
                    return true
                }
                if (direction === "UP" && zoneItems[FocusManager.Zone.RotaryMenu].currentIndex === 0) {
                    setZone(FocusManager.Zone.TopControls)
                    return true
                }
                if (direction === "DOWN" && zoneItems[FocusManager.Zone.RotaryMenu].isAtBottom()) {
                    setZone(FocusManager.Zone.BottomBar)
                    return true
                }
                break

            // --- ZONE 2: MAIN APP LIST ---
            case FocusManager.Zone.MainAppList:
                if (direction === "LEFT") {
                    setZone(FocusManager.Zone.RotaryMenu)
                    return true
                }
                if (direction === "UP" && zoneItems[FocusManager.Zone.MainAppList].currentIndex === 0) {
                    setZone(FocusManager.Zone.TopControls)
                    return true
                }
                if (direction === "DOWN" && zoneItems[FocusManager.Zone.MainAppList].isAtBottom()) {
                    setZone(FocusManager.Zone.BottomBar)
                    return true
                }
                break

            // --- ZONE 3: TOP CONTROLS ---
            case FocusManager.Zone.TopControls:
                if (direction === "DOWN") {
                    setZone(FocusManager.Zone.MainAppList)
                    return true
                }
                break

            // --- ZONE 4: BOTTOM BAR ---
            case FocusManager.Zone.BottomBar:
                if (direction === "UP") {
                    setZone(FocusManager.Zone.MainAppList)
                    return true
                }
                break
        }
        return false
    }
}
