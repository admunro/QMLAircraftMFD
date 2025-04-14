import QtQuick
import QtLocation
import QtPositioning

import "../scripts/PositionCalculator.js" as PositionCalculator

Rectangle {
    id: mapDisplay

    color: 'dimGrey'

    property var pages: ["Zoom\nIn", "Zoom\nOut", "RTN\nPP", "TRK\nUp", "NTH\nUp"]

    enum MapOrientationType {
        North_Up,
        Track_Up
    }

    property var mapOrientation: MapDisplay.MapOrientationType.Track_Up

    property var presentPosition: QtPositioning.coordinate(48.7232, 11.5515) // Manching Airport
    property real heading: 45 // Degrees 0 - 360
    property real speed: 850 // knots


    property var track1Position: QtPositioning.coordinate(48.7122, 11.2179) // Fliegerhorst Neuburg
    property real track1Heading: 0
    property real track1Speed: 400

    property var track2Position: QtPositioning.coordinate(48.3547, 11.7885) // Munich airport
    property real track2Heading: 270
    property real track2Speed: 250


    property var regensburg: QtPositioning.coordinate(49.0135470117391, 12.099220270621009)
    property var nurnberg: QtPositioning.coordinate(49.454248608301405, 11.079626073052278)
    property var wurzburg: QtPositioning.coordinate(49.7913484076446, 9.95397659969378)
    property var heilbronn: QtPositioning.coordinate(49.14312704599744, 9.209073192899)
    property var augsburg: QtPositioning.coordinate(48.36998485706096, 10.893213648008109)
    property var ingolstadt: QtPositioning.coordinate(48.7675412885771, 11.416398607163837)

    property var navigationRoute: [regensburg, nurnberg, wurzburg, heilbronn, augsburg, ingolstadt]



    property bool centerOnPresentPosition: true

    Timer {
        id: positionTimer

        interval: 20 // milliseconds
        running: true
        repeat: true

        onTriggered: {

            var newPosition = PositionCalculator.calculateNewPosition(
                        mapDisplay.presentPosition.latitude,
                        mapDisplay.presentPosition.longitude, mapDisplay.speed,
                        mapDisplay.heading, interval / 1000)

            mapDisplay.presentPosition = QtPositioning.coordinate(
                        newPosition.latitude, newPosition.longitude)

            if (mapDisplay.centerOnPresentPosition) {
                map.center = mapDisplay.presentPosition
            }


            var newTrack1Position = PositionCalculator.calculateNewPosition(mapDisplay.track1Position.latitude,
                                                                            mapDisplay.track1Position.longitude,
                                                                            mapDisplay.track1Speed,
                                                                            mapDisplay.track1Heading,
                                                                            interval / 1000)

            mapDisplay.track1Position  = QtPositioning.coordinate(newTrack1Position.latitude, newTrack1Position.longitude)


            var newTrack2Position = PositionCalculator.calculateNewPosition(mapDisplay.track2Position.latitude,
                                                                            mapDisplay.track2Position.longitude,
                                                                            mapDisplay.track2Speed,
                                                                            mapDisplay.track2Heading,
                                                                            interval / 1000)

            mapDisplay.track2Position  = QtPositioning.coordinate(newTrack2Position.latitude, newTrack2Position.longitude)

        }
    }

    Plugin {
        id: mapPlugin
        name: 'osm'
    }

    function zoomIn() {
        if (map.zoomLevel < 20) {
            map.zoomLevel += 1
        }
    }

    function zoomOut() {
        if (map.zoomLevel > 6) {
            map.zoomLevel -= 1
        }
    }

    function selectTrackUp() {
        mapDisplay.mapOrientation = MapDisplay.MapOrientationType.Track_Up
    }

    function selectNorthUp() {
        mapDisplay.mapOrientation = MapDisplay.MapOrientationType.North_Up
    }

    Rectangle {
        id: mapArea

        width: parent.width
        height: parent.height * 0.8

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50

        color: 'red'

        Map {
            id: map

            width: parent.width
            height: parent.height

            plugin: mapPlugin
            bearing: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.Track_Up ? mapDisplay.heading : 0

            zoomLevel: 11

            copyrightsVisible: false

            DragHandler {
                id: drag
                target: null
                onTranslationChanged: {
                    //delta =>
                    map.pan(-delta.x, -delta.y)
                    mapDisplay.centerOnPresentPosition = false
                }
            }

            MapPolyline {
                id: currentRouteLegDisplay

                line.width: 4
                line.color: 'white'

                path: [ mapDisplay.presentPosition, mapDisplay.navigationRoute[0]]


            }

            MapPolyline {
                id: navigationRouteDisplay

                line.width: 3
                line.color: 'chartreuse'



                path: mapDisplay.navigationRoute
            }

            Repeater {

                model: mapDisplay.navigationRoute

                MapQuickItem {
                    coordinate: modelData

                    anchorPoint.x : waypointImage.width / 2
                    anchorPoint.y : waypointImage.height / 2

                    sourceItem: Rectangle {

                        id: waypointImage

                        width: 15
                        height: 15

                        radius: 180

                        color: 'green'
                    }
                }
            }


            MapQuickItem
            {
                id: ownship

                coordinate: mapDisplay.presentPosition

                anchorPoint.x: ownshipImage.width / 2
                anchorPoint.y: ownshipImage.height / 2


                sourceItem: Image {

                    id: ownshipImage

                    source: 'img/fighter-plane-basic.png'

                    width: 30
                    fillMode: Image.PreserveAspectFit

                    transform:

                        Rotation {

                            origin.x: ownshipImage.width / 2
                            origin.y: ownshipImage.width / 2

                            angle: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.North_Up ? mapDisplay.heading : 0
                        }
                }
            }

            MapQuickItem {
                id: track1

                coordinate: mapDisplay.track1Position

                anchorPoint.x: track1Image.width / 2
                anchorPoint.y: track1Image.height / 2

                sourceItem: Image {
                    id: track1Image

                    source: 'img/fighter-plane-basic.png'

                    width: 20
                    fillMode: Image.PreserveAspectFit

                    transform:

                        Rotation {
                            angle: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.North_Up ? mapDisplay.track1Heading : mapDisplay.track1Heading - mapDisplay.heading
                    }
                }
            }

            MapQuickItem {
                id: track2

                coordinate: mapDisplay.track2Position

                anchorPoint.x: track2Image.width / 2
                anchorPoint.y: track2Image.height / 2

                sourceItem: Image {
                    id: track2Image

                    source: 'img/fighter-plane-basic.png'

                    width: 20
                    fillMode: Image.PreserveAspectFit

                    transform:

                        Rotation {
                            angle: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.North_Up ? mapDisplay.track2Heading : mapDisplay.track2Heading - mapDisplay.heading
                    }
                }
            }
        }
    }

    Rectangle {
        id: bottomButtonArea
        color: 'transparent'

        width: parent.width
        height: parent.height * 0.1

        anchors {
            bottom: parent.bottom
        }

        Row {
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

                    Text {
                        anchors.centerIn: parent
                        text: mapDisplay.pages[index]
                        color: 'white'
                        fontSizeMode: Text.Fit
                        font.family: "Roboto Mono"
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: parent.color = "#404040"
                        onReleased: parent.color = "#2a2a2a"

                        onClicked: {
                            if (index == 0) {
                                zoomIn()
                            } else if (index == 1) {
                                zoomOut()
                            } else if (index == 2) {
                                mapDisplay.centerOnPresentPosition = true
                                map.center = mapDisplay.presentPosition
                            } else if (index == 3) {
                                selectTrackUp()
                            } else if (index == 4) {
                                selectNorthUp()
                            } else {
                                console.log('Button pressed on Map Display: '
                                            + mapDisplay.pages[index])
                            }
                        }
                    }
                }
            }
        }
    }
}
