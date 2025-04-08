import QtQuick 2.15

Rectangle
{
    id: hydraulicsPage

    property string pageName: "FUEL_PAGE"
    property color pageColor: "green"

    property real fwdFuseTankPercentage: 90
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

    Rectangle
    {
        id: fwdFuseTankBorder

        property int marginWidth: 2

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100


        width: fuselageTankDisplayWidth + marginWidth*2
        height: fuselageTankDisplayHeight + marginWidth*2

        color: 'darkgrey'

        Rectangle
        {
            id: fwdFuseTank

            color: 'black'

            width: fuselageTankDisplayWidth
            height: fuselageTankDisplayHeight

            anchors.centerIn: parent

            Rectangle
            {
                id: fwdFuseTankFillLevel

                anchors.bottom: parent.bottom

                height: parent.height * fwdFuseTankPercentage/100
                width: parent.width

                color: 'blue'
            }

            Text
            {
                anchors.centerIn: parent

                text: fwdFuseTankPercentage + " %"
                color: "white"
                fontSizeMode: Text.Fit
                font.family: "Roboto Mono"
                font.bold: true
            }

        }

    }

    Rectangle
    {
        id: rearFuseTankBorder

        property int marginWidth: 2

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 75


        width: fuselageTankDisplayWidth + marginWidth*2
        height: fuselageTankDisplayHeight + marginWidth*2

        color: 'darkgrey'

        Rectangle
        {
            id: rearFuseTank

            color: 'black'

            width: fuselageTankDisplayWidth
            height: fuselageTankDisplayHeight

            anchors.centerIn: parent

            Rectangle
            {
                id: rearFuseTankFillLevel

                anchors.bottom: parent.bottom

                height: parent.height * rearFuseTankPercentage/100
                width: parent.width

                color: 'blue'
            }

            Text
            {
                anchors.centerIn: parent

                text: rearFuseTankPercentage + " %"
                color: "white"
                fontSizeMode: Text.Fit
                font.family: "Roboto Mono"
                font.bold: true
            }

        }

    }


    Rectangle
    {
        id: leftWingTankBorder

        property int marginWidth: 2

        width: wingTankDisplayWidth + marginWidth*2
        height: wingTankDisplayHeight + marginWidth*2

        anchors.right: rearFuseTankBorder.left
        anchors.top: rearFuseTankBorder.top

        anchors.rightMargin: wingTankSideMargin

        color: 'darkgrey'

        Rectangle
        {
            id: leftWingTank

            color: 'black'

            width: wingTankDisplayWidth
            height: wingTankDisplayHeight

            anchors.centerIn: parent

            Rectangle
            {
                id: leftWingTankFillLevel

                anchors.bottom: parent.bottom

                height: parent.height * leftWingTankPercentage/100
                width: parent.width

                color: 'blue'
            }

            Text
            {
                anchors.centerIn: parent

                text: leftWingTankPercentage + " %"
                color: "white"
                fontSizeMode: Text.Fit
                font.family: "Roboto Mono"
                font.bold: true
            }
        }
    }

    Rectangle
    {
        id: rightWingTankBorder

        property int marginWidth: 2

        width: wingTankDisplayWidth + marginWidth*2
        height: wingTankDisplayHeight + marginWidth*2

        anchors.left: rearFuseTankBorder.right
        anchors.top: rearFuseTankBorder.top

        anchors.leftMargin: wingTankSideMargin

        color: 'darkgrey'

        Rectangle
        {
            id: rightWingTank

            color: 'black'

            width: wingTankDisplayWidth
            height: wingTankDisplayHeight

            anchors.centerIn: parent

            Rectangle
            {
                id: rightWingTankFillLevel

                anchors.bottom: parent.bottom

                height: parent.height * rightWingTankPercentage/100
                width: parent.width

                color: 'blue'
            }

            Text
            {
                anchors.centerIn: parent

                text: rightWingTankPercentage + " %"
                color: "white"
                fontSizeMode: Text.Fit
                font.family: "Roboto Mono"
                font.bold: true
            }
        }
    }
}
