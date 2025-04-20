import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import AircraftMFD 1.0

Rectangle {

    id: ownshipControls

    anchors.fill: parent

    color: 'green'


    Rectangle {

        id: positionControls

        color: 'blue'

        width: parent.width / 2
        height: parent.height / 2

        anchors.top: parent.top
        anchors.left: parent.left

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Text {
                text: "Ownship Position"
            }

            RowLayout {

                Text {
                    text: "Heading: "
                }

                Slider {
                    id: ownshipHeadingSlider
                    Layout.fillWidth: true

                    from: 0
                    to: 359
                    stepSize: 1

                    value: ownshipModel.heading_deg

                    onMoved: {
                        ownshipModel.setHeading_deg(value);
                    }
                }
            }


        }
    }
}
