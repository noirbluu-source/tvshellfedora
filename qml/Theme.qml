pragma Singleton
import QtQuick

QtObject {
    id: root

    // =========================================================================
    // 1. DYNAMIC 4K/1080P SCALING ENGINE
    // =========================================================================
    readonly property real baseWidth: 3840.0
    readonly property real baseHeight: 2160.0

    // Dynamic scale factor updated by root Window
    property real scaleFactor: 1.0

    // Coordinate scaler with integer snapping to avoid DRM subpixel artifacts
    function px(value) {
        return Math.round(value * scaleFactor)
    }

    // Dynamic font scaler enforcing 10-foot TV safe minimums
    function pt(pixelSize4K, minSize1080p) {
        var scaled = Math.round(pixelSize4K * scaleFactor)
        var floorLimit = (typeof minSize1080p !== "undefined") ? minSize1080p : 14
        return Math.max(floorLimit, scaled)
    }

    // =========================================================================
    // 2. INDUSTRIAL SURFACES & CONCRETE BASE
    // =========================================================================
    readonly property color bgVoid: "#06080A"
    readonly property color bgDark: "#080A0D"
    readonly property color bgConcreteDark: "#0B0E13"
    readonly property color bgConcreteMid: "#12161D"
    readonly property color concreteChassis: "#181D26"
    readonly property color surfacePlate: "#1F2530"
    readonly property color surfacePlateRaised: "#293240"
    readonly property color surfaceRecessed: "#090C10"

    // =========================================================================
    // 3. SMOKED ACRYLIC & OPTICAL GEL
    // =========================================================================
    readonly property color smokedGlassBg: "#990C0F14"
    readonly property color smokedGlassDeep: "#CC07090C"
    readonly property color gelPurpleTranslucent: "#2E1A47"
    readonly property color gelAcidGreenTranslucent: "#1A3824"
    readonly property color gelSpecularSheen: "#33FFFFFF"
    readonly property color glassRefractionEdge: "#40FFFFFF"

    // =========================================================================
    // 4. METALS & CHROME BEVELS
    // =========================================================================
    readonly property color chromeHighlight: "#FFFFFF"
    readonly property color chromeBright: "#DCE5ED"
    readonly property color chromeMid: "#8FA3B5"
    readonly property color chromeDark: "#3E4954"
    readonly property color chromeShadow: "#171B20"

    // =========================================================================
    // 5. RAW BRASS & HARDWARE ALLOYS
    // =========================================================================
    readonly property color brassHighlight: "#FFF2C4"
    readonly property color brassPrimary: "#E5B869"
    readonly property color brassMid: "#C8963E"
    readonly property color brassShadow: "#7A5518"
    readonly property color brassRecessed: "#3D2B0C"

    // =========================================================================
    // 6. NEON EMISSIVE PALETTE
    // =========================================================================
    readonly property color neonAcidGreen: "#39FF14"
    readonly property color neonAcidGreenBright: "#80FF66"
    readonly property color phosphorGreen: "#00FF66"
    readonly property color neonPurple: "#9B5DE5"
    readonly property color neonPurpleBright: "#C77DFF"
    readonly property color neonAqua: "#00F5D4"
    readonly property color neonAquaBright: "#80FFF0"
    readonly property color neonPink: "#FF007F"
    readonly property color neonPinkBright: "#FF4DA6"

    // =========================================================================
    // 7. NEUMORPHIC BEVELS & SHADOW PAIRS
    // =========================================================================
    readonly property color bevelLight: "#26FFFFFF"
    readonly property color bevelLightSharp: "#66FFFFFF"
    readonly property color bevelDark: "#80000000"
    readonly property color bevelDarkDeep: "#E6000000"

    // =========================================================================
    // 8. 10-FOOT TV TYPOGRAPHY SYSTEM (Enforces Legibility @ 10 Feet)
    // =========================================================================
    readonly property int fontDisplay: pt(76, 38)  // Large Dial Active Readout
    readonly property int fontTitle: pt(46, 24)    // App Card Titles & Top Header
    readonly property int fontSection: pt(32, 18)  // Category Readouts & Sub-headers
    readonly property int fontBody: pt(24, 15)     // Subtitles, Metadata & CRT Lines
    readonly property int fontCaption: pt(18, 12)  // Badges & Button Legends
    readonly property int fontMicro: pt(14, 10)    // Telemetry & Hardware Badges

    // High Contrast Typography Palette
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#9EABB8"
    readonly property color textMuted: "#505C6A"
    readonly property color textDisabled: "#313942"
    readonly property color textInverse: "#06080A"

    // =========================================================================
    // 9. SPACING & PADDING METRICS
    // =========================================================================
    readonly property real spacingXXS: px(4)
    readonly property real spacingXS: px(8)
    readonly property real spacingSM: px(16)
    readonly property real spacingMD: px(24)
    readonly property real spacingLG: px(36)
    readonly property real spacingXL: px(52)
    readonly property real spacingXXL: px(80)

    // =========================================================================
    // 10. CORNER RADII
    // =========================================================================
    readonly property real radiusSharp: px(2)
    readonly property real radiusSM: px(6)
    readonly property real radiusMD: px(12)
    readonly property real radiusLG: px(20)
    readonly property real radiusPill: px(999)

    // =========================================================================
    // 11. FOCUS SCALING RATIOS
    // =========================================================================
    readonly property real focusScaleCard: 1.05
    readonly property real focusScaleButton: 1.08
    readonly property real focusScaleDialItem: 1.30
    readonly property real pressedScale: 0.97

    // =========================================================================
    // 12. GPU ANIMATION TIMINGS & CURVES
    // =========================================================================
    readonly property int animInstant: 60
    readonly property int animFast: 120
    readonly property int animNormal: 200
}
