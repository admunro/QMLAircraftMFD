import QtQuick 2.5

Rectangle
{
    id: navPage

    property string pageName: "STORE_PAGE"
    property color pageColor: "#000000"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Store\nL1", "Store\nL2", "Store\nL3", "Store\nL4", "Store\nL5"]
    property var rightButtonCaptions: ["Store\nR1", "Store\nR2", "Store\nR3", "Store\nR4", "Store\nR5"]


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
                break;f
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

        source: 'img/stores.png'

        width: parent.width
        height: parent.height

        anchors.centerIn: parent
    }

}
