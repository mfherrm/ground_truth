import QtQuick 2.0
import "../components"

Rectangle{
    id: start_buttons
    width: 400
    height: 640
    anchors{
        right: parent.right
        top: parent.top
    }
    color: "transparent"
    Button_wide{
        text: "Go"
        MouseArea{
            anchors.fill:parent
            onClicked: { mainStack.push("../pagesLoader/map.qml"); mainStack.push("../pagesLoader/map.qml"); uiStack.push("mapButtons.qml"); uiStack.push("mapButtons.qml"); menuLoad.source="../pagesLoader/menu.qml";

            }
        }
    }
}
