import QtQuick 2.15

import AircraftMFD 1.0

Rectangle {

    id: weaponStation

    property var weapons: weaponStationModel

    property string stationName: 'no station'
    property int stationIndex: -1

    width: 30
    height: 100

    color: 'red'


    function updateBackgroundColor()
    {
        const station = weaponStationModel.getByName(stationName);
        weaponStation.color = station.selected ? 'red' : 'black';
    }


    Connections {
        target: weaponStationModel

        function onDataChanged() {
            updateBackgroundColor();
        }

        function onModelReset() {
            updateBackgroundColor();
        }
    }

    function getWeaponImage() {
        switch(weaponStationModel.getByName(stationName).weapon_type) {
            case "AIM-120":
                return "mr_missile.png";
            case "AIM-9X":
                return "sr_missile.png";
            case "GBU-12":
                return "bomb.png";
            default:
                return "default.png";
        }
    }



    Image {
        source: getWeaponImage()

        width: parent.width
        height: parent.height

        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent

            onClicked: {

                var selected = weaponStationModel.getByName(stationName).selected

                weaponStationModel.setData(weapons.index(stationIndex,0),
                                           !selected,
                                           WeaponStationModel.SelectedRole)
            }
        }
    }


    Component.onCompleted: {
        updateBackgroundColor();
    }

}
