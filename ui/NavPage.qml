import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: navPage
    anchors.fill: parent

    // Properties to be set by the loader
    property string pageName: "NAV"
    property color pageColor: "#203040"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["ROUTE", "FPLN", "WPT", "NRST", "DATA"]
    property var rightButtonCaptions: ["TERR", "MAP", "WX", "ZOOM+", "ZOOM-"]

    // Function handlers for button events from the main MFD
    function handleLeftButton(index) {
        console.log("Left button pressed in NAV page: " + leftButtonCaptions[index]);

        switch(leftButtonCaptions[index]) {
            case "ROUTE":
                // Toggle route display
                break;
            case "FPLN":
                // Handle flight plan
                break;
            case "WPT":
                selectedWaypoint = (selectedWaypoint + 1) % waypoints.length;
                navCanvas.requestPaint();
                break;
            case "NRST":
                // Show nearest waypoints (sorted by distance)
                break;
            case "DATA":
                // Toggle additional data display
                break;
        }
    }

    function handleRightButton(index) {
        console.log("Right button pressed in NAV page: " + rightButtonCaptions[index]);

        switch(rightButtonCaptions[index]) {
            case "TERR":
                terrainEnabled = !terrainEnabled;
                navCanvas.requestPaint();
                break;
            case "MAP":
                mapMode = (mapMode + 1) % mapModes.length;
                navCanvas.requestPaint();
                break;
            case "WX":
                weatherEnabled = !weatherEnabled;
                navCanvas.requestPaint();
                break;
            case "ZOOM+":
                zoomLevel = Math.max(0, zoomLevel - 1);
                navCanvas.requestPaint();
                break;
            case "ZOOM-":
                zoomLevel = Math.min(zoomLevels.length - 1, zoomLevel + 1);
                navCanvas.requestPaint();
                break;
        }
    }

    // NAV-specific properties
    property bool terrainEnabled: false
    property bool weatherEnabled: false
    property int zoomLevel: 3
    property var zoomLevels: [10, 20, 50, 100, 200] // nm
    property int mapMode: 0 // 0=Plan, 1=North Up, 2=Track Up
    property var mapModes: ["PLAN", "NORTH UP", "TRACK UP"]
    property int heading: 45 // Current aircraft heading

    property var waypoints: [
        { id: "KSFO", name: "San Francisco Intl", lat: 37.62, lon: -122.38, distance: 12.5, bearing: 310, type: "airport" },
        { id: "KLAX", name: "Los Angeles Intl", lat: 33.94, lon: -118.41, distance: 285.2, bearing: 180, type: "airport" },
        { id: "KLAS", name: "Las Vegas Intl", lat: 36.08, lon: -115.15, distance: 342.8, bearing: 120, type: "airport" },
        { id: "OAK", name: "Oakland VOR", lat: 37.72, lon: -122.22, distance: 18.6, bearing: 330, type: "vor" },
        { id: "PYE", name: "Point Reyes", lat: 38.08, lon: -122.87, distance: 35.2, bearing: 290, type: "vor" },
        { id: "BOLDR", name: "BOLDR", lat: 37.89, lon: -122.65, distance: 25.8, bearing: 305, type: "fix" }
    ]

    property var activeRoute: [
        "KSFO", "BOLDR", "PYE"
    ]

    property int selectedWaypoint: 0

    color: pageColor

    // Map display area
    Rectangle {
        id: mapArea
        anchors {
            top: titleText.bottom
            left: parent.left
            right: parent.right
            bottom: statusBar.top
            margins: 10
        }
        color: "#102030"
        border.color: "white"
        border.width: 1
        clip: true

        // Terrain layer
        Rectangle {
            visible: terrainEnabled
            anchors.fill: parent

            Canvas {
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d");
                    var w = width;
                    var h = height;

                    // Create terrain pattern
                    var terrainGradient = ctx.createLinearGradient(0, 0, w, h);
                    terrainGradient.addColorStop(0.0, "#003300");
                    terrainGradient.addColorStop(0.3, "#104000");
                    terrainGradient.addColorStop(0.5, "#406030");
                    terrainGradient.addColorStop(0.7, "#607040");
                    terrainGradient.addColorStop(0.9, "#808060");
                    terrainGradient.addColorStop(1.0, "#a09080");

                    ctx.fillStyle = terrainGradient;
                    ctx.fillRect(0, 0, w, h);

                    // Add some terrain features (mountains, etc)
                    for (var i = 0; i < 20; i++) {
                        var x = Math.random() * w;
                        var y = Math.random() * h;
                        var radius = 20 + Math.random() * 100;

                        var mountainGradient = ctx.createRadialGradient(x, y, 0, x, y, radius);
                        mountainGradient.addColorStop(0, "#607040");
                        mountainGradient.addColorStop(0.7, "#405030");
                        mountainGradient.addColorStop(1, "#304020");

                        ctx.fillStyle = mountainGradient;
                        ctx.beginPath();
                        ctx.arc(x, y, radius, 0, Math.PI * 2);
                        ctx.fill();
                    }
                }
            }
        }

        // Map controls and legends
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            width: 100
            height: 70
            color: "#00000080"
            border.color: "white"
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5

                Text {
                    text: "RANGE: " + zoomLevels[zoomLevel] + " NM"
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }

                Text {
                    text: "MODE: " + mapModes[mapMode]
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }

                Text {
                    text: "HDG: " + heading + "°"
                    color: "white"
                    font.pixelSize: 12
                    font.family: "Roboto Mono"
                }
            }
        }

        // Auto-rotation to simulate aircraft movement
        Timer {
            interval: 100
            running: true
            repeat: true
            onTriggered: {
                heading = (heading + 1) % 360;
                navCanvas.requestPaint();
            }
        }
    }

    // Waypoint information panel
    Rectangle {
        anchors {
            right: mapArea.right
            bottom: mapArea.bottom
            margins: 10
        }
        width: 200
        height: 120
        color: "#00000080"
        border.color: "white"
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            Text {
                text: "WPT: " + waypoints[selectedWaypoint].id
                color: "white"
                font.pixelSize: 14
                font.bold: true
                font.family: "Roboto Mono"
            }

            Text {
                text: "NAME: " + waypoints[selectedWaypoint].name
                color: "white"
                font.pixelSize: 12
                font.family: "Roboto Mono"
            }

            Text {
                text: "TYPE: " + waypoints[selectedWaypoint].type.toUpperCase()
                color: "white"
                font.pixelSize: 12
                font.family: "Roboto Mono"
            }

            Text {
                text: "DIST: " + waypoints[selectedWaypoint].distance.toFixed(1) + " NM"
                color: "white"
                font.pixelSize: 12
                font.family: "Roboto Mono"
            }

            Text {
                text: "BRG: " + waypoints[selectedWaypoint].bearing + "°"
                color: "white"
                font.pixelSize: 12
                font.family: "Roboto Mono"
            }

            Text {
                text: "LAT/LON: " + waypoints[selectedWaypoint].lat.toFixed(2) + "°/" +
                      waypoints[selectedWaypoint].lon.toFixed(2) + "°"
                color: "white"
                font.pixelSize: 12
                font.family: "Roboto Mono"
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
                text: "TERRAIN: " + (terrainEnabled ? "ON" : "OFF")
                color: terrainEnabled ? "lime" : "white"
                font.pixelSize: 12
                width: parent.width / 4
                font.family: "Roboto Mono"
            }

            Text {
                text: "WEATHER: " + (weatherEnabled ? "ON" : "OFF")
                color: weatherEnabled ? "lime" : "white"
                font.pixelSize: 12
                width: parent.width / 4
                font.family: "Roboto Mono"
            }

            Text {
                text: "ROUTE: ACTIVE"
                color: "lime"
                font.pixelSize: 12
                width: parent.width / 4
                font.family: "Roboto Mono"
            }

            Text {
                text: "GPS: ACTIVE"
                color: "lime"
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

        // Water bodies
        Canvas {
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                var w = width;
                var h = height;
                var centerX = w / 2;
                var centerY = h / 2;

                // Draw ocean on west side (simplified)
                ctx.fillStyle = "#003060";
                ctx.beginPath();
                ctx.moveTo(0, 0);
                ctx.lineTo(w * 0.3, 0);
                ctx.lineTo(w * 0.4, h);
                ctx.lineTo(0, h);
                ctx.closePath();
                ctx.fill();

                // Draw lakes (simplified)
                ctx.fillStyle = "#0050A0";

                // Lake 1
                ctx.beginPath();
                ctx.ellipse(w * 0.7, h * 0.3, w * 0.15, h * 0.1);
                ctx.fill();

                // Lake 2
                ctx.beginPath();
                ctx.ellipse(w * 0.5, h * 0.7, w * 0.1, h * 0.15);
                ctx.fill();
            }
        }

        // Grid lines
        Canvas {
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                var w = width;
                var h = height;

                // Draw lat/lon grid
                ctx.strokeStyle = "rgba(255, 255, 255, 0.2)";
                ctx.lineWidth = 1;

                // Rotate if in Track Up mode
                if (mapMode === 2) {
                    ctx.save();
                    ctx.translate(w/2, h/2);
                    ctx.rotate(-heading * Math.PI / 180);
                    ctx.translate(-w/2, -h/2);
                }

                // Longitude lines
                for (var i = 0; i <= 10; i++) {
                    var x = w * i / 10;
                    ctx.beginPath();
                    ctx.moveTo(x, 0);
                    ctx.lineTo(x, h);
                    ctx.stroke();
                }

                // Latitude lines
                for (var i = 0; i <= 10; i++) {
                    var y = h * i / 10;
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(w, y);
                    ctx.stroke();
                }

                if (mapMode === 2) {
                    ctx.restore();
                }
            }
        }

        // Weather overlay
        Canvas {
            anchors.fill: parent
            visible: weatherEnabled

            onPaint: {
                var ctx = getContext("2d");
                var w = width;
                var h = height;

                // Add weather patterns (simplified)
                ctx.fillStyle = "rgba(0, 200, 255, 0.2)";

                // Weather system 1
                ctx.beginPath();
                ctx.ellipse(w * 0.3, h * 0.4, w * 0.2, h * 0.3);
                ctx.fill();

                // Weather system 2
                ctx.fillStyle = "rgba(0, 150, 255, 0.3)";
                ctx.beginPath();
                ctx.ellipse(w * 0.7, h * 0.6, w * 0.25, h * 0.2);
                ctx.fill();

                // Severe weather
                ctx.fillStyle = "rgba(255, 200, 0, 0.4)";
                ctx.beginPath();
                ctx.ellipse(w * 0.8, h * 0.3, w * 0.1, h * 0.1);
                ctx.fill();
            }
        }

        // Navigation elements
        Canvas {
            id: navCanvas
            anchors.fill: parent

            // Redraw when relevant properties change
            property int updateTrigger: zoomLevel + (mapMode * 100) + (selectedWaypoint * 1000) +
                                     (terrainEnabled ? 10000 : 0) + (weatherEnabled ? 100000 : 0)

            onUpdateTriggerChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d");
                var w = width;
                var h = height;
                var centerX = w / 2;
                var centerY = h / 2;
                var scale = zoomLevels[zoomLevel];

                // Save the context for rotation if needed
                if (mapMode === 2) { // Track Up mode
                    ctx.save();
                    ctx.translate(centerX, centerY);
                    ctx.rotate(-heading * Math.PI / 180);
                    ctx.translate(-centerX, -centerY);
                }

                // Draw range rings
                ctx.strokeStyle = "rgba(255, 255, 255, 0.3)";
                ctx.lineWidth = 1;

                var rings = [0.25, 0.5, 0.75, 1.0];
                var maxRadius = Math.min(w, h) * 0.45;

                for (var i = 0; i < rings.length; i++) {
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, maxRadius * rings[i], 0, Math.PI * 2);
                    ctx.stroke();

                    // Add distance labels
                    var ringDistNM = scale * rings[i];
                    if (mapMode !== 2) { // Don't rotate text in Track Up mode
                        ctx.fillStyle = "white";
                        ctx.font = "10px Roboto Mono";
                        ctx.fillText(ringDistNM.toFixed(0) + " NM",
                                     centerX,
                                     centerY - maxRadius * rings[i] - 5);
                    }
                }

                // Draw waypoints
                for (var i = 0; i < waypoints.length; i++) {
                    var wp = waypoints[i];

                    // Convert polar to cartesian (simplified position calculation)
                    var angleRad = (90 - wp.bearing) * Math.PI / 180;
                    var distance = wp.distance / scale;
                    if (distance > 1) distance = 0.95; // Cap at edge of display

                    var x = centerX + Math.cos(angleRad) * maxRadius * distance;
                    var y = centerY - Math.sin(angleRad) * maxRadius * distance;

                    // Draw different symbols based on waypoint type
                    ctx.lineWidth = 1.5;
                    ctx.strokeStyle = i === selectedWaypoint ? "lime" : "white";
                    ctx.fillStyle = i === selectedWaypoint ? "lime" : "white";

                    if (wp.type === "airport") {
                        // Airport symbol
                        ctx.beginPath();
                        ctx.moveTo(x - 6, y - 6);
                        ctx.lineTo(x + 6, y + 6);
                        ctx.moveTo(x + 6, y - 6);
                        ctx.lineTo(x - 6, y + 6);
                        ctx.stroke();

                        ctx.beginPath();
                        ctx.arc(x, y, 3, 0, Math.PI * 2);
                        ctx.fill();
                    } else if (wp.type === "vor") {
                        // VOR symbol (hexagon)
                        ctx.beginPath();
                        for (var j = 0; j < 6; j++) {
                            var angle = j * Math.PI / 3;
                            var px = x + Math.cos(angle) * 7;
                            var py = y + Math.sin(angle) * 7;
                            if (j === 0) ctx.moveTo(px, py);
                            else ctx.lineTo(px, py);
                        }
                        ctx.closePath();
                        ctx.stroke();
                    } else if (wp.type === "fix") {
                        // Fix symbol (triangle)
                        ctx.beginPath();
                        ctx.moveTo(x, y - 7);
                        ctx.lineTo(x + 6, y + 4);
                        ctx.lineTo(x - 6, y + 4);
                        ctx.closePath();
                        ctx.stroke();
                    }

                    // Draw waypoint name
                    ctx.fillStyle = i === selectedWaypoint ? "lime" : "white";
                    ctx.font = i === selectedWaypoint ? "bold 12px Roboto Mono" : "12px Roboto Mono";
                    ctx.fillText(wp.id, x + 10, y + 4);
                }

                // Draw active route
                if (activeRoute.length > 1) {
                    ctx.strokeStyle = "rgba(0, 255, 0, 0.7)";
                    ctx.lineWidth = 2;
                    ctx.beginPath();

                    // Find starting point
                    var firstWp = waypoints.find(wp => wp.id === activeRoute[0]);
                    if (firstWp) {
                        var angleRad = (90 - firstWp.bearing) * Math.PI / 180;
                        var distance = firstWp.distance / scale;
                        if (distance > 1) distance = 0.95;

                        var x = centerX + Math.cos(angleRad) * maxRadius * distance;
                        var y = centerY - Math.sin(angleRad) * maxRadius * distance;

                        ctx.moveTo(x, y);

                        // Connect all points in route
                        for (var i = 1; i < activeRoute.length; i++) {
                            var wp = waypoints.find(wp => wp.id === activeRoute[i]);
                            if (wp) {
                                angleRad = (90 - wp.bearing) * Math.PI / 180;
                                distance = wp.distance / scale;
                                if (distance > 1) distance = 0.95;

                                x = centerX + Math.cos(angleRad) * maxRadius * distance;
                                y = centerY - Math.sin(angleRad) * maxRadius * distance;

                                ctx.lineTo(x, y);
                            }
                        }

                        ctx.stroke();
                    }
                }

                // Draw aircraft symbol at center
                ctx.fillStyle = "yellow";
                ctx.strokeStyle = "black";
                ctx.lineWidth = 1;

                // In North Up mode, rotate just the aircraft symbol
                if (mapMode === 1) { // North Up
                    ctx.save();
                    ctx.translate(centerX, centerY);
                    ctx.rotate(heading * Math.PI / 180);

                    ctx.beginPath();
                    ctx.moveTo(0, -10);
                    ctx.lineTo(7, 10);
                    ctx.lineTo(0, 5);
                    ctx.lineTo(-7, 10);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();

                    ctx.restore();
                } else {
                    // In Plan or Track Up mode
                    ctx.beginPath();
                    ctx.moveTo(centerX, centerY - 10);
                    ctx.lineTo(centerX + 7, centerY + 10);
                    ctx.lineTo(centerX, centerY + 5);
                    ctx.lineTo(centerX - 7, centerY + 10);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();
                }

                // Restore context if we rotated for Track Up mode
                if (mapMode === 2) {
                    ctx.restore();
                }

                // Compass rose (always in screen coordinates)
                if (mapMode === 2) { // Only show in Track Up mode
                    var compassRadius = 30;
                    var compassX = w - compassRadius - 10;
                    var compassY = compassRadius + 10;

                    // Draw compass circle
                    ctx.strokeStyle = "white";
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    ctx.arc(compassX, compassY, compassRadius, 0, Math.PI * 2);
                    ctx.stroke();

                    // Draw cardinal directions
                    ctx.fillStyle = "white";
                    ctx.font = "bold 12px Roboto Mono";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";

                    // North is always at the top for the compass rose
                    ctx.fillText("N", compassX, compassY - compassRadius + 8);
                    ctx.fillText("E", compassX + compassRadius - 8, compassY);
                    ctx.fillText("S", compassX, compassY + compassRadius - 8);
                    ctx.fillText("W", compassX - compassRadius + 8, compassY);

                    // Draw heading indicator
                    ctx.strokeStyle = "yellow";
                    ctx.lineWidth = 2;
                    ctx.beginPath();

                    var hdgRadians = heading * Math.PI / 180;
                    ctx.moveTo(compassX, compassY);
                    ctx.lineTo(
                        compassX + Math.sin(hdgRadians) * compassRadius * 0.8,
                        compassY - Math.cos(hdgRadians) * compassRadius * 0.8
                    );
                    ctx.stroke();

                    // Reset text alignment
                    ctx.textAlign = "left";
                    ctx.textBaseline = "alphabetic";
                }
            }
        }
}
