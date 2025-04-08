import QtQuick 2.15

Rectangle
{
    id: hydraulicsPage

    property string pageName: "FUEL_PAGE"
    property color pageColor: "green"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Fuel\nL1", "Fuel\nL2", "Fuel\nL3", "Fuel\nL4", "Fuel\nL5"]
    property var rightButtonCaptions: ["Fuel\nR1", "Fuel\nR2", "Fuel\nR3", "Fuel\nR4", "Fuel\nR5"]


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
        id: fuelPageImage

        source: 'img/fighter-plane.png'

        height: parent.height

        anchors.centerIn: parent
    }

}
