import QtQuick 2.15




Rectangle
{

    property real fillPercentage

    property int displayWidth
    property int displayHeight

    property int marginWidth: 2

    width: displayWidth + marginWidth*2
    height: displayHeight + marginWidth*2

    color: 'darkgrey'



    Rectangle
    {
        width: displayWidth
        height: displayHeight

        anchors.centerIn: parent

        color: 'black'

        Rectangle
        {
            id: tankFillLevel

            anchors.bottom: parent.bottom

            height: parent.height * fillPercentage/100
            width: parent.width

            color: 'blue'
        }

        Text
        {
            id: tankFillText

            anchors.centerIn: parent

            text: fillPercentage + " %"
            color: "white"
            fontSizeMode: Text.Fit
            font.family: "Roboto Mono"
            font.bold: true
        }

    }

}
