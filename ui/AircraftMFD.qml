import QtQuick 2.15


Rectangle {
    id: mfd
    width: 800
    height: 600
    color: "dimgrey"

    // Properties
    property var pages: [
        { name: "NAV",   color: "#203040" },
        { name: "RADAR", color: "#302030" },
        { name: "COM",   color: "#203020" },
        { name: "SYS",   color: "#303020" },
        { name: "FUEL",  color: "#302020" }
    ]

    // Signal properties to communicate with page components
    signal leftButtonClicked(int index)
    signal rightButtonClicked(int index)
    signal bottomButtonClicked(string pageName)

    // Properties to receive button captions from the active page
    property var leftButtonCaptions: ["L1", "L2", "L3", "L4", "L5"]  // Placeholders
    property var rightButtonCaptions: ["R1", "R2", "R3", "R4", "R5"] // Placeholders

    property string currentPage: pages[0].name

    // Main content area with Loader for different pages
    Rectangle {
        id: displayArea
        anchors {
            top: parent.top
            left: leftButtonColumn.right
            right: rightButtonColumn.left
            margins: 2
            topMargin: 50
        }
        color: "red"

        height: parent.height * 0.8

        Loader {
            id: pageLoader
            anchors.fill: parent
            source: {
                switch(mfd.currentPage) {
                    case "NAV": return "NavPage.qml";
                    case "RADAR": return "RadarPage.qml";
                    case "COM": return "ComPage.qml";
                    case "SYS": return "SysPage.qml";
                    case "FUEL": return "TemplatePage.qml";
                    default: return "";
                }
            }

            onLoaded: {
                if (item) {
                    // Set properties on the page
                    item.pageColor = mfd.pages.find(page => page.name === currentPage).color;
                    item.pageName = currentPage;

                    // Connect signals
                    leftButtonClicked.connect(item.handleLeftButton);
                    rightButtonClicked.connect(item.handleRightButton);

                    // Get button captions from the page
                    leftButtonCaptions = item.leftButtonCaptions;
                    rightButtonCaptions = item.rightButtonCaptions;

                    // Connect to property changes for button captions
                    item.leftButtonCaptionsChanged.connect(function() {
                        leftButtonCaptions = item.leftButtonCaptions;
                    });
                    item.rightButtonCaptionsChanged.connect(function() {
                        rightButtonCaptions = item.rightButtonCaptions;
                    });
                }
            }

            // Clean up connections when page changes
            onSourceChanged: {
                if (item) {
                    mfd.leftButtonClicked.disconnect(item.handleLeftButton);
                    mfd.rightButtonClicked.disconnect(item.handleRightButton);
                }
            }
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
            topMargin: 150
        }
        width: 100
        spacing: 40

        Repeater {
            model: 5

            anchors.top: parent.top

            Rectangle {

                width: parent.width * 0.8
                height: 70

                anchors.horizontalCenter: parent.horizontalCenter

                color: "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: leftButtonCaptions[index]
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
                        console.log("Left button clicked: " + mfd.index);
                        leftButtonClicked(index);
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
            topMargin: 150
        }
        width: 100
        spacing: 40

        Repeater {
            model: 5

            Rectangle {

                anchors.horizontalCenter: parent.horizontalCenter

                width: parent.width * 0.8
                height: 70
                color: "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: rightButtonCaptions[index]
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
                        console.log("Right button clicked: " + index);
                        rightButtonClicked(index);
                    }
                }
            }
        }
    }

    // Bottom buttons for page selection
    Row {
        id: bottomButtonRow
        anchors {
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            margins: 2
            leftMargin: 150
            bottomMargin: 30
        }
        height: 60
        spacing: 40

        Repeater {
            model: mfd.pages

            Rectangle {
                width: 70
                height: 70
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
                        bottomButtonClicked(modelData.name);
                        currentPage = modelData.name;
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
