pragma Singleton
import QtQuick

QtObject {
    // 3840x2160 UHD Base Resolution Reference
    readonly property real baseWidth: 3840.0
    readonly property real baseHeight: 2160.0

    // Scaling ratio property calculated at runtime by root Window
    property real scaleFactor: 1.0

    function px(value) {
        return Math.round(value * scaleFactor)
    }

    // Color Palette Baseline
    readonly property color bgDark: "#08090A"
    readonly property color surfaceBase: "#121518"
    readonly property color surfaceFocused: "#1E2228"
    readonly property color borderBase: "#22272E"
    readonly property color borderFocused: "#388BFD"
    readonly property color textPrimary: "#F0F6FC"
    readonly property color textSecondary: "#8B949E"
    readonly property color textAccent: "#58A6FF"
}
