import QtQuick 2.15


Rectangle {
    id: mfd
    width: 800
    height: 600
    color: "dimgrey"

    // Properties
    property var pages: [
        { name: "NAV",   source: "NavPage.qml", color: "#203040" },
        { name: "RADAR", source: "RadarPage.qml", color: "#302030" },
        { name: "COM",   source: "ComPage.qml", color: "#203020" },
        { name: "SYS",   source: "SysPage.qml", color: "#303020" },
        { name: "FUEL",  source: "TemplatePage.qml", color: "#302020" }
    ]


    // Signal properties to communicate with page components
    signal leftButtonClicked(int index)
    signal rightButtonClicked(int index)
    signal bottomButtonClicked(string pageName)

    // Properties to receive button captions from the active page
    property var leftButtonCaptions: ["L1", "L2", "L3", "L4", "L5"]  // Placeholders
    property var rightButtonCaptions: ["R1", "R2", "R3", "R4", "R5"] // Placeholders

    property int currentPage: 0
    property var currentItem // This is the QtObject that is currently loaded in the display. It's set by the Loader.


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
                    mfd.pages[mfd.currentPage].source;
            }

            onLoaded: {
                if (item) {
                    // Set properties on the page

                    mfd.currentItem = item

                    item.pageColor = mfd.pages[mfd.currentPage].color;
                    item.pageName = mfd.pages[mfd.currentPage].name;

                    // Connect signals
                    mfd.leftButtonClicked.connect(item.handleLeftButton);
                    mfd.rightButtonClicked.connect(item.handleRightButton);

                    // Get button captions from the page
                    mfd.leftButtonCaptions = item.leftButtonCaptions;
                    mfd.rightButtonCaptions = item.rightButtonCaptions;
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

            id: rightRepeater
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
                color: mfd.pages[mfd.currentPage].color
                border.color: "#3a3a3a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: mfd.pages[index].name
                    color: "white"
                    font.pixelSize: 18
                    font.family: "Roboto Mono"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        if (index != mfd.currentPage)
                        {
                            // Disconnect the button handlers from the currently selected page

                            if (mfd.currentItem)
                            {
                                mfd.leftButtonClicked.disconnect(mfd.currentItem.handleLeftButton);
                                mfd.rightButtonClicked.disconnect(mfd.currentItem.handleRightButton);
                            }

                            // Set the new page index. The Loader object will handle new connections
                            mfd.currentPage = index;
                        }
                    }
                }
            }
        }
    }
}
