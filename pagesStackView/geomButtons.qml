import QtQuick 2.0
import QtQuick.Controls 2.13
import "../components"
import "../functions"
import Esri.ArcGISRuntime 100.13



Rectangle{
    id: frame_data
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    width: 400
    height: 640
    visible: true
    anchors.right: parent.right
    color: "transparent"

    Geodatabase {
        id: gdb
        path: "../data/db_gt.geodatabase"

    }

    function addPoint(tag, img, comment){
            var featureAttributes = {"ID_TAG" : tag, "ID_IMG_01": img, "COMMENT": comment };
                console.log(featureAttributes.ID_TAG);
            var point = ArcGISRuntimeEnvironment.createObject("Point", {x: frame_data.horizontalCenter, y: frame_data.verticalCenter});
                console.log(point.y);
            var table = gdb.geodatabaseFeatureTablesByTableName["fact_point"];
                console.log(table);
            var feature = table.createFeature(point); //WithAttributes(featureAttributes, point);
                console.log(feature);

           table.addFeature(feature);

        }

         Button_half{
            id: cancel_geom
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: "Cancel"

            MouseArea{
                anchors.fill:parent
                onClicked: { mainStack.push("../pagesLoader/map.qml"); menuLoad.source="../pagesLoader/menu.qml";

                }
            }
        }


         Button_half{
            id: accept_geom
            anchors.right: parent.right
            anchors.rightMargin: 5
            text: "Confirm"
             MouseArea{
                 anchors.fill:parent
                 onClicked: { mainStack.push("../pagesLoader/map.qml"); uiStack.push("confButtons.qml"); addPoint("1", "1", "Testpunkt");

                             }
             }
         }




}

