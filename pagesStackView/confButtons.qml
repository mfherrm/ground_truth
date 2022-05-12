import QtQuick 2.0
import QtQuick.Controls 2.13
import "../components/"
import "../functions/addPoint.js" as AddPoint

    Rectangle{
           id: rect_geom
           color: "beige"
           width: 380
           height: 620
           radius: 7
           anchors.left: parent.left
           anchors.leftMargin: 10
           anchors.top: parent.top
           anchors.topMargin: 10

           Text {
                   id: infoText
                   text: "Geometry"
                   color: "black"
                   anchors.top: parent.top
                   anchors.topMargin: 10
                   anchors.horizontalCenter: parent.horizontalCenter
               }
           Button_half{
              id: cancel_conf
              anchors.left: parent.left
              anchors.leftMargin: 5
              anchors.bottom: parent.bottom
              anchors.bottomMargin: 2
              width: 188
              text: "Cancel"

              MouseArea{
                  anchors.fill:parent
                  onClicked: { uiStack.pop(); menuLoad.source="../pagesLoader/menu.qml";
                  }
              }
          }

           Button_half{
              id: accept_conf
              anchors.right: parent.right
              anchors.rightMargin: 5
              anchors.bottom: parent.bottom
              anchors.bottomMargin: 2
              width: 188
              text: "Submit"
               MouseArea{
                   anchors.fill:parent
                   onClicked: { uiStack.pop(); menuLoad.source="../pagesLoader/menu.qml";

                               }
               }
           }

}
