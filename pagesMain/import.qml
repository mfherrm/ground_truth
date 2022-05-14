import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick 2.15
import "../components"
//Grundkörper
Page{
    Rectangle{
           id: rect
           color: "grey"
           border.color: "black"
           width: 380
           height: 620
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.verticalCenter: parent.verticalCenter
           anchors.left: parent.left
           anchors.leftMargin: 10
           anchors.top: parent.top
           anchors.topMargin: 10
           radius: 25



//      Item {
//          id: nextpg
//          width: 400
//          height: 640
//          visible: true

//          Button_import_back{
//                  MouseArea{
//                      anchors.fill:parent
//                      onClicked: { pgStack.replace(mainpg, mappg); mnStack.push(menupg);

//                      }
//                  }
//              }
//      }




//Überschrift der Importseite
           Text {
                   id: ueberschrift
                   text: "Import File"
                   color: "black"
                   font.family: "Helvetica"
                   font.pointSize: 20
                   font.bold: true
                   anchors.horizontalCenter: rect.horizontalCenter
                   anchors.top: rect.top
                   anchors.topMargin: 50
               }
//Platzierung zweier transparenter Rechtecke zur besseren Platzierung
           Rectangle { id: choose_search1; color: "transparent"; height: 40; width: 250;
                       anchors.top: rect.top; anchors.topMargin: 110}
           Rectangle { id: choose_search2; color: "transparent"; height: 40; width: 130
                       anchors.left: choose_search1.right; anchors.top: rect.top
                       anchors.topMargin: 110}
//Rahmen und Text zur Auswahl der Datei
           Rectangle {
                  id: choose_rand
                  color: "transparent"
                  border.color: "black"
                  width: 170
                  height: 40
                  anchors.horizontalCenter: choose_search1.horizontalCenter
                  anchors.verticalCenter: choose_search1.verticalCenter
                  radius: 50
           }

           Text {
                   id: choose
                   text: "Choose File"
                   color: "black"
                   font.family: "Helvetica"
                   font.pointSize: 16
                   anchors.horizontalCenter: choose_rand.horizontalCenter
                   anchors.verticalCenter: choose_rand.verticalCenter
               }
//Rahmen und Symbol zur Suche
           Rectangle {
                  id: search_rand
                  color: "transparent"
                  border.color: "black"
                  width: 40
                  height: 40
                  anchors.horizontalCenter: choose_search2.horizontalCenter
                  anchors.verticalCenter: choose_search2.verticalCenter
                  radius: 50
           }

           Text {
                   id: search
                   text: "Ch"
                   color: "black"
                   font.family: "Helvetica"
                   font.pointSize: 16
                   anchors.horizontalCenter: search_rand.horizontalCenter
                   anchors.verticalCenter: search_rand.verticalCenter
               }
//Platzierung und Überschrift zur zu selektierenden Datei
           Rectangle { id: select; color: "transparent"; height: 40; width: 250;
                       anchors.top: choose_search1.top; anchors.topMargin: 80}

           Rectangle {
                  id: select_rand
                  color: "transparent"
                  width: 150
                  height: 30
                  anchors.horizontalCenter: select.horizontalCenter
                  anchors.verticalCenter: select.verticalCenter
           }

           Text {
                   id: select_text
                   text: "Selected File:"
                   color: "black"
                   font.family: "Helvetica"
                   font.pointSize: 16
                   anchors.horizontalCenter: select_rand.horizontalCenter
                   anchors.verticalCenter: select_rand.verticalCenter
               }
//Rahmen und Name der Datei zur Darstellung
           Rectangle {
                  id: xyz
                  color: "transparent"
                  border.color: "black"
                  width: 350
                  height: 40
                  anchors.horizontalCenter: rect.horizontalCenter
                  anchors.top: select.bottom
                  anchors.topMargin: 20
                  radius: 20
           }

           Text {
                   id: datei
                   text: "datei.sql"
                   color: "black"
                   font.family: "Helvetica"
                   font.pointSize: 16
                   anchors.horizontalCenter: xyz.horizontalCenter
                   anchors.verticalCenter: xyz.verticalCenter
               }
// Console Rahmen und Text
           Rectangle {
                  id: console_rand
                  color: "transparent"
                  border.color: "black"
                  width: 350
                  height: 150
                  anchors.horizontalCenter: rect.horizontalCenter
                  anchors.top: xyz.bottom
                  anchors.topMargin: 40
                  radius: 20
           }

           Text {
                  id: console_text
                  text: "Console"
                  color: "black"
                  font.family: "Helvetica"
                  font.pointSize: 16
                  anchors.top: console_rand.top
                  anchors.topMargin: 10
                  anchors.left: console_rand.left
                  anchors.leftMargin: 10
               }

           }

}
