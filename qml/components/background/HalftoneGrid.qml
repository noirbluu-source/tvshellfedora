import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent
    opacity: 0.65

    // Brutalist Metric Grid (50px / scaled intervals)
    Canvas {
        id: gridCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            
            var step = Theme.px(64);
            ctx.lineWidth = 1;
            ctx.strokeStyle = "rgba(255, 255, 255, 0.022)";

            // Vertical Grid Lines
            ctx.beginPath();
            for (var x = 0; x < width; x += step) {
                ctx.moveTo(x + 0.5, 0);
                ctx.lineTo(x + 0.5, height);
            }
            // Horizontal Grid Lines
            for (var y = 0; y < height; y += step) {
                ctx.moveTo(0, y + 0.5);
                ctx.lineTo(width, y + 0.5);
            }
            ctx.stroke();

            // Halftone Matrix Crosshair Dots at Intersections
            ctx.fillStyle = "rgba(0, 245, 212, 0.08)"; // Subtle Aqua micro-points
            for (var dx = 0; dx < width; dx += step * 2) {
                for (var dy = 0; dy < height; dy += step * 2) {
                    ctx.fillRect(dx - 1, dy - 1, 2, 2);
                }
            }
        }
    }

    // CRT / Holographic Fine Scanline Filter (Repeating 4px raster)
    Column {
        anchors.fill: parent
        clip: true
        Repeater {
            model: Math.ceil(root.height / Theme.px(4))
            Rectangle {
                width: root.width
                height: Theme.px(1)
                color: "#000000"
                opacity: 0.35
                Rectangle {
                    anchors.top: parent.bottom
                    width: root.width
                    height: Theme.px(3)
                    color: "transparent"
                }
            }
        }
    }
}
