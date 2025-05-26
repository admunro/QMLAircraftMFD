import QtQuick

//pragma NativeMethodBehavior: AcceptThisObject

Item  {
    id: root

    signal onClicked

    required property var onClickedHandler

    required property int buttonWidth
    required property int buttonHeight

    required property string buttonText
    required property int buttonIndex

    width: buttonWidth
    height: buttonHeight


    Rectangle {

        color: "#2a2a2a"
        border.color: 'grey'
        border.width: 4

        anchors.fill: parent
        radius: 5

        Text {
            anchors.centerIn: parent

            text: root.buttonText

            color: 'white'
            fontSizeMode: Text.Fit
            font.family: "Roboto Mono"
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (root.onClickedHandler && typeof root.onClickedHandler === 'function') {
                    root.onClickedHandler(root.buttonIndex);
                }
            }

            onPressed: parent.color = "#404040"
            onReleased: parent.color = "#2a2a2a"
        }
    }
}
