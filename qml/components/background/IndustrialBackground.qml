import QtQuick
import TVShell

Item {
    id: root
    anchors.fill: parent

    // Base Charcoal Slab Fill
    Rectangle {
        anchors.fill: parent
        color: Theme.bgConcreteDark
    }

    // Static Single-Pass FBO Concrete Grain
    Canvas {
        id: grainCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            // Stochastic grain points (Fixed sample count for 60 FPS load time)
            var density = 12000;
            ctx.fillStyle = "rgba(255, 255, 255, 0.016)";
            for (var i = 0; i < density; i++) {
                var rx = Math.random() * width;
                var ry = Math.random() * height;
                ctx.fillRect(rx, ry, 1, 1);
            }

            ctx.fillStyle = "rgba(0, 0, 0, 0.04)";
            for (var j = 0; j < density / 2; j++) {
                var bx = Math.random() * width;
                var by = Math.random() * height;
                ctx.fillRect(bx, by, 1.5, 1.5);
            }
        }
    }

    // Corner Reinforcement Hardware Plates
    Repeater {
        model: [
            { x: 0, y: 0 },
            { x: root.width - Theme.px(80), y: 0 },
            { x: 0, y: root.height - Theme.px(80) },
            { x: root.width - Theme.px(80), y: root.height - Theme.px(80) }
        ]

        Item {
            x: modelData.x
            y: modelData.y
            width: Theme.px(80)
            height: Theme.px(80)

            Rectangle {
                anchors.fill: parent
                color: Theme.concreteChassis
                border.color: Theme.chromeDark
                border.width: Theme.px(1)

                Rectangle {
                    anchors.centerIn: parent
                    width: Theme.px(14)
                    height: Theme.px(14)
                    radius: width / 2
                    color: Theme.surfaceRecessed
                    border.color: Theme.bevelLight
                    border.width: Theme.px(1)
                }
            }
        }
    }

    // Outer Screen Enclosure Bevel
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.bevelDark
        border.width: Theme.px(2)

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Theme.px(1)
            color: Theme.bevelLight
            opacity: 0.6
        }
    }
}
