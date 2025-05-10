import QtQuick 2.15

import AircraftMFD 1.0

Rectangle {

    id: weaponStation

    property string stationName: 'no station'
    property int stationIndex: -1

    width: 30
    height: 100

    function updateBackgroundColor()
    {
        const station = weaponStationModel.getByName(stationName);
        console.log("Updating station " + stationName + ": selected=" + station.selected);
        weaponStation.color = station.selected ? "red" : "green";
    }


    Connections {
        target: weaponStationModel

        function onDataChanged() {
            updateBackgroundColor();
        }
    }

    function getWeaponImage() {
        switch(weaponStationModel.getByName(stationName).weapon_type) {
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



    color: 'blue'

    Component.onCompleted: {
        updateBackgroundColor();
    }

    Image {
        source: getWeaponImage()

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
