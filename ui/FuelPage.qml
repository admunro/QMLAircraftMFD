import QtQuick 2.15

import 'fuelWidgets'

Rectangle
{
    id: fuelPage

    property string pageName: "FUEL_PAGE"
    property color pageColor: "green"


    property real rearFuseTankPercentage: 50
    property real leftWingTankPercentage: 66
    property real rightWingTankPercentage: 33

    property int fuselageTankDisplayWidth: 50
    property int fuselageTankDisplayHeight: 75

    property int wingTankDisplayWidth: 75
    property int wingTankDisplayHeight: 40
    property int wingTankSideMargin: 10


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

    FuelTankDisplay
    {
        id: fwdFuseTank

        fillPercentage: 90

        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter

        displayWidth: fuselageTankDisplayWidth
        displayHeight: fuselageTankDisplayHeight
    }

    FuelTankDisplay
    {
        id: rearFuseTank

        fillPercentage: 50

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 75
        anchors.horizontalCenter: parent.horizontalCenter

        displayWidth: fuselageTankDisplayWidth
        displayHeight: fuselageTankDisplayHeight
    }


    FuelTankDisplay
    {
        id: leftWingTank

        displayWidth: wingTankDisplayWidth
        displayHeight: wingTankDisplayHeight

        fillPercentage: 33

        anchors.right: rearFuseTank.left
        anchors.top: rearFuseTank.top

        anchors.rightMargin: wingTankSideMargin
    }

    FuelTankDisplay
    {
        id: rightWingTank

        displayWidth: wingTankDisplayWidth
        displayHeight: wingTankDisplayHeight

        fillPercentage: 66

        anchors.left: rearFuseTank.right
        anchors.top: rearFuseTank.top

        anchors.leftMargin: wingTankSideMargin
    }
}
