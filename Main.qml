import QtQuick
import "ui"

Window {
    width: 800
    height: 800
    visible: true
    title: qsTr("Generic MFD")


    AircraftMFD
    {
        id: mfd

        height: parent.height
        width: parent.width

    }

}
