import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtPositioning 5.15

import AircraftMFD 1.0

Rectangle {
    id: ownshipControls
    anchors.fill: parent
    color: "#292929"  // Dark background to match application style

    property int selectedFuelTank : fuelTanksListView.currentIndex
    property int selectedEngine : enginesListView.currentIndex

    function updateHeading(headingDelta) {

        var newHeading = ownshipModel.heading_deg + headingDelta;
        if (newHeading < 0) newHeading += 360;
        if (newHeading > 360) newHeading -= 360;

        ownshipModel.heading_deg = newHeading;
        ownshipHeadingSlider.value = newHeading;

    }

    function updateSpeed(speedDelta) {

        var newSpeed = ownshipModel.speed_kts + speedDelta;

        if (newSpeed < 0) newSpeed = 0
        if (newSpeed > 360) newSpeed = 360

        ownshipModel.speed_kts = newSpeed;
        ownshipSpeedSlider.value = newSpeed;
    }

    // Function to update fillLevel slider control based on selected fuel tank
    function updateFuelTanks() {
        if (selectedFuelTank >= 0) {
            var data = fuelModel.get(selectedFuelTank);
            if (data) {
                fuelLevelSlider.to = data.capacity;
                fuelLevelSlider.value = data.fillLevel;
            }
        }
    }


    function updateEngines() {
        if (selectedEngine >= 0){
            var data = enginesModel.get(selectedEngine);
            if (data) {
                engineSlider.value = data.rpmpercent;
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Title
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Ownship Controls"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            font.family: "Roboto Mono"
        }

        // Current Position Display
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Text {
                    text: "Current Position:"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                Text {
                    text: "Lat: " + ownshipModel.position.latitude.toFixed(6) + " Lon: " + ownshipModel.position.longitude.toFixed(6)
                    color: "#00ff00"  // Green for coordinates
                    font.pixelSize: 16
                    font.family: "Roboto Mono"
                    font.bold: true
                }
            }
        }

        // Heading Control
        Rectangle {
            Layout.fillWidth: true
            height: 90
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "Heading: " + ownshipHeadingSlider.value.toFixed(0) + "°"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                Slider {
                    id: ownshipHeadingSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 359
                    stepSize: 1
                    value: ownshipModel.heading_deg

                    onMoved: {
                        // Direct property assignment
                        ownshipModel.heading_deg = value;
                    }
                }

                // Heading adjustment buttons
                Row {
                    spacing: 5
                    Button {
                        width: 40
                        height: 30
                        text: "-5°"
                        onClicked: {
                            updateHeading(-5)
                        }
                    }

                    Button {
                        width: 40
                        height: 30
                        text: "+5°"
                        onClicked: {
                            updateHeading(+5)
                        }
                    }
                }
            }

        }

        // Speed Control
        Rectangle {
            Layout.fillWidth: true
            height: 90
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4




            RowLayout {
                anchors.fill: parent
                spacing: 10
                anchors.margins: 10

                Text {
                    text: "Speed: " + ownshipSpeedSlider.value.toFixed(0) + " kts"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                Slider {
                    id: ownshipSpeedSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 1000
                    stepSize: 10
                    value: ownshipModel.speed_kts

                    onMoved: {
                        // Direct property assignment
                        ownshipModel.speed_kts = value;
                    }
                }

                // Speed adjustment buttons
                Row {
                    spacing: 5
                    Button {
                        width: 50
                        height: 30
                        text: "-50"
                        onClicked: {
                            updateSpeed(-50)
                        }
                    }

                    Button {
                        width: 50
                        height: 30
                        text: "+50"
                        onClicked: {
                            updateSpeed(50)
                        }
                    }
                }
            }
        }


        // Fuel Tanks
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Fuel Tanks"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            font.family: "Roboto Mono"
        }

        Rectangle {
            Layout.fillWidth: true
            height: 40

            color: 'gainsboro'

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: "Name"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Capacity (kg)"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Fill Level (kg)"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

            }

        }

        ListView {

            id: fuelTanksListView

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            model: fuelModel

            delegate: Rectangle {

                width: fuelTanksListView.width
                height: 50

                color: selectedFuelTank === index ? "darkgrey" : "dimgrey"
                border.color: "#cccccc"

                RowLayout {

                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10


                    Text {

                        text: model.name
                        Layout.preferredWidth: 80
                    }

                    Text {

                        text: model.capacity
                        Layout.preferredWidth: 80
                    }

                    Text {

                        text: model.fillLevel
                        Layout.preferredWidth: 80
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        fuelTanksListView.currentIndex = index
                        updateFuelTanks()

                    }
                }
            }

            // Also update controls when the current index changes programmatically
            onCurrentIndexChanged: {
                updateFuelTanks()
            }
        }

        // Fuel Tank Slider
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4

            RowLayout {

                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: fuelModel.get(selectedFuelTank).name + " Fill Level: " + fuelLevelSlider.value + " kg"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }


                Slider {
                    id: fuelLevelSlider
                    Layout.fillWidth: true

                    from: 0
                    to: fuelModel.get(selectedFuelTank).capacity
                    stepSize: 1
                    enabled: selectedFuelTank >= 0

                    onMoved: {
                        if (enabled) {
                            fuelModel.setData(fuelModel.index(selectedFuelTank, 0),
                                              value,
                                              FuelModel.FillLevelRole);
                        }
                    }
                }

            }
        }


        // Engines
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Engines"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            font.family: "Roboto Mono"
        }

        Rectangle {
            Layout.fillWidth: true
            height: 40

            color: 'gainsboro'

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: "Name"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "RPM Percent"
                    font.bold: true
                    Layout.preferredWidth: 30
                }
            }
        }


        ListView {

            id: enginesListView

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            model: enginesModel

            delegate: Rectangle {

                width: enginesListView.width
                height: 50

                color: selectedEngine === index ? "darkgrey" : "dimgrey"
                border.color: "#cccccc"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Text {
                        text: model.enginename
                        Layout.preferredWidth: 80
                    }

                    Text {
                        text: model.rpmpercent
                        Layout.preferredWidth: 80
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        enginesListView.currentIndex = index
                        updateEngines()
                    }
                }

            }

            onCurrentIndexChanged: {
                updateEngines();
            }

        }

        // Engine Slider
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4

            RowLayout {

                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: enginesModel.get(selectedEngine).name + " RPM: " + engineSlider.value + " %"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                Slider {
                    id: engineSlider
                    Layout.fillWidth: true

                    from: 0
                    to: 100
                    stepSize: 1
                    enabled: selectedEngine >= 0

                    onMoved: {
                        if (enabled) {
                            enginesModel.setData(enginesModel.index(selectedEngine, 0),
                                                 value,
                                                 EnginesModel.RPMPercentRole);
                        }
                    }
                }
            }
        }

    }



    // Initialize controls on component completion
    Component.onCompleted: {
        updateFuelTanks()
    }

}
