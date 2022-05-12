import QtQuick 2.0
import QtQuick.Controls 2.13
import "../components"

// Background: transparent
Rectangle{
    id: start_buttons
    anchors.fill: parent
    color: "transparent"

    // Button to start the editing
    Button_wide{
        id: start_edit_button
        text: "Start Editing"
        MouseArea{
            anchors.fill:parent
            onClicked: { /*uiStack.push("geomButtons.qml"); */menuLoad.source =""; start_edit_button.visible=false;
            }
        }
    }

    // Button showing the north arrow + pressing it, returns to initial Viewpoint
    RoundButton_map{
        id: north_arrow_button
        anchors.top: parent.top
        anchors.left: parent.left
        text: "A"
    }

    // Button to turn GPS function on/off
    RoundButton_map{
        id: gps_button
        anchors.top: north_arrow_button.bottom
        anchors.left: parent.left
        text: "S"
    }

    // Button to open layer selection
    RoundButton_map{
        id: layer_button
        anchors.top: gps_button.bottom
        anchors.left: parent.left
        text: "Layer"
    }

    // Button to open the legend
    RoundButton_map{
        id: legend_button
        anchors.top: layer_button.bottom
        anchors.left: parent.left
        text: "Legende"
    }

}
