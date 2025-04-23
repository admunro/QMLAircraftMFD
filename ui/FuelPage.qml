import QtQuick

import 'fuelWidgets'

import AircraftMFD 1.0

Rectangle
{
    id: fuelPage

    property string pageName: "FUEL_PAGE"
    property color pageColor: "green"

    property int fuselageTankDisplayWidth: 65
    property int fuselageTankDisplayHeight: 75

    property int wingTankDisplayWidth: 75
    property int wingTankDisplayHeight: 60
    property int wingTankSideMargin: 10

    // Add connection to the fuelModel to listen for changes
    Connections {
        target: fuelModel

        // This will be triggered whenever data in the model changes
        function onDataChanged() {
            // Force update of all tank displays
            fwdFuseTank.fillPercentage = calculateFuelTankPercentage("Front Fuselage").toFixed(0)
            rearFuseTank.fillPercentage = calculateFuelTankPercentage("Rear Fuselage").toFixed(0)
            portWingTank.fillPercentage = calculateFuelTankPercentage("Port Wing").toFixed(0)
            starboardWingTank.fillPercentage = calculateFuelTankPercentage("Starboard Wing").toFixed(0)
        }
    }


    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Front\nFuse +", "Front\nFuse -", "Rear\nFuse +", "Rear\nFuse -", "Fuel\nL5"]
    property var rightButtonCaptions: ["Port\nWing +", "Port\nWing -", "Stbd\nWing +", "Stbd\nWing -", "Fuel\nR5"]

    function calculateFuelTankPercentage(tankName) {

        var tank = fuelModel.get(tankName)

        var capacity = tank.capacity
        var fillLevel = tank.fillLevel

        return fillLevel / capacity * 100
    }



    // Function handlers for button events from the main MFD
    function handleLeftButton(index) {
        console.log("Button pressed in " + pageName + " page: L" + (index+1));

        switch(index) {
            case 0:
                if (fwdFuseTank.fillPercentage < 100)
                    fwdFuseTank.fillPercentage += 10
                break;
            case 1:
                if (fwdFuseTank.fillPercentage > 0)
                    fwdFuseTank.fillPercentage -= 10
                break;
            case 2:
                if (rearFuseTank.fillPercentage < 100)
                    rearFuseTank.fillPercentage += 10
                break;
            case 3:
                if (rearFuseTank.fillPercentage > 0)
                    rearFuseTank.fillPercentage -= 10
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
                if (portWingTank.fillPercentage < 100)
                    portWingTank.fillPercentage += 10
                break;
            case 1:
                if (portWingTank.fillPercentage > 0)
                    portWingTank.fillPercentage -= 10
                break;
            case 2:
                if (starboardWingTank.fillPercentage < 100)
                    starboardWingTank.fillPercentage += 10
                break;
            case 3:
                if (starboardWingTank.fillPercentage > 0)
                    starboardWingTank.fillPercentage -= 10
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

        fillPercentage: calculateFuelTankPercentage("Front Fuselage").toFixed(0)

        anchors.top: parent.top
        anchors.topMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter

        displayWidth: fuselageTankDisplayWidth
        displayHeight: fuselageTankDisplayHeight
    }

    FuelTankDisplay
    {
        id: rearFuseTank

        fillPercentage: calculateFuelTankPercentage("Rear Fuselage").toFixed(0)

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter

        displayWidth: fuselageTankDisplayWidth
        displayHeight: fuselageTankDisplayHeight
    }


    FuelTankDisplay
    {
        id: portWingTank

        displayWidth: wingTankDisplayWidth
        displayHeight: wingTankDisplayHeight

        fillPercentage: calculateFuelTankPercentage("Port Wing").toFixed(0)

        anchors.right: rearFuseTank.left
        anchors.top: rearFuseTank.top

        anchors.rightMargin: wingTankSideMargin
    }

    FuelTankDisplay
    {
        id: starboardWingTank

        displayWidth: wingTankDisplayWidth
        displayHeight: wingTankDisplayHeight

        fillPercentage: calculateFuelTankPercentage("Starboard Wing").toFixed(0)

        anchors.left: rearFuseTank.right
        anchors.top: rearFuseTank.top

        anchors.leftMargin: wingTankSideMargin
    }
}
