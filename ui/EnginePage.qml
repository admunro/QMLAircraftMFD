import QtQuick

import AircraftMFD 1.0


Rectangle
{
    id: enginesPage

    property string pageName: "ENGINES_PAGE"
    property color pageColor: "#000000"

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Engine\nL1", "Engine\nL2", "Engine\nL3", "Engine\nL4", "Engine\nL5"]
    property var rightButtonCaptions: ["Engine\nR1", "Engine\nR2", "Engine\nR3", "Engine\nR4", "Engine\nR5"]


    property int portEngineRPM: engineModel.getByIndex(0).rpm_percent
    property int starboardEngineRPM: engineModel.getByIndex(1).rpm_percent

    Connections {
        target: engineModel

        function onDataChanged() {
            portEngineRPM = engineModel.getByIndex(0).rpm_percent;
            starboardEngineRPM = engineModel.getByIndex(1).rpm_percent
        }
    }

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

    Rectangle {

        id: portEngineDisplay

        width: 150
        height: 75

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20

        color: 'black'

        border.color: 'white'
        border.width: 2

        Text {
            anchors.centerIn: parent
            anchors.margins: 10

            color: "white"
            font.pixelSize: 16
            font.bold: true
            font.family: "Roboto Mono"


            text: "Port Engine\n" + portEngineRPM.toFixed(0) + " %"

        }
    }

    Rectangle {

        id: starboardEngineDisplay

        width: 150
        height: 75

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20

        color: 'black'

        border.color: 'white'
        border.width: 2


        Text {
            anchors.centerIn: parent
            anchors.margins: 10

            color: "white"
            font.pixelSize: 16
            font.bold: true
            font.family: "Roboto Mono"

            text: "Starboard Engine\n" + starboardEngineRPM.toFixed(0) + " %"

        }
    }

}
