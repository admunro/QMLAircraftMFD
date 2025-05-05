import QtQuick 2.5
import QtLocation 5.6
import QtPositioning 5.5

import AircraftMFD 1.0

Rectangle {
    id: mapDisplay


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
    property real speed: 350 // knots

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

=======
    property int mapOrientation: MapDisplay.MapOrientationType.Track_Up
    property bool centerOnPresentPosition: true

    property var regensburg: QtPositioning.coordinate(49.0135470117391, 12.099220270621009)
    property var nurnberg: QtPositioning.coordinate(49.454248608301405, 11.079626073052278)
    property var wurzburg: QtPositioning.coordinate(49.7913484076446, 9.95397659969378)
    property var heilbronn: QtPositioning.coordinate(49.14312704599744, 9.209073192899)
    property var augsburg: QtPositioning.coordinate(48.36998485706096, 10.893213648008109)
    property var ingolstadt: QtPositioning.coordinate(48.7675412885771, 11.416398607163837)

    property var navigationRoute: [regensburg, nurnberg, wurzburg, heilbronn, augsburg, ingolstadt]


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

>>>>>>> origin/externalDataModel
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

<<<<<<< HEAD
            plugin: mapPlugin
            bearing: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.Track_Up ? mapDisplay.heading : 0
=======
            plugin: Plugin {
                name: 'osm'

                // PluginParameter { name: "osm.mapping.custom.host";
                //                   value: "https://a.tile.opentopomap.org/${z}/${x}/${y}.png" }

            }

            //activeMapType: supportedMapTypes[supportedMapTypes.length - 1]

            bearing: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.Track_Up ? ownshipModel.heading_deg : 0
>>>>>>> origin/externalDataModel

            zoomLevel: 11

            copyrightsVisible: false

<<<<<<< HEAD
            Image {

                id: ownshipImage

                source: 'img/plane.png'

                visible: mapDisplay.centerOnPresentPosition ? true : false

                width: 30
                height: 30

                anchors.centerIn: parent

                transform:

                    Rotation {
                        angle: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.North_Up ? mapDisplay.heading : 0
                    }
            }
        }
    }

=======

            Connections {
                target: ownshipModel

                function onPositionChanged() {
                    if (mapDisplay.centerOnPresentPosition) {
                        map.center = ownshipModel.position;
                    }
                }
            }

            DragHandler {
                id: drag
                target: null
                onTranslationChanged: function(delta) {
                    map.pan(-delta.x, -delta.y)
                    mapDisplay.centerOnPresentPosition = false
                }
            }

            MapPolyline {
                id: currentRouteLegDisplay

                line.width: 4
                line.color: 'white'

                path: [ ownshipModel.position, mapDisplay.navigationRoute[0]]

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

                coordinate: ownshipModel.position

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
                        origin.y: ownshipImage.height / 2

                        angle: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.North_Up ? ownshipModel.heading_deg : 0
                    }
                }
            }

            MapItemView {

                model: entityModel

                delegate: MapQuickItem {
                    coordinate: QtPositioning.coordinate(latitude, longitude)

                    sourceItem: Image {

                        id: entityImage

                        source: 'img/fighter-plane-basic.png'
                        width: 20
                        fillMode: Image.PreserveAspectFit
                        transform:
                            Rotation {

                            origin.x: entityImage.width / 2
                            origin.y: entityImage.height / 2

                            angle: mapDisplay.mapOrientation == MapDisplay.MapOrientationType.North_Up ? heading : heading - ownshipModel.heading_deg
                        }
                    }
                }
            }
        }
    }

>>>>>>> origin/externalDataModel
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
                        font.pixelSize: 12
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
<<<<<<< HEAD
                                map.center = mapDisplay.presentPosition
=======
>>>>>>> origin/externalDataModel
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
