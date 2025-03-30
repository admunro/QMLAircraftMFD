import QtQuick 2.15
//import QtQuick.Controls 2.15

Rectangle {
    id: radarPage
    anchors.fill: parent

    // Properties to be set by the loader
    property string pageName: "RADAR"
    property color pageColor: "#302030"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["MODE", "GAIN", "TILT", "STAB", "SCAN"]
    property var rightButtonCaptions: ["RANGE+", "RANGE-", "BRT+", "BRT-", "CNTRL"]

    // Function handlers for button events from the main MFD
    function handleLeftButton(index) {
        console.log("Button pressed in " + pageName + " page: " + leftButtonCaptions[index]);

        switch(leftButtonCaptions[index]) {
            case "MODE":
                scanMode = (scanMode + 1) % scanModes.length;
                break;
            case "GAIN":
                radarGain = Math.min(1.0, radarGain + 0.1);
                if (radarGain >= 1.0) radarGain = 0.3;
                break;
            case "TILT":
                radarTilt = (radarTilt + 2) % 16 - 8; // Range: -8 to +8
                break;
            case "STAB":
                stabilizationEnabled = !stabilizationEnabled;
                break;
            case "SCAN":
                // Toggle scan width
                scanWidth = (scanWidth + 30) % 120;
                if (scanWidth === 0) scanWidth = 60;
                break;
        }
    }

    function handleRightButton(index) {
        console.log("Button pressed in " + pageName + " page: " + rightButtonCaptions[index]);

        switch(rightButtonCaptions[index]) {
            case "RANGE+":
                radarRange = Math.min(160, radarRange * 2);
                break;
            case "RANGE-":
                radarRange = Math.max(10, radarRange / 2);
                break;
            case "BRT+":
                brightness = Math.min(1.0, brightness + 0.1);
                break;
            case "BRT-":
                brightness = Math.max(0.2, brightness - 0.1);
                break;
            case "CNTRL":
                showControlPanel = !showControlPanel;
                break;
        }
    }

    // RADAR-specific properties
    property int radarRange: 40 // nm
    property real radarGain: 0.7 // 0-1
    property int radarTilt: 0 // degrees
    property bool stabilizationEnabled: true
    property int scanMode: 0 // 0=normal, 1=weather, 2=terrain
    property int scanWidth: 60 // degrees (60, 90, 120)
    property real brightness: 0.8 // 0-1
    property bool showControlPanel: false

    // Scan modes
    property var scanModes: ["NORMAL", "WEATHER", "TERRAIN"]

    // Radar targets (for simulation)
    property var targets: [
        { distance: 12.5, bearing: 310, strength: 0.8, type: "aircraft" },
        { distance: 25.2, bearing: 280, strength: 0.6, type: "aircraft" },
        { distance: 18.6, bearing: 330, strength: 0.9, type: "weather" },
        { distance: 30.8, bearing: 350, strength: 0.4, type: "terrain" },
        { distance: 35.1, bearing: 45, strength: 0.7, type: "weather" },
        { distance: 28.7, bearing: 120, strength: 0.5, type: "aircraft" },
        { distance: 22.3, bearing: 200, strength: 0.6, type: "terrain" }
    ]

    color: pageColor

    // Radar display area
    Rectangle {
        id: radarDisplay
        anchors {
            top: titleText.bottom
            left: parent.left
            right: parent.right
            bottom: statusBar.top
            margins: 10
        }
        color: "black"
        border.color: "white"
        border.width: 1

        // Radar display
        Canvas {
            id: radarCanvas
            anchors.fill: parent

            // Property to trigger repaints
            property int updateTrigger: radarRange + (scanMode * 100) + (radarTilt * 10000) +
                                    (stabilizationEnabled ? 1000000 : 0) +
                                    Math.round(radarGain * 100) +
                                    Math.round(brightness * 1000) +
                                    scanWidth

            onUpdateTriggerChanged: requestPaint()

            // Sweep angle for animation
            property real sweepAngle: 0

            onPaint: {
                var ctx = getContext("2d");
                var w = width;
                var h = height;
                var centerX = w / 2;
                var centerY = h;
                var maxRadius = Math.min(w, h * 0.9);

                // Clear the canvas with dark background
                ctx.fillStyle = "black";
                ctx.fillRect(0, 0, w, h);

                // Draw scan arc background
                var halfScanWidth = scanWidth / 2;
                var startAngle = (270 - halfScanWidth) * Math.PI / 180;
                var endAngle = (270 + halfScanWidth) * Math.PI / 180;

                // Calculate brightness-adjusted color
                var bgAlpha = 0.1 * brightness;

                // Mode-specific colors
                var modeColor;
                if (scanMode === 0) { // Normal
                    modeColor = "rgba(0, 255, 0, " + bgAlpha + ")"; // Green
                } else if (scanMode === 1) { // Weather
                    modeColor = "rgba(0, 100, 255, " + bgAlpha + ")"; // Blue
                } else { // Terrain
                    modeColor = "rgba(255, 100, 0, " + bgAlpha + ")"; // Orange
                }

                ctx.fillStyle = modeColor;
                ctx.beginPath();
                ctx.arc(centerX, centerY, maxRadius, startAngle, endAngle);
                ctx.lineTo(centerX, centerY);
                ctx.closePath();
                ctx.fill();

                // Draw range rings
                ctx.strokeStyle = "rgba(255, 255, 255, 0.3)";
                ctx.lineWidth = 1;

                // Draw range arcs
                var numRings = 4;
                for (var i = 1; i <= numRings; i++) {
                    var radius = maxRadius * (i / numRings);
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, startAngle, endAngle);
                    ctx.stroke();

                    // Draw range label
                    var rangeMark = (radarRange / numRings * i).toFixed(0);
                    ctx.fillStyle = "white";
                    //ctx.font = "10px Roboto Mono";
                    ctx.fillText(rangeMark + " NM", centerX + 5, centerY - radius + 15);
                }

                // Draw bearing markers
                ctx.strokeStyle = "rgba(255, 255, 255, 0.3)";

                for (var angle = -halfScanWidth; angle <= halfScanWidth; angle += 30) {
                    var radians = (270 + angle) * Math.PI / 180;
                    var x = centerX + Math.cos(radians) * maxRadius;
                    var y = centerY + Math.sin(radians) * maxRadius;

                    ctx.beginPath();
                    ctx.moveTo(centerX, centerY);
                    ctx.lineTo(x, y);
                    ctx.stroke();

                    // Draw bearing label
                    var bearing = (360 + 270 + angle) % 360;
                    ctx.fillStyle = "white";
                    //ctx.font = "10px Roboto Mono";

                    // Position the text a bit away from the edge
                    var textRadius = maxRadius * 1.02;
                    var textX = centerX + Math.cos(radians) * textRadius;
                    var textY = centerY + Math.sin(radians) * textRadius;

                    ctx.fillText(bearing + "°", textX - 10, textY);
                }

                // Draw radar targets
                for (var i = 0; i < targets.length; i++) {
                    var target = targets[i];

                    // Skip targets outside the current scan width
                    var targetBearing = target.bearing;
                    var relativeBearing = (targetBearing > 180) ? targetBearing - 360 : targetBearing;
                    if (Math.abs(relativeBearing) > halfScanWidth) continue;

                    // Skip targets outside current range
                    if (target.distance > radarRange) continue;

                    // Skip targets based on mode
                    if (scanMode === 1 && target.type !== "weather") continue;
                    if (scanMode === 2 && target.type !== "terrain") continue;

                    // Apply gain to determine if target is visible
                    var effectiveStrength = target.strength * radarGain;
                    if (effectiveStrength < 0.3) continue;

                    // Calculate position
                    var targetAngle = (270 + targetBearing) % 360;
                    var targetRadians = targetAngle * Math.PI / 180;
                    var distanceRatio = target.distance / radarRange;
                    var targetRadius = maxRadius * distanceRatio;

                    var x = centerX + Math.cos(targetRadians) * targetRadius;
                    var y = centerY + Math.sin(targetRadians) * targetRadius;

                    // Different display based on target type and mode
                    var targetSize = 3 + (effectiveStrength * 5);

                    // Only show target if it's in the sweep
                    var sweepDiff = Math.abs(targetAngle - sweepAngle);
                    if (sweepDiff < 20 || sweepDiff > 340) {
                        // Apply brightness
                        var targetAlpha = brightness * effectiveStrength;

                        if (target.type === "weather") {
                            // Weather is shown as a gradient blob
                            var gradient = ctx.createRadialGradient(x, y, 0, x, y, targetSize * 2);
                            gradient.addColorStop(0, "rgba(0, 100, 255, " + targetAlpha + ")");
                            gradient.addColorStop(1, "rgba(0, 0, 255, 0)");

                            ctx.fillStyle = gradient;
                            ctx.beginPath();
                            ctx.arc(x, y, targetSize * 2, 0, Math.PI * 2);
                            ctx.fill();
                        } else if (target.type === "terrain") {
                            // Terrain is shown as a solid block
                            ctx.fillStyle = "rgba(255, 100, 0, " + targetAlpha + ")";
                            ctx.beginPath();
                            ctx.arc(x, y, targetSize, 0, Math.PI * 2);
                            ctx.fill();
                        } else {
                            // Aircraft are shown as bright dots with trails
                            ctx.fillStyle = "rgba(0, 255, 0, " + targetAlpha + ")";
                            ctx.beginPath();
                            ctx.arc(x, y, targetSize * 0.7, 0, Math.PI * 2);
                            ctx.fill();

                            // Add a directional indicator (simplified)
                            ctx.strokeStyle = "rgba(0, 255, 0, " + (targetAlpha * 0.7) + ")";
                            ctx.lineWidth = 1;
                            ctx.beginPath();
                            ctx.moveTo(x, y);
                            ctx.lineTo(x - Math.cos(targetRadians) * targetSize * 2,
                                      y - Math.sin(targetRadians) * targetSize * 2);
                            ctx.stroke();
                        }
                    }
                }

                // Draw the sweep line
                var sweepRadians = sweepAngle * Math.PI / 180;

                // Active sweep color based on mode
                var sweepColor;
                if (scanMode === 0) { // Normal
                    sweepColor = "rgba(0, 255, 0, 0.8)";
                } else if (scanMode === 1) { // Weather
                    sweepColor = "rgba(0, 100, 255, 0.8)";
                } else { // Terrain
                    sweepColor = "rgba(255, 100, 0, 0.8)";
                }

                ctx.strokeStyle = sweepColor;
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.moveTo(centerX, centerY);
                ctx.lineTo(centerX + Math.cos(sweepRadians) * maxRadius,
                           centerY + Math.sin(sweepRadians) * maxRadius);
                ctx.stroke();

                // Draw stabilization indicator if enabled
                if (stabilizationEnabled) {
                    ctx.fillStyle = "lime";
                    //ctx.font = "bold 12px Roboto Mono";
                    ctx.fillText("STAB", 10, 20);
                }

                // Draw tilt indicator
                ctx.fillStyle = "white";
                //ctx.font = "12px Roboto Mono";
                ctx.fillText("TILT: " + radarTilt + "°", 10, h - 10);
            }
        }

        // Radar sweep animation
        Timer {
            interval: 50
            running: true
            repeat: true

            onTriggered: {
                // Update sweep angle
                var halfScanWidth = scanWidth / 2;

                radarCanvas.sweepAngle += 5;
                if (radarCanvas.sweepAngle > (270 + halfScanWidth)) {
                    radarCanvas.sweepAngle = 270 - halfScanWidth;
                }

                radarCanvas.requestPaint();
            }
        }

        // Control panel (only visible when CNTRL button is pressed)
        Rectangle {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 10
            }
            width: 120
            height: 180
            color: "#00000080"
            border.color: "white"
            border.width: 1
            visible: showControlPanel

            Column {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 10

                Text {
                    text: "RADAR CONTROLS"
                    color: "white"
                    font.pixelSize: 12
                    font.bold: true
                    font.family: "Roboto Mono"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: parent.width - 10
                    height: 1
                    color: "gray"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "GAIN: " + (radarGain * 100).toFixed(0) + "%"
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }

                Text {
                    text: "BRT: " + (brightness * 100).toFixed(0) + "%"
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }

                Text {
                    text: "SCAN: " + scanWidth + "°"
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }

                Text {
                    text: "STAB: " + (stabilizationEnabled ? "ON" : "OFF")
                    color: stabilizationEnabled ? "lime" : "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }

                Text {
                    text: "MODE: " + scanModes[scanMode]
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }
            }
        }
    }

    // Status bar
    Rectangle {
        id: statusBar
        width: parent.width * 0.8
        height: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.color: "white"
        border.width: 1

        Row {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            Text {
                text: "MODE: " + scanModes[scanMode]
                color: "white"
                font.pixelSize: 12
                width: parent.width / 4
                font.family: "Roboto Mono"
            }

            Text {
                text: "RANGE: " + radarRange + " NM"
                color: "white"
                font.pixelSize: 12
                width: parent.width / 4
                font.family: "Roboto Mono"
            }

            Text {
                text: "GAIN: " + (radarGain * 100).toFixed(0) + "%"
                color: "white"
                font.pixelSize: 12
                width: parent.width / 4
                font.family: "Roboto Mono"
            }

            Text {
                text: "TILT: " + radarTilt + "°"
                color: "white"
                font.pixelSize: 12
                width: parent.width / 4
                font.family: "Roboto Mono"
            }
        }
    }

    // Title
    Text {
        id: titleText
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: pageName + " DISPLAY"
        color: "white"
        font.pixelSize: 18
        font.bold: true
        font.family: "Roboto Mono"
    }
}
