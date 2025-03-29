import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: pageName // Change this to the actual page name (e.g., comPage)
    anchors.fill: parent

    // Properties to be set by the loader
    property string pageName: "PAGE_NAME" // Replace with actual page name
    property color pageColor: "#000000" // Replace with page color

    // Button captions that will be read by the main MFD
    property var leftButtonCaptions: ["BTN1", "BTN2", "BTN3", "BTN4", "BTN5"] // Replace with actual functions
    property var rightButtonCaptions: ["BTN1", "BTN2", "BTN3", "BTN4", "BTN5"] // Replace with actual functions

    // Function handlers for button events from the main MFD
    function handleLeftButton(index) {
        console.log("Left button pressed in " + pageName + " page: " + leftButtonCaptions[index]);

        switch(leftButtonCaptions[index]) {
            case "BTN1":
                // Handle button 1 functionality
                break;
            case "BTN2":
                // Handle button 2 functionality
                break;
            case "BTN3":
                // Handle button 3 functionality
                break;
            case "BTN4":
                // Handle button 4 functionality
                break;
            case "BTN5":
                // Handle button 5 functionality
                break;
        }
    }

    function handleRightButton(index) {
        console.log("Right button pressed in " + pageName + " page: " + rightButtonCaptions[index]);

        switch(rightButtonCaptions[index]) {
            case "BTN1":
                // Handle button 1 functionality
                break;
            case "BTN2":
                // Handle button 2 functionality
                break;
            case "BTN3":
                // Handle button 3 functionality
                break;
            case "BTN4":
                // Handle button 4 functionality
                break;
            case "BTN5":
                // Handle button 5 functionality
                break;
        }
    }

    // Page-specific properties go here

    color: pageColor

    // Main content area
    Rectangle {
        id: mainDisplay
        anchors {
            top: titleText.bottom
            left: parent.left
            right: parent.right
            bottom: statusBar.top
            margins: 10
        }
        color: Qt.darker(pageColor, 1.2)
        border.color: "white"
        border.width: 1

        // Add page-specific content here
        Text {
            anchors.centerIn: parent
            text: pageName + " Content Goes Here"
            color: "white"
            font.pixelSize: 20
            font.family: "Roboto Mono"
        }
    }

    // Status bar
    Rectangle {
        id: statusBar
        width: parent.width * 0.8
        height: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.color: "white"
        border.width: 1

        // Add status information here
        Text {
            anchors.centerIn: parent
            text: "Status Information"
            color: "white"
            font.pixelSize: 14
            font.family: "Roboto Mono"
        }
    }

    // Title
    Text {
        id: titleText
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: pageName + " DISPLAY"
        color: "white"
        font.pixelSize: 18
        font.bold: true
        font.family: "Roboto Mono"
    }
}
