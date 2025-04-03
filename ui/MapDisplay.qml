import QtQuick
import QtLocation
import QtPositioning

Rectangle
{
    id: mapDisplay

    color: 'dimGrey'

    property var pages: [ "Zoom\nIn", "Zoom\nOut", "RTN\nPP", "TRK\nUp", "NTH\nUp" ]


    enum MapOrientationType {
        North_Up,
        Track_Up
    }

    property var mapOrientation: MapDisplay.MapOrientationType.Track_Up

    property real latitude: 48.7232 // Manching Airport
    property real longitude: 11.5515
    property real heading: 45.0; // Degrees 0 - 360

    property var presentPosition: QtPositioning.coordinate(latitude, longitude)


    Plugin
    {
        id: mapPlugin
        name: 'osm'
    }


    function zoomIn()
    {
        if (map.zoomLevel < 20)
        {
            map.zoomLevel += 1
        }
        console.log('Zoom level: ' + map.zoomLevel)
    }

    function zoomOut()
    {
        if (map.zoomLevel > 6)
        {
            map.zoomLevel -= 1
        }
        console.log('Zoom level: ' + map.zoomLevel)
    }

    function selectTrackUp()
    {
        mapDisplay.mapOrientation = MapDisplay.MapOrientationType.Track_Up
    }

    function selectNorthUp()
    {
        mapDisplay.mapOrientation = MapDisplay.MapOrientationType.North_Up
    }

    Rectangle
    {
        id: mapArea

        width: parent.width
        height: parent.height * 0.8

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50

        color: 'red'

        Map
        {
            id: map

            width: parent.width
            height: parent.height

            plugin: mapPlugin
            center: mapDisplay.presentPosition
            bearing: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.Track_Up ? mapDisplay.heading : 0

            zoomLevel: 11

            copyrightsVisible: false

            DragHandler
            {
                id: drag
                target: null
                onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
            }
        }
    }




    Rectangle
    {
        id: bottomButtonArea
        color: 'transparent'

        width: parent.width
        height: parent.height * 0.1

        anchors {
            bottom: parent.bottom
        }

        Row
        {
            id: bottomButtonRpw

            anchors {
                bottom: parent.bottom
                margins: 2
                horizontalCenter: parent.horizontalCenter
            }

            height: parent.height
            spacing: parent.width / 20

            Repeater {
                model: mapDisplay.pages

                Rectangle {

                    height: parent.height * 0.8
                    width: height

                    color: "#2a2a2a"
                    border.color: 'black'
                    border.width: 1

                    Text
                    {
                        anchors.centerIn: parent
                        text: mapDisplay.pages[index]
                        color: 'white'
                        fontSizeMode: Text.Fit
                        font.family: "Roboto Mono"
                        font.bold: true
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onPressed: parent.color = "#404040"
                        onReleased: parent.color = "#2a2a2a"

                        onClicked:
                        {
                            if (index == 0)
                            {
                               zoomIn()
                            }
                            else if (index == 1)
                            {
                                zoomOut()
                            }
                            else if (index == 2)
                            {
                                map.center = mapDisplay.presentPosition
                            }
                            else if (index == 3)
                            {
                                selectTrackUp()
                            }
                            else if (index == 4)
                            {
                                selectNorthUp()
                            }

                            else
                            {
                                console.log('Button pressed on Map Display: ' + mapDisplay.pages[index])
                            }
                        }
                    }
                }
            }
        }

    }

}
