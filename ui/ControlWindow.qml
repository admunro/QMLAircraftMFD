import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Window {

    title: qsTr("Scenario Control")

    id: controlsWindow

    width: 800
    height: 1000

    visible: true

    TabBar {

        id: bar
        width: parent.width

        TabButton {
            text: "Entities"


        }

        TabButton {
            text: "Ownship"


        }
    }

    StackLayout {
        width: parent.width

        anchors.top: bar.bottom
        anchors.bottom: parent.bottom

        currentIndex: bar.currentIndex

        Item {
            id: entitiesTab

            EntityControl {
                id: entityControl

                anchors.fill: parent
            }

        }

        Item {
            id: ownshipTab

            OwnshipControl {
                id: ownshipControls
            }
        }

    }
}


