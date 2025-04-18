import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import AircraftMFD 1.0

Rectangle {

    id: entityControlWindow

    color: 'black'


    property int selectedEntity: entitiesListView.currentIndex


    // Function to update slider controls based on selected entity
    function updateControls() {
        if (selectedEntity >= 0) {
            var data = entityModel.get(selectedEntity);
            if (data) {
                headingSlider.value = data.heading;
                speedSlider.value = data.speed;
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Column {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Column Headers
            Rectangle {
                width: entitiesListView.width
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

                width: parent.width
                height: parent.height - 40
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
                            entityControlWindow.updateControls();
                        }
                    }
                }

                // Also update controls when the current index changes programmatically
                onCurrentIndexChanged: {
                    entityControlWindow.updateControls()

                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "darkgrey"
            border.color: "#cccccc"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: "Adjust Heading:"
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

                    Text {
                        text: headingSlider.value.toFixed(2) + "°"
                        width: 50
                    }
                }

                Text {
                    text: "Adjust Speed:"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

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

                    Text {
                        text: speedSlider.value.toFixed(0) + " kts"
                        width: 70
                    }
                }
            }
        }
    }

    // Initialize controls on component completion
    Component.onCompleted: {
        updateControls()
    }

}
