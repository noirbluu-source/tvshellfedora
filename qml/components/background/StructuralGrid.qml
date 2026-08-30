import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent
    opacity: 0.55

    Canvas {
        id: metricCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var step = Theme.px(120);
            ctx.lineWidth = 1;
            ctx.strokeStyle = "rgba(143, 163, 181, 0.04)";

            // Coordinate Grid Lines
            ctx.beginPath();
            for (var x = step; x < width; x += step) {
                ctx.moveTo(x + 0.5, 0);
                ctx.lineTo(x + 0.5, height);
            }
            for (var y = step; y < height; y += step) {
                ctx.moveTo(0, y + 0.5);
                ctx.lineTo(width, y + 0.5);
            }
            ctx.stroke();

            // Precision Crosshairs & Alignment Ticks
            ctx.fillStyle = "rgba(57, 255, 20, 0.18)"; // Acid green points
            for (var cx = step * 2; cx < width - step; cx += step * 3) {
                for (var cy = step * 2; cy < height - step; cy += step * 3) {
                    ctx.fillRect(cx - 3, cy, 7, 1);
                    ctx.fillRect(cx, cy - 3, 1, 7);
                }
            }
        }
    }

    // Top-Left Chassis Serial Number
    Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: Theme.px(18)
        anchors.leftMargin: Theme.px(90)
        text: "CHASSIS // MK-IV-4K60 // WAYLAND.CAGE.FEDORA"
        color: Theme.textMuted
        font.pixelSize: Theme.fontMicro
        font.bold: true
        font.letterSpacing: 1.5
    }
}
