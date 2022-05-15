import QtQuick 2.0
import QtQuick.Controls 2.13
import "../components"

Page{

    Rectangle{
           id: rect
           color: "beige"
           anchors.fill: parent

 //App Logo (Platzhalter)
        Image {
            id: logo
            source: "../images/Logo_IMG.png"
            anchors.top: rect.top
            anchors.topMargin: 10
            anchors.left: rect.left
            anchors.leftMargin: 75


        }

//Einfügen Rechteck und Text für Namenseingabe

        TextField{
            id: nameText
            placeholderText: "Enter your name"
            placeholderTextColor: "grey"
            width: logo.width
            height: parent.height-600
            anchors.top:logo.bottom
            anchors.left: logo.left


        }

            Rectangle {
               id: qsRect
               width: 400
               height: 60
               anchors.top: nameText.bottom
               anchors.topMargin: 20
               color: "beige"
               border.color: "black"
               border.width: 1
               //CustomBorder
               //{
                 //  commonBorder: false
                   //lBorderwidth: 1
                   //rBorderwidth: 1
                   //tBorderwidth: 1
                   //bBorderwidth: 0
                   //borderColor: "black"
               //}
           }

            Text {
                    id: qsText
                    text: "Quickstartquide"
                    color: "black"
                    font.pointSize: 20
                    anchors.centerIn: qsRect
                  }

            //Button für Dropdown

            Rectangle{
                id: qsbutton
                width: 60
                height: 60
                anchors.right: qsRect.right
                anchors.top: nameText.bottom
                anchors.topMargin: 20
                color: "beige"
                border.color: "black"
                border.width: 1
            }


// Einfügen Rechteck und Text für Imprint

            Rectangle {
               id: imRect
               width: 400
               height: 60
               anchors.top: qsRect.bottom
               color: "beige"
               border.color: "black"
               border.width: 1
           }

            Text {
                    id: imText
                    text: "Imprint"
                    color: "black"
                    font.pointSize: 20
                    anchors.centerIn: imRect
                  }

//Button für Dropdown
            Rectangle{
                id: imbutton
                width: 60*scaleFactor
                height: 60*scaleFactor
                anchors.right: imRect.right
                anchors.top: qsRect.bottom
                color: "beige"
                border.color: "black"
                border.width: 1
            }


            Button_wide{
                text: "Go"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea{
                    anchors.fill:parent
                    onClicked: { mainStack.push("../pagesMain/map.qml"); mainStack.push("../pagesMain/map.qml"); menuLoad.source="../pagesMain/menu.qml";

                    }
                }
            }
}

}
