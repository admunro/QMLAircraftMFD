import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtPositioning 5.12

import AircraftMFD 1.0

Rectangle {
    id: ownshipControls
    anchors.fill: parent
    color: "#292929"  // Dark background to match application style

    property int selectedFuelTank : fuelTanksListView.currentIndex
    property int selectedEngine : enginesListView.currentIndex

    property var ownship : ownshipModel
    property var fueltanks : fuelTankModel
    property var engines : engineModel
    
    
    function updateHeading(headingDelta) {

        var newHeading = ownship.heading_deg + headingDelta;
        if (newHeading < 0) newHeading += 360;
        if (newHeading > 360) newHeading -= 360;

        ownship.heading_deg = newHeading;
        ownshipHeadingSlider.value = newHeading;

    }

    function updateSpeed(speedDelta) {

        var newSpeed = ownship.speed_kts + speedDelta;

        if (newSpeed < 0) newSpeed = 0
        if (newSpeed > 1000) newSpeed = 1000

        ownship.speed_kts = newSpeed;
        ownshipSpeedSlider.value = newSpeed;
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
            font.family: "Courier New"
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
                    font.family: "Courier New"
                }

                Text {
                    text: "Lat: " + ownshipControls.ownship.position.latitude.toFixed(6) + " Lon: " + ownshipControls.ownship.position.longitude.toFixed(6)
                    color: "#00ff00"  // Green for coordinates
                    font.pixelSize: 16
                    font.family: "Courier New"
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
                    font.family: "Courier New"
                }

                Slider {
                    id: ownshipHeadingSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 359
                    stepSize: 1
                    value: ownshipControls.ownship.heading_deg

                    onMoved: {
                        // Direct property assignment
                        ownshipControls.ownship.heading_deg = value;
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
                            ownshipControls.updateHeading(-5)
                        }
                    }

                    Button {
                        width: 40
                        height: 30
                        text: "+5°"
                        onClicked: {
                            ownshipControls.updateHeading(+5)
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
                    font.family: "Courier New"
                }

                Slider {
                    id: ownshipSpeedSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 1000
                    stepSize: 10
                    value: ownshipControls.ownship.speed_kts

                    onMoved: {
                        // Direct property assignment
                        ownshipControls.ownship.speed_kts = value;
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
                            ownshipControls.updateSpeed(-50)
                        }
                    }

                    Button {
                        width: 50
                        height: 30
                        text: "+50"
                        onClicked: {
                            ownshipControls.updateSpeed(50)
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
            font.family: "Courier New"
        }

        ListView {

            id: fuelTanksListView

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            model: ownshipControls.fueltanks

            delegate: Rectangle {

                width: fuelTanksListView.width
                height: 50

                color: "dimgrey"
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

                        text: 'Capacity: ' + model.capacity_kg + ' kg'
                        Layout.preferredWidth: 80
                    }

                    Text {

                        text: 'Fill Level: ' + model.fill_level_kg + ' kg'
                        Layout.preferredWidth: 80
                    }

                    Slider {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        from: 0
                        to: fueltanks.getByIndex(index).capacity_kg
                        stepSize: 1
                        value: fueltanks.getByIndex(index).fill_level_kg
                        enabled: true

                        onMoved: {
                            
                             fueltanks.setData(fueltanks.index(index, 0),
                                               value,
                                               FuelTankModel.Fill_level_kgRole);
                            
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


        ListView {

            id: enginesListView

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            model: engineModel

            delegate: Rectangle {

                width: enginesListView.width
                height: 50

                color: "dimgrey"
                border.color: "#cccccc"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: model.name
                        Layout.preferredWidth: 120
                }

                Text {
                    text: 'RPM %: ' + model.rpm_percent
                    Layout.preferredWidth: 120
                }

                Slider {
                    Layout.fillWidth: true

                    from: 0
                    to: 100
                    stepSize: 1
                    enabled: true
                    value: engines.getByIndex(index).rpm_percent

                    onMoved: {

                        engines.setData(engines.index(index, 0),
                                                value,
                                                EngineModel.Rpm_percentRole);

                        }
                    }
                }
            }

            onCurrentIndexChanged: {
                ownshipControls.updateEngines();
            }
        }
    }
 }
