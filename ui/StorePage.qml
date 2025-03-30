import QtQuick 2.15

Rectangle
{
    id: navPage

    property string pageName: "STORE_PAGE"
    property color pageColor: "#000000"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Store L1", "Store L2", "Store L3", "Store L4", "Store L5"]
    property var rightButtonCaptions: ["Store R1", "Store R2", "Store R3", "Store R4", "Store R5"]


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

        source: 'img/stores.png'

        width: parent.width
        height: parent.height

        anchors.centerIn: parent
    }

}
