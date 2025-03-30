import QtQuick 2.15

Rectangle
{
    id: hydraulicsPage

    property string pageName: "ENGINES_PAGE"
    property color pageColor: "#000000"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Engine L1", "Engine L2", "Engine L3", "Engine L4", "Engine L5"]
    property var rightButtonCaptions: ["Engine R1", "Engine R2", "Engine R3", "Engine R4", "Engine R5"]


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

        source: 'img/engines.png'

        width: parent.width
        height: parent.height

        anchors.centerIn: parent
    }

}
