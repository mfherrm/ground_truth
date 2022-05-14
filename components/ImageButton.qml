import QtQuick 2.2
import QtGraphicalEffects 1.0

Rectangle {
    property alias source : buttonImage.source
    property alias image: buttonImage
    color: "transparent"

    id: button
    width: 32
    height: 32

    Image {
        id: buttonImage
        anchors.fill: parent
        fillMode : Image.PreserveAspectFit
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
         onClicked: {}
        }
    }
