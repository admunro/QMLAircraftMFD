import QtQuick 2.15


Rectangle {

    id: mfd
    color: "black"

    width: 800
    height: 800

    anchors.centerIn: parent
    anchors.margins: { top: 40; bottom: 5; left: 5; right: 5 }


    // Properties
    property var pages: [
        { name: "NAV",    source: "NavPage.qml",      color: "#203040" },
        { name: "STORE",  source: "StorePage.qml",    color: "#302030" },
        { name: "SNSR",   source: "SensorPage.qml",   color: "#203020" },
        { name: "FUEL",   source: "FuelPage.qml",     color: "#303020" },
        { name: "ENG",    source: "EnginePage.qml",   color: "#302020" }
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


    Rectangle {
        color: 'dimgrey'
        width: parent.width - 2
        height: parent.height - 2

        anchors.centerIn: parent
    }

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
        width: parent.width * 0.8

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
            verticalCenter: parent.verticalCenter

        }

        width: parent.width / 8
        height: displayArea.height
        spacing: parent.height / 20

        Repeater {
            
            id: leftRepeater
            model: 5
            
            Rectangle {

                width: parent.width * 0.8
                height: width

                anchors.horizontalCenter: parent.horizontalCenter

                color: "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: mfd.leftButtonCaptions[index]
                    color: "white"
                    fontSizeMode: Text.Fit
                    font.family: "Roboto Mono"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = "#404040"
                    onReleased: parent.color = "#2a2a2a"
                    onClicked: {
                        mfd.leftButtonClicked(index);
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
            verticalCenter: parent.verticalCenter
        }

        width: parent.width / 8
        height: displayArea.height
        spacing: parent.height / 20

        Repeater {

            id: rightRepeater
            model: 5

            Rectangle {

                width: parent.width * 0.8
                height: width

                anchors.horizontalCenter: parent.horizontalCenter

                color: "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: mfd.rightButtonCaptions[index]
                    color: "white"
                    fontSizeMode: Text.Fit
                    font.family: "Roboto Mono"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = "#404040"
                    onReleased: parent.color = "#2a2a2a"
                    onClicked: {
                        mfd.rightButtonClicked(index);
                    }
                }
            }
        }
    }

    // Bottom buttons for page selection
    Row {
        id: bottomButtonRow
        anchors {
            bottom: parent.bottom
            margins: 2
            horizontalCenter: parent.horizontalCenter
        }
        height: parent.height / 10
        spacing: parent.width / 20

        Repeater {
            model: mfd.pages

            Rectangle {

                height: parent.height * 0.8
                width: height

                color: index == mfd.currentPage ? "#404040" : "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: mfd.pages[index].name
                    color: "white"
                    fontSizeMode: Text.Fit
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
