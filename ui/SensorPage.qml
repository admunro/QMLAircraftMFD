import QtQuick 2.15

Rectangle
{
    id: sensorPage

    property string pageName: "SENSOR_PAGE"
    property color pageColor: "#000000"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Sensor L1", "Sensor L2", "Sensor L3", "Sensor L4", "Sensor L5"]
    property var rightButtonCaptions: ["Sensor R1", "Sensor R2", "Sensor R3", "Sensor R4", "Sensor R5"]


    // Function handlers for button events from the main MFD
    function handleLeftButton(index) {
        console.log("Button pressed in " + pageName + " page: " + leftButtonCaptions[index]);

        switch(index) {
            case 0:
                // Handle L1
                break;
            case 1:
                // Handle L2
                break;
            case 2:
                // Handle L3
                break;
            case 3:
                // Handle L4
                break;
            case 4:
                // Handle L5
                break;
        }
    }

    function handleRightButton(index) {
        console.log("Button pressed in " + pageName + " page: " + rightButtonCaptions[index]);

        switch(index) {
            case 0:
                // Handle R1
                break;
            case 1:
                // Handle R2
                break;
            case 2:
                // Handle R3
                break;
            case 3:
                // Handle R4
                break;
            case 4:
                // Handle R5
                break;
        }
    }


    color: pageColor

    anchors.centerIn: parent

    Image
    {
        id: navPlaceholder

        source: 'img/sensor.png'

        width: parent.width
        height: parent.height

        anchors.centerIn: parent
    }

}
