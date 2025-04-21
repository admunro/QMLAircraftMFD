import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import AircraftMFD 1.0

Rectangle {

    id: entityControlWindow

    color: "#292929"

    property int selectedEntity: entitiesListView.currentIndex
    property int selectedFuelTank : fuelTanksListView.currentIndex


    // Function to update heading and speed slider controls based on selected entity
    function updateControls() {
        if (selectedEntity >= 0) {
            var data = entityModel.get(selectedEntity);
            if (data) {
                headingSlider.value = data.heading;
                speedSlider.value = data.speed;
            }
        }
    }


    // Function to update an entity's heading
    function updateHeading(headingDelta) {

        var entity = entityModel.get(selectedEntity);

        if (entity)  {

            var newHeading = entity.heading + headingDelta

            if (newHeading < 0) newHeading += 360

            if (newHeading > 360) newHeading -= 360

            entityModel.setData(
                        entityModel.index(selectedEntity, 0),
                        newHeading,
                        EntityModel.HeadingRole);

            headingSlider.value = newHeading
        }
    }

    function updateSpeed(speedDelta) {
        var entity = entityModel.get(selectedEntity);

        if (entity)  {

            var newSpeed = entity.speed + speedDelta

            if (newSpeed < 0) newSpeed = 0
            if (newSpeed > 1000) newSpeed = 1000

            entityModel.setData(
                        entityModel.index(selectedEntity, 0),
                        newSpeed,
                        EntityModel.SpeedRole);

            speedSlider.value = newSpeed

        }
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



    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20


        // Title
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Entity Controls"
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
                    text: "ID"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Name"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Latitude"
                    font.bold: true
                    Layout.preferredWidth: 80
                }

                Text {
                    text: "Longitude"
                    font.bold: true
                    Layout.preferredWidth: 80
                }

                Text {
                    text: "Type"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Heading (deg)"
                    font.bold: true
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Speed (kts)"
                    font.bold: true
                    Layout.preferredWidth: 30
                }
            }
        }

        ListView {
            id: entitiesListView

            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            model: entityModel

            delegate: Rectangle {
                width: entitiesListView.width
                height: 50

                color: selectedEntity === index ? "darkgrey" : "dimgrey"
                border.color: "#cccccc"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Text {
                        text: model.entityId
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: model.name
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: model.latitude.toFixed(6)
                        Layout.preferredWidth: 80
                    }

                    Text {
                        text: model.longitude.toFixed(6)
                        Layout.preferredWidth: 80
                    }

                    Text {
                        text: model.type
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: model.heading
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: model.speed
                        Layout.preferredWidth: 30
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        entitiesListView.currentIndex = index
                        entityControlWindow.updateControls()
                    }
                }
            }

            // Also update controls when the current index changes programmatically
            onCurrentIndexChanged: {
                entityControlWindow.updateControls()

            }
        }





        // Heading Control
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4

            ColumnLayout {

                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: "Heading: " + headingSlider.value.toFixed(2) + "°"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Slider {
                        id: headingSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 360
                        stepSize: 1
                        enabled: entityControlWindow.selectedEntity >= 0

                        onMoved: {
                            if (enabled) {
                                // Update the model with new value from slider
                                entityModel.setData(
                                            entityModel.index(entityControlWindow.selectedEntity, 0),
                                            value,
                                            EntityModel.HeadingRole);
                            }
                        }
                    }

                    Row {

                        Button {
                            width: 40
                            height: 30

                            text:  "-5°"

                            onClicked: {
                                updateHeading(-5)
                            }
                        }

                        Button {
                            width: 40
                            height: 30

                            text:  "+5°"

                            onClicked: {
                                updateHeading(5)
                            }
                        }

                    }
                }
            }
        }

        // Speed Control
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "#3a3a3a"
            border.color: "#5a5a5a"
            border.width: 1
            radius: 4


            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5



                Text {
                    text: "Speed: " + speedSlider.value.toFixed(0) + " kts"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                RowLayout {

                    Slider {
                        id: speedSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 1000
                        stepSize: 10
                        enabled: entityControlWindow.selectedEntity >= 0

                        onMoved: {
                            if (enabled) {
                                // Update the model with new value from slider
                                entityModel.setData(
                                            entityModel.index(entitiesListView.currentIndex, 0),
                                            value,
                                            EntityModel.SpeedRole);
                            }
                        }
                    }

                    Row {
                        Button {
                            width: 40
                            height: 30

                            text:  "-50"

                            onClicked: {
                                updateSpeed(-50)
                            }
                        }

                        Button {
                            width: 40
                            height: 30

                            text:  "+50"

                            onClicked: {
                                updateSpeed(50)
                            }
                        }
                    }
                }
            }
        }



        // Title
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
                        entityControlWindow.updateFuelTanks()

                    }
                }
            }

            // Also update controls when the current index changes programmatically
            onCurrentIndexChanged: {
                entityControlWindow.updateFuelTanks()
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

            ColumnLayout {

                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: fuelModel.get(selectedFuelTank).name + " Fill Level: " + fuelLevelSlider.value + " kg"
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Slider {
                        id: fuelLevelSlider
                        Layout.fillWidth: true

                        from: 0
                        to: fuelModel.get(selectedFuelTank).capacity
                        stepSize: 1
                        enabled: entityControlWindow.selectedFuelTank >= 0

                        onMoved: {
                            if (enabled) {
                                fuelModel.setData(fuelModel.index(entityControlWindow.selectedFuelTank, 0),
                                                  value,
                                                  FuelModel.FillLevelRole);
                            }
                        }
                    }
                }
            }
        }
    }



    // Initialize controls on component completion
    Component.onCompleted: {
        updateControls()
        updateFuelTanks()
    }

}
