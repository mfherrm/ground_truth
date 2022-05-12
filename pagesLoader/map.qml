import QtQuick 2.15
import QtQuick.Controls 2.13
import QtLocation 5.11
import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.13
import QtQuick.Dialogs 1.3
import "../components"
import "../functions"


MapView {
    id: mV
    anchors.fill: parent
    wrapAroundMode: Enums.WrapAroundModeDisabled
    rotationByPinchingEnabled: true
    zoomByPinchingEnabled: true
    locationDisplay {

            }

    Map {
        id: bm
        // Set the initial basemap to Streets
        BasemapNationalGeographic { }

        ViewpointCenter {
            Point {
                x: 777031.07
                y: 7355887.32
                spatialReference: SpatialReference {
                     //UTM 35 S
                    wkid: 32735
                }
            }
            targetScale: 1e5

        }

        minScale: 100000000
        maxScale: 5000

        Geodatabase {
            id: gdb
            path: "../data/db_gt.geodatabase"

        }

        FeatureLayer {
            id: workingLayer
            featureTable:gdb.geodatabaseFeatureTablesByTableName["fact_point"] ?
                             gdb.geodatabaseFeatureTablesByTableName["fact_point"] :
                             null

        }

        FeatureLayer {
            id: lockedLayer
                       // obtain the feature table from the geodatabase by name
                       featureTable: gdb.geodatabaseFeatureTablesByTableName["import"] ?
                                         gdb.geodatabaseFeatureTablesByTableName["import"] :
                                         null
                       }
    }
    ComboBox{
        id: comboBoxBasemap
        anchors.left: parent.left
        anchors.top: parent.top
        width: 100
        height: 35
        currentIndex: 0
        model: ["Topographic","Streets","Imagery"]
        onCurrentTextChanged: {
                // Call this JavaScript function when the current selection changes
                if (bm.loadStatus === Enums.LoadStatusLoaded)
                    changeBasemap();
            }

            function changeBasemap() {
                // Determine the selected basemap, create that type, and set the Map's basemap
                switch (comboBoxBasemap.currentText) {
                case "Topographic":
                    bm.basemap = ArcGISRuntimeEnvironment.createObject("BasemapTopographic");
                    break;
                case "Streets":
                    bm.basemap = ArcGISRuntimeEnvironment.createObject("BasemapStreets");
                    break;
                case "Imagery":
                    bm.basemap = ArcGISRuntimeEnvironment.createObject("BasemapImagery");
                    break;
                default:
                    bm.basemap = ArcGISRuntimeEnvironment.createObject("BasemapTopographic");
                    break;
                }
            }

    }
    Grid{
        columns: 4
        spacing: 5
        Text{text: "0"; width:10; height: 10}
        Row{Rectangle {color: "black"; height: 10; id:m1}
        Rectangle {color: "white"; border.color: "black"; height: 10; id:m2} }
        Text{width: 60; height: 10; id: ms}

        anchors.left: mV.left
        anchors.leftMargin: 15
        anchors.bottom: mV.bottom
        anchors.bottomMargin: 60



    }
    // 1 px = mV.unitsPerDIP m
    // Scale:  1: mV.mapScale
        property int tWid: 50 // target width
     onMapScaleChanged: {
         m1.width=   ( tWid *
                 ( ( Math.round(
                      ( tWid *mV.unitsPerDIP ) / Math.pow( 10, ( Math.round(tWid*mV.unitsPerDIP, 0)).toString().length-1 ) ,0)
                  * Math.pow(10, ( Math.round(tWid*mV.unitsPerDIP, 0)).toString().length-1 ) )
                 /(tWid *mV.unitsPerDIP) ) )
                 /2 ;
         m2.width= ( tWid *
                    ( ( Math.round(
                         ( tWid *mV.unitsPerDIP ) / Math.pow( 10, ( Math.round(tWid*mV.unitsPerDIP, 0)).toString().length-1 ) ,0)
                     * Math.pow(10, ( Math.round(tWid*mV.unitsPerDIP, 0)).toString().length-1 ) )
                    /(tWid *mV.unitsPerDIP) ) )
                    /2;
         console.log(Math.pow( 10, ( Math.round(tWid*mV.unitsPerDIP, 0)).toString().length-1 )); ms.text=((m1.width * mV.unitsPerDIP/500 >= 1)?(m1.width*mV.unitsPerDIP/500).toFixed(0) +"km":(m1.width*mV.unitsPerDIP*2).toFixed(0)+"m");}

         function addPoint(tag, img, comment){
                 var featureAttributes = {"ID_TAG" : tag, "ID_IMG_01": img, "COMMENT": comment };
                     console.log(featureAttributes.ID_TAG);
                 var point = ArcGISRuntimeEnvironment.createObject("Point", bm.center);
                     console.log(point);
                 var table = gdb.geodatabaseFeatureTablesByTableName["fact_point"];
                     console.log(table);
                 var feature = table.createFeatureWithAttributes(featureAttributes, point);
                     console.log(feature);

                    table.addFeature(feature);
             console.log(table.numberOfFeatures);


             }

              Button_half{
                 id: cancel_geom
                 anchors.left: parent.left
                 anchors.leftMargin: 5
                 text: "Cancel"

                 MouseArea{
                     anchors.fill:parent
                     onClicked: { mainStack.push("./map.qml"); menuLoad.source="../pagesLoader/menu.qml";

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
                      onClicked: { mainStack.push("./map.qml"); uiStack.push("../pagesStackView/confButtons.qml"); addPoint("1", "1", "Testpunkt"); workingLayer.resetFeaturesVisible();

                                  }
                  }
              }




     }











