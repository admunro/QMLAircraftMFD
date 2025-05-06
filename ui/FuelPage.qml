import QtQuick 2.12

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


    property real frontFuseFillLevel: fuelModel.get("Front Fuselage").fillLevel
    property real frontFusePercent: frontFuseFillLevel / fuelModel.get("Front Fuselage").capacity * 100

    property real rearFuseFillLevel: fuelModel.get("Rear Fuselage").fillLevel
    property real rearFusePercent: rearFuseFillLevel / fuelModel.get("Rear Fuselage").capacity * 100

    property real portWingFillLevel: fuelModel.get("Port Wing").fillLevel
    property real portWingPercent: portWingFillLevel / fuelModel.get("Port Wing").capacity * 100

    property real starboardWingFillLevel: fuelModel.get("Starboard Wing").fillLevel
    property real starboardWingPercent: starboardWingFillLevel / fuelModel.get("Starboard Wing").capacity * 100

    property real totalFuel: frontFuseFillLevel + rearFuseFillLevel + portWingFillLevel + starboardWingFillLevel

    property bool displayKG: true


    // Add connection to the fuelModel to listen for changes
    Connections {
        target: fuelModel

        // This will be triggered whenever data in the model changes
        onDataChanged: {

            frontFuseFillLevel = fuelModel.get("Front Fuselage").fillLevel
            frontFusePercent = frontFuseFillLevel / fuelModel.get("Front Fuselage").capacity * 100

            rearFuseFillLevel = fuelModel.get("Rear Fuselage").fillLevel
            rearFusePercent = rearFuseFillLevel / fuelModel.get("Rear Fuselage").capacity * 100

            portWingFillLevel = fuelModel.get("Port Wing").fillLevel
            portWingPercent = portWingFillLevel / fuelModel.get("Port Wing").capacity * 100

            starboardWingFillLevel = fuelModel.get("Starboard Wing").fillLevel
            starboardWingPercent = starboardWingFillLevel / fuelModel.get("Starboard Wing").capacity * 100

            totalFuel = frontFuseFillLevel + rearFuseFillLevel + portWingFillLevel + starboardWingFillLevel

        }
    }


    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["Disp\nKG", "Disp\n%", "Fuel\nL3", "Fuel\nL4", "Fuel\nL5"]
    property var rightButtonCaptions: ["Fuel\nR1", "Fuel\nR2", "Fuel\nR3", "Fuel\nR4", "Fuel\nR5"]

    function calculateFuelTankPercentage(tankName) {

        var tank = fuelModel.get(tankName)

        var capacity = tank.capacity
        var fillLevel = tank.fillLevel

        return fillLevel / capacity * 100
    }



    // Function handlers for button events from the main MFD
    function handleLeftButton(index) {
        console.log("Button pressed in " + pageName + " page: L" + (index+1));

        switch (index)
        {
            case 0:
                displayKG = true;
                break;
            case 1:
                displayKG = false;
                break;
        }
    }

    function handleRightButton(index) {
        console.log("Button pressed in " + pageName + " page: R" + (index+1));
    }


    color: pageColor
    anchors.centerIn: parent


    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10

        color: "white"
        font.pixelSize: 24
        font.bold: true
        font.family: "Roboto Mono"

        text: "Total\n" + totalFuel.toFixed() + " kg"
    }


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

        fillPercentage: frontFusePercent.toFixed(0)
        fillCaption: displayKG ? frontFuseFillLevel.toFixed(0) + " kg" : frontFusePercent.toFixed(0) + " %"

        anchors.top: parent.top
        anchors.topMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter

        displayWidth: fuselageTankDisplayWidth
        displayHeight: fuselageTankDisplayHeight
    }

    FuelTankDisplay
    {
        id: rearFuseTank

        fillPercentage: rearFusePercent.toFixed(0)
        fillCaption: displayKG ? rearFuseFillLevel.toFixed(0) + " kg" : rearFusePercent.toFixed(0) + " %"

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

        fillPercentage: portWingPercent.toFixed(0)
        fillCaption: displayKG ? portWingFillLevel.toFixed(0) + " kg" : portWingPercent.toFixed(0) + " %"


        anchors.right: rearFuseTank.left
        anchors.top: rearFuseTank.top

        anchors.rightMargin: wingTankSideMargin
    }

    FuelTankDisplay
    {
        id: starboardWingTank

        displayWidth: wingTankDisplayWidth
        displayHeight: wingTankDisplayHeight

        fillPercentage: starboardWingPercent.toFixed(0)
        fillCaption: displayKG ? starboardWingFillLevel.toFixed(0) + " kg" : starboardWingPercent.toFixed(0) + " %"

        anchors.left: rearFuseTank.right
        anchors.top: rearFuseTank.top

        anchors.leftMargin: wingTankSideMargin
    }
}
