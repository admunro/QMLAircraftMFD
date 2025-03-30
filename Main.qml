import QtQuick

import "ui"

Window {

    id: mainWindow


    property int windowHeight: 800

    property int mfdWidth: 800
    property int mapWidth: 1200

    property int windowWidth: mfdWidth * 2 + mapWidth

    width: windowWidth
    height: windowHeight
    visible: true

    title: qsTr("Generic MFD")


    AircraftMFD
    {
        id: leftMFD

        height: parent.height
        width: mainWindow.mfdWidth

        anchors.left: parent.left
    }

    MapDisplay
    {
        id: mapDisplay

        width: mainWindow.mapWidth
        height: mainWindow.windowHeight

        anchors.centerIn: parent
    }

    AircraftMFD
    {
        id: rightMFD

        width: mainWindow.mfdWidth
        height: mainWindow.height

        anchors.right: parent.right

    }

}
