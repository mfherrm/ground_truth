import QtQuick 2.9
import QtQuick.Controls 2.2

Column {
    width: parent.width-10
    height: parent.height-300
    property alias model: columnRepeater.model
    property alias cLab: columnRepeater.cLab

    ListView {
        id: columnRepeater
        delegate: accordion

        width: parent.width
        height: parent.height

        model: ListModel { }

        ScrollBar.vertical: ScrollBar { }
        property string cLab:""

    }

    Component {
        id: accordion
        Column {
            width: parent.width
            property int itemIndex: index
            Item {
                id: infoRow

                width: parent.width
                height: childrenRect.height
                property bool expanded : false

                Image {
                    id: carot

                    anchors {
                        top: parent.top
                        left: parent.left
                        margins: 5
                    }

                    sourceSize.width: 16
                    sourceSize.height: 16
                    source: "../images/triangle.svg"
                    visible: childrent.count > 0 ? true : false
                    transform: Rotation {
                        origin.x: 5
                        origin.y: 10
                        angle: infoRow.expanded ? 90 : 0
                        Behavior on angle { NumberAnimation { duration: 150 } }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: (infoRow.expanded = !infoRow.expanded)
                        enabled: childrent ? true : false
                    }
                }

                Text {
                    anchors {
                        left: carot.visible ? carot.right : parent.left
                        top: parent.top
                        margins: 5
                        id: lclass
                    }

                    visible: parent.visible
                    text: label

                    MouseArea{
                        anchors.fill: parent
                        onClicked:{ (infoRow.expanded = !infoRow.expanded);}
                    }
                }

                Text {
                    visible: infoRow.visible

                    text: type

                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 5
                        rightMargin: 15
                    }
                }
            }

            ListView {
                id: subentryColumn
                x: 20
                width: parent.width - x
                height: childrenRect.height * opacity
                visible: opacity > 0
                opacity: infoRow.expanded ? 1 : 0
                delegate: accordion2
                model: childrent ? childrent : []
                interactive: false
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }
    }


  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Component {
        id: accordion2
        Column {
            width: parent.width
            property int itemIndex: index
            Item {
                id: infoRow2

                width: parent.width
                height: childrenRect.height
                property bool expanded: false




                Image {
                    id: carot2

                    anchors {
                        top: parent.top
                        left: parent.left
                        margins: 5
                    }

                    sourceSize.width: 16
                    sourceSize.height: 16
                    source: "../images/triangle.svg"
                    visible: childrent.count > 0 ? true : false
                    transform: Rotation {
                        origin.x: 5
                        origin.y: 10
                        angle: infoRow2.expanded ? 90 : 0
                        Behavior on angle { NumberAnimation { duration: 150 } }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: (infoRow2.expanded = !infoRow2.expanded)
                        enabled: childrent ? true : false
                    }
                }

                Text {
                    anchors {
                        left: carot2.visible ? carot2.right : parent.left
                        top: parent.top
                        margins: 5
                        id: lclass2
                    }

                    visible: parent.visible
                    text: label

                    MouseArea{
                        anchors.fill: parent
                        onClicked:{ (infoRow2.expanded = !infoRow2.expanded); }
                    }
                }

                Text {
                    visible: infoRow2.visible

                    text: type

                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 5
                        rightMargin: 15
                    }
                }
            }

            ListView {
                id: subentryColumn2
                x: 20
                width: parent.width - x
                height: childrenRect.height * opacity
                visible: opacity > 0
                opacity: infoRow2.expanded ? 1 : 0
                delegate: accordion3
                model: childrent ? childrent : []
                interactive: false

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }
    }

    //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

      Component {
          id: accordion3
          Column {
              width: parent.width
              property int itemIndex: index
              Item {
                  id: infoRow3

                  width: parent.width
                  height: childrenRect.height
                  property bool expanded: false

                  Text {
                      anchors {
                          left: parent.left
                          top: parent.top
                          margins: 5
                          id: lclass3
                      }

                      visible: parent.visible
                      text: label

                      MouseArea{
                          anchors.fill: parent
                          onClicked:{columnRepeater.cLab=label; console.log(columnRepeater.cLab);}
                      }
                  }
              }
          }
      }

}
