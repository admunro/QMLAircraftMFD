import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: mfd
    width: 800
    height: 600
    color: "black"

    // Properties
    property var pages: [
        { name: "NAV", color: "#203040" },
        { name: "RADAR", color: "#302030" },
        { name: "COM", color: "#203020" },
        { name: "SYS", color: "#303020" },
        { name: "FUEL", color: "#302020" }
    ]

    property var leftButtonFunctions: {
        "NAV": ["ROUTE", "FPLN", "WPT", "NRST", "DATA"],
        "RADAR": ["MODE", "GAIN", "TILT", "STAB", "SCAN"],
        "COM": ["RADIO1", "RADIO2", "SATCOM", "DATALINK", "CALL"],
        "SYS": ["ELEC", "HYDR", "FUEL", "ENG", "STAT"],
        "FUEL": ["CALC", "ECON", "TANK", "XFER", "EST"]
    }

    property var rightButtonFunctions: {
        "NAV": ["TERR", "MAP", "WX", "ZOOM+", "ZOOM-"],
        "RADAR": ["RANGE+", "RANGE-", "BRT+", "BRT-", "CNTRL"],
        "COM": ["TUNE", "PRESET", "MSG", "LOG", "EMRG"],
        "SYS": ["TEST", "RESET", "CONFIG", "MAINT", "DIAG"],
        "FUEL": ["BURN", "FLOW", "RESET", "LOG", "ALERT"]
    }

    property string currentPage: pages[0].name

    // Main content area
    Rectangle {
        id: displayArea
        anchors {
            top: parent.top
            left: leftButtonColumn.right
            right: rightButtonColumn.left
            bottom: bottomButtonRow.top
            margins: 2
        }
        color: pages.find(page => page.name === currentPage).color

        Text {
            anchors.centerIn: parent
            text: currentPage + " PAGE"
            color: "white"
            font.pixelSize: 36
            font.family: "Roboto Mono"
        }
    }

    // Left side buttons
    Column {
        id: leftButtonColumn
        anchors {
            left: parent.left
            top: parent.top
            bottom: bottomButtonRow.top
            margins: 2
        }
        width: 100
        spacing: 2

        Repeater {
            model: 5

            Rectangle {
                width: parent.width
                height: (leftButtonColumn.height - (4 * 2)) / 5
                color: "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: leftButtonFunctions[currentPage][index]
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = "#404040"
                    onReleased: parent.color = "#2a2a2a"
                    onClicked: {
                        console.log("Left button clicked: " + leftButtonFunctions[currentPage][index])
                    }
                }
            }
        }
    }

    // Right side buttons
    Column {
        id: rightButtonColumn
        anchors {
            right: parent.right
            top: parent.top
            bottom: bottomButtonRow.top
            margins: 2
        }
        width: 100
        spacing: 2

        Repeater {
            model: 5

            Rectangle {
                width: parent.width
                height: (rightButtonColumn.height - (4 * 2)) / 5
                color: "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: rightButtonFunctions[currentPage][index]
                    color: "white"
                    font.pixelSize: 14
                    font.family: "Roboto Mono"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = "#404040"
                    onReleased: parent.color = "#2a2a2a"
                    onClicked: {
                        console.log("Right button clicked: " + rightButtonFunctions[currentPage][index])
                    }
                }
            }
        }
    }

    // Bottom buttons for page selection
    Row {
        id: bottomButtonRow
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 2
        }
        height: 60
        spacing: 2

        Repeater {
            model: pages

            Rectangle {
                width: (bottomButtonRow.width - ((pages.length - 1) * 2)) / pages.length
                height: parent.height
                color: currentPage === modelData.name ? "#404040" : "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: modelData.name
                    color: "white"
                    font.pixelSize: 18
                    font.family: "Roboto Mono"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentPage = modelData.name
                    }
                }
            }
        }
    }

    // MFD frame
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "#606060"
        border.width: 6
    }
}
