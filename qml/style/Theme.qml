pragma Singleton
import QtQuick

QtObject {
    id: root

    // =========================================================================
    // 1. BASE REFERENCE RESOLUTION & DYNAMIC SCALING
    // =========================================================================
    // Target base reference is 4K UHD (3840 x 2160).
    // Automatically downscales to 1080p (scaleFactor = 0.5) while maintaining
    // pixel-crisp 10-foot legibility and proportional alignment.
    readonly property real baseWidth: 3840.0
    readonly property real baseHeight: 2160.0

    property real scaleFactor: 1.0

    // Coordinate scaler with integer rounding to prevent subpixel blur on Mesa/DRM
    function px(value) {
        return Math.round(value * scaleFactor)
    }

    // =========================================================================
    // 2. INDUSTRIAL SURFACES & CONCRETE (Brutalism & Neumorphism Base)
    // =========================================================================
    readonly property color bgDark: "#0A0C0E"            // Deep cold void background
    readonly property color bgConcrete: "#12151A"        // Dark industrial cast concrete
    readonly property color concreteChassis: "#181D24"   // Heavy slab body
    readonly property color surfacePlate: "#1E242D"      // Extruded brutalist plate
    readonly property color surfacePlateRaised: "#262E3A"// Elevated tactile surface
    readonly property color surfaceRecessed: "#0E1115"   // Debossed/machined slot

    // =========================================================================
    // 3. SMOKED ACRYLIC & LIQUID GEL (Glassmorphism & Y2K Plastics)
    // =========================================================================
    readonly property color smokedGlassBg: "#990C0F14"    // 60% smoked acrylic
    readonly property color smokedGlassDeep: "#CC07090C"  // 80% heavy dark filter
    readonly property color liquidGelSurface: "#33223042" // Specular gel sheen layer
    readonly property color glassRefractionEdge: "#40FFFFFF" // 1px physical rim light
    readonly property color liquidGelHighlight: "#8058A6FF"  // Sub-surface refraction

    // =========================================================================
    // 4. CHROME & SPECULAR METALS (Y2K Mechanical Finishes)
    // =========================================================================
    readonly property color chromeHighlight: "#FFFFFF"    // Specular peak light
    readonly property color chromeBright: "#DCE5ED"       // High-reflective silver
    readonly property color chromeMid: "#8FA3B5"          // Brushed aluminum body
    readonly property color chromeDark: "#3E4954"         // Anodized dark metal
    readonly property color chromeShadow: "#171B20"       // Deep bevel shadow

    // =========================================================================
    // 5. RAW INDUSTRIAL BRASS & GOLD ALLOY (Heavy Hardware & Physical Buttons)
    // =========================================================================
    readonly property color brassHighlight: "#FFF2C4"     // Polished brass edge reflection
    readonly property color brassPrimary: "#E5B869"       // Solid mechanical brass
    readonly property color brassMid: "#C8963E"          // Machined raw brass body
    readonly property color brassShadow: "#7A5518"        // Beveled brass drop-shadow
    readonly property color brassRecessed: "#3D2B0C"      // Stamped rivet / socket depth

    // =========================================================================
    // 6. HOLOGRAPHIC & NEON PALETTE (Spectral Focus, CRT & Cyber Glows)
    // =========================================================================
    // Purple / Electric Violet
    readonly property color neonPurple: "#9B5DE5"         // Primary cyber violet
    readonly property color neonPurpleBright: "#B47CFF"   // Peak fluorescent purple
    readonly property color neonPurpleGlow: "#4D9B5DE5"   // 30% alpha halo

    // Aqua / Cyan
    readonly property color neonAqua: "#00F5D4"           // High-contrast cyber cyan
    readonly property color neonAquaBright: "#70FFF0"     // Supercharged aqua white
    readonly property color neonAquaGlow: "#4D00F5D4"     // 30% alpha halo

    // Neon Pink / Hot Magenta
    readonly property color neonPink: "#FF007F"           // Y2K chromatic pink
    readonly property color neonPinkBright: "#FF4DA6"     // Glowing magenta core
    readonly property color neonPinkGlow: "#4DFF007F"     // 30% alpha halo

    // CRT Phosphor Green & Warnings
    readonly property color phosphorGreen: "#00FF66"      // Retro terminal readout
    readonly property color alertAmber: "#FF9E00"         // Hardware diagnostic amber

    // =========================================================================
    // 7. NEUMORPHIC BEVELS & SHADOW PAIRS (Light Source at Top-Left 45°)
    // =========================================================================
    readonly property color bevelLight: "#33FFFFFF"       // Top/Left incident highlight (20%)
    readonly property color bevelLightSharp: "#66FFFFFF"  // 1px intense chamfer (40%)
    readonly property color bevelDark: "#80000000"        // Bottom/Right shadow (50%)
    readonly property color bevelDarkDeep: "#E6000000"    // Deep cavity occlusion (90%)

    // =========================================================================
    // 8. 10-FOOT TYPOGRAPHY SYSTEM (Scaled for 4K / High Contrast Legibility)
    // =========================================================================
    // Font Sizes (Pixels in 4K UHD reference)
    readonly property int fontDisplay: px(76)             // Hero headers & radial dial active item
    readonly property int fontTitle: px(48)               // Shelf card titles & panel headers
    readonly property int fontSection: px(34)             // Section categorizers & subtitles
    readonly property int fontBody: px(26)                // Metadata, descriptions & button labels
    readonly property int fontCaption: px(20)             // Status indicators, badges & key guides
    readonly property int fontMicro: px(16)               // CRT telemetry & diagnostics

    // Text Colors & Contrasts
    readonly property color textPrimary: "#FFFFFF"        // 100% white for active focused text
    readonly property color textSecondary: "#9EAAB6"      // High-contrast silver for unfocused text
    readonly property color textMuted: "#556270"          // De-emphasized metadata
    readonly property color textDisabled: "#313942"       // Disabled hardware items
    readonly property color textInverse: "#0A0C0E"        // Text on bright brass / chrome pills

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
    // 10. CORNER RADII (Chunky Brutalist & Y2K Molded Plastics)
    // =========================================================================
    readonly property real radiusSharp: px(2)             // Metal chamfers & badges
    readonly property real radiusSM: px(6)                // Recessed slots & small buttons
    readonly property real radiusMD: px(12)               // Main App cards & dialog plates
    readonly property real radiusLG: px(20)               // Large outer containers & dock
    readonly property real radiusPill: px(999)            // Capsule buttons & status pills

    // =========================================================================
    // 11. FOCUS SCALING & ELEVATION
    // =========================================================================
    readonly property real focusScaleCard: 1.06           // Distinct visual pop for large app cards
    readonly property real focusScaleButton: 1.08         // Snappy physical button elevation
    readonly property real focusScaleSubtle: 1.03         // Minor dial / status magnification
    readonly property real pressedScale: 0.96             // Tactile depression on Enter/OK

    // =========================================================================
    // 12. HARDWARE ANIMATION TIMINGS & EASING (GPU-Friendly, 60 FPS Locked)
    // =========================================================================
    readonly property int animInstant: 60                 // Micro-ticks & button depressions
    readonly property int animFast: 120                   // Focus shifts, scale pops, border glow
    readonly property int animNormal: 220                 // Zone transitions & dial rotation
    readonly property int animSmooth: 360                 // Drawer / overlay expansions
}
