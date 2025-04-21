import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtPositioning 5.15

import AircraftMFD 1.0

Rectangle {
    id: ownshipControls
    anchors.fill: parent
    color: "#292929"  // Dark background to match application style


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

            ColumnLayout {
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

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Text {
                    text: "Heading: " + ownshipHeadingSlider.value.toFixed(0) + "°"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

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
        }

        // Speed Control
        Rectangle {
            Layout.fillWidth: true
            height: 90
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Text {
                    text: "Speed: " + ownshipSpeedSlider.value.toFixed(0) + " kts"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

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
        }
    }
}
