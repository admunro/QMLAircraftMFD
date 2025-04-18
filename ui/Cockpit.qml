import QtQuick

Window {

    id: mainWindow

    width: 1920
    height: width / 3.5

    visible: true

    title: qsTr("Generic Fighter Cockpit")


    AircraftMFD
    {
        id: leftMFD

        width: parent.width / 3.5    // 800 pixels when window is 2800 wide
        height: parent.height

        anchors.left: parent.left
    }

    MapDisplay
    {
        id: mapDisplay

        width: parent.width / 1.75  // 1600 pixels when window is 2800 wide
        height: parent.height

        anchors.left: leftMFD.right
        anchors.right: rightMFD.left

        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    AircraftMFD
    {
        id: rightMFD

        width: parent.width / 3.5  // 800 pixels when window is 2800 wide
        height: parent.height

        anchors.right: parent.right

    }

}
