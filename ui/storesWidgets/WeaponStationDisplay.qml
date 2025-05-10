import QtQuick 2.15

import AircraftMFD 1.0

Rectangle {

    id: weaponStation

    property string stationName: 'no station'
    property int stationIndex: -1
    property string background_colour: 'blue'

    width: 30
    height: 100

    Connections {
        target: weaponStationModel

        function onDataChanged() {
            if (weaponStationModel.index(stationIndex, 0).selected)
            {
                background_colour = 'red'
            }
            else
            {
                background_colour = 'green'
            }
        }
    }

    function getWeaponImage(stationName) {
        switch(weapons.getByName(stationName).weapon_type) {
            case "AIM-120":
                console.log('AMRAAM');
                return "mr_missile.png";
            case "AIM-9X":
                console.log('SRAAM');
                return "sr_missile.png";
            case "GBU-12":
                console.log('Bomb');
                return "bomb.png";
            default:
                console.log('Default');
                return "default.png";
        }
    }



    color: background_colour

    Image {
        source: getWeaponImage(stationName)

        width: parent.width
        height: parent.height

        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent

            onClicked: {
                weaponStationModel.setData(weapons.index(stationIndex,0),
                                           true,
                                           WeaponStationModel.SelectedRole)
            }
        }
    }
}
