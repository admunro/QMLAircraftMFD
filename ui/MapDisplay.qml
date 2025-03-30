import QtQuick
import QtLocation
import QtPositioning

Rectangle
{
    id: mapDisplay

    color: 'dimGrey'

    property var pages: [ "Map 1", "Map 2", "Map 3", "Map 4", "Map 5" ]

    Plugin
    {
        id: mapPlugin
        name: 'osm'
    }

    Map
    {
        id: map

        width: parent.width - 30
        height: parent.height * 0.83

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30

        plugin: mapPlugin
        center: QtPositioning.coordinate(48.7232, 11.5515) // Manching Airport
        zoomLevel: 11

        copyrightsVisible: false

        PinchHandler
        {
            id: pinch
            target: null
            onActiveChanged: if (active) {
                map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
            }
            onScaleChanged: (delta) => {
                map.zoomLevel += Math.log2(delta)
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            onRotationChanged: (delta) => {
                map.bearing -= delta
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            grabPermissions: PointerHandler.TakeOverForbidden
        }

        WheelHandler
        {
            id: wheel
            // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
            // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
            // and we don't yet distinguish mice and trackpads on Wayland either
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                             ? PointerDevice.Mouse | PointerDevice.TouchPad
                             : PointerDevice.Mouse
            rotationScale: 1/120
            property: "zoomLevel"
        }

        DragHandler
        {
            id: drag
            target: null
            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
        }

        Shortcut
        {
            enabled: map.zoomLevel < map.maximumZoomLevel
            sequence: StandardKey.ZoomIn
            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
        }

        Shortcut
        {
            enabled: map.zoomLevel > map.minimumZoomLevel
            sequence: StandardKey.ZoomOut
            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
        }
    }



    Row {
        id: bottomButtonRow

        anchors.bottom: parent.bottom

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 30

        height: 60
        spacing: 40

        Repeater {
            model: mapDisplay.pages

            Rectangle
            {
                width: 70
                height: 70

                color: "#2a2a2a"

                border.color: 'black'
                border.width: 1


                Text
                {
                    anchors.centerIn: parent
                    text: mapDisplay.pages[index]
                    color: 'white'
                    font.pixelSize: 18
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
                        console.log('Button pressed on Map Display: ' + mapDisplay.pages[index])
                    }
                }
            }
        }
    }
}
