import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Window {

    id: controlsWindow

    width: 800
    height: 600

    visible: true

    title: qsTr("Scenario Conrtrol")

    property int selectedEntity: entitiesListView.currentIndex

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

                    color: selectedEntity === index ? "#e0e0e0" : "#f0f0f0"
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

                        onClicked: entitiesListView.currentIndex = index
                    }

                }
            }
        }


        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "#f5f5f5"
            border.color: "#cccccc"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: "Selected Item: " + (entitiesListView.currentIndex >= 0 ? entitiesListView.currentIndex : "None")
                    font.bold: true
                }

                Text {
                    text: "Adjust Value:"
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
                        value: entitiesListView.currentIndex >= 0 ? entityModel(entitiesListView.currentIndex).heading : 0
                        enabled: entitiesListView.currentIndex >= 0

                        onMoved: {
                            if (entitiesListView.currentIndex >= 0) {
                                // Update the model with new value from slider
                                entityModel.setData(entityModel.index(entitiesListView.currentIndex, 0), value)

                                //entityModel.setHeading(entitiesListView.currentIndex, value)
                            }
                        }
                    }

                    Text {
                        text: headingSlider.value.toFixed(2)
                        width: 50
                    }
                }
            }
        }
    }
}


