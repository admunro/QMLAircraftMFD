import QtQuick 2.5

Rectangle
{
    id: sensorPage

    property string pageName: "SENSOR_PAGE"
    property color pageColor: "#000000"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Sensor\nL1", "Sensor\nL2", "Sensor\nL3", "Sensor\nL4", "Sensor\nL5"]
    property var rightButtonCaptions: ["Sensor\nR1", "Sensor\nR2", "Sensor\nR3", "Sensor\nR4", "Sensor\nR5"]


    // Function handlers for button events from the main MFD
    function handleLeftButton(index) {
        console.log("Button pressed in " + pageName + " page: L" + (index+1));

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
        console.log("Button pressed in " + pageName + " page: R" + (index+1));

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
