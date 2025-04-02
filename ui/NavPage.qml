import QtQuick 2.5

Rectangle
{
    id: navPage

    property double heading

    property string pageName: "NAV_PAGE"
    property color pageColor: "#000000"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Nav\nL1", "Nav\nL2", "Nav\nL3", "Nav\nL4", "Nav\nL5"]
    property var rightButtonCaptions: ["Nav\nR1", "Nav\nR2", "Nav\nR3", "Nav\nR4", "Nav\nR5"]


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

        source: 'img/nav.png'

        width: parent.width
        height: parent.height

        anchors.centerIn: parent
    }

}
