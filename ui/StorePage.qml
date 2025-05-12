import QtQuick 2.12

import 'storesWidgets'

import AircraftMFD 1.0


Rectangle
{
    id: storesPage

    property string pageName: "STORE_PAGE"
    property var weapons: weaponStationModel

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


    color: 'black'

    anchors.centerIn: parent

    Image
    {
        id: storesPageBackground

        source: 'img/fighter-plane.png'

        width: parent.width * 0.8
        height: parent.height

        anchors.centerIn: parent

    }

    WeaponStationDisplay {

        id: portWingTip

        stationName: "Port Wing Tip"
        stationIndex: 0

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 75

    }

    WeaponStationDisplay {

        id: starboardWingTip

        stationName: "Starboard Wing Tip"
        stationIndex: 1

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 75

    }

    WeaponStationDisplay {

        id: portFuselageFront

        stationName: "Port Fuselage Front"
        stationIndex: 2

        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5

        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -60

    }

    WeaponStationDisplay {

        id: starboardFuselageFront

        stationName: "Starboard Fuselage Front"
        stationIndex: 3

        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 5

        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -60


    }

    WeaponStationDisplay {

        id: portFuselageRear

        stationName: "Port Fuselage Rear"
        stationIndex: 4


        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5

        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 60


    }

    WeaponStationDisplay {

        id: starboardFuselageRear

        stationName: "Starboard Fuselage Rear"
        stationIndex: 5

        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 5

        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 60


    }

    WeaponStationDisplay {
        id: portUnderWing

        stationName: "Port Under Wing"
        stationIndex: 6

        anchors.left: portWingTip.right
        anchors.leftMargin: 50
        anchors.top: portWingTip.top


    }

    WeaponStationDisplay {
        id: starboardUnderWing

        stationName: "Starboard Under Wing"
        stationIndex: 7

        anchors.right: starboardWingTip.left
        anchors.rightMargin: 50
        anchors.top: starboardWingTip.top


    }

}
