pragma Singleton
import QtQuick

QtObject {
    // Canvas Base Resolution Reference (Scales proportionally)
    readonly property real baseWidth: 3840.0
    readonly property real baseHeight: 2160.0

    // Palette: Industrial Smoked Metal & Cyberpunk High-Contrast
    readonly property color bgConcrete: "#0B0D0F"
    readonly property color surfacePlate: "#14171B"
    readonly property color surfacePlateRaised: "#1D2228"
    readonly property color surfaceSmokedGlass: "#8011151A"
    readonly property color chromeHighlight: "#8FA3B0"
    readonly property color chromeShadow: "#050607"

    // Neon Accents
    readonly property color neonAqua: "#00F5D4"
    readonly property color neonPurple: "#9B5DE5"
    readonly property color neonGreen: "#70E000"
    readonly property color neonAlert: "#F15BB5"

    // Text Colors (High Contrast 10-foot legibility)
    readonly property color textPrimary: "#F0F4F8"
    readonly property color textSecondary: "#8A99A8"
    readonly property color textDisabled: "#47535E"

    // 10-Foot Safe Typography (Calculated for 4K UHD reference)
    readonly property int fontDisplay: 72
    readonly property int fontTitle: 48
    readonly property int fontBody: 32
    readonly property int fontCaption: 24

    // Spacing
    readonly property real spacingUnit: 16.0
    readonly property real cornerRadius: 8.0
}
