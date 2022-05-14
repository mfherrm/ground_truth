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

        Rectangle {
            id: nameRect
            width: 100
            height: 40
            anchors.top: logo.bottom
            anchors.topMargin: 20
            anchors.left: logo.left
            color: "beige"
            border.color: "black"
            border.width: 1
        }
           Text {
                   id: nameText
                   text: "Name: "
                   color: "black"
                   font.pointSize: 20
                   anchors.centerIn: nameRect

               }

// Einfügen Rechteck und Textinput für Namenseingabe

            Rectangle {
               id: inputRect
               width: 200
               height: 40
               anchors.top: logo.bottom
               anchors.topMargin: 20
               anchors.left: nameRect.right
               anchors.leftMargin: 15
               color: "beige"
               border.color: "black"
               border.width: 1
           }

            TextInput {
                id: nameInput
                width: 180
                anchors.centerIn: inputRect
                text: "Username"
                font.pointSize: 20
                color: "black"
                cursorVisible: false
           }

// Einfügen Rechteck und Text für Quickstartguide

            Rectangle {
               id: qsRect
               width: 400
               height: 60
               anchors.top: nameRect.bottom
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
                anchors.top: nameRect.bottom
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
