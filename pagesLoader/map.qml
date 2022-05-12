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
    property double mousePointX
    property double mousePointY
    property string damageType

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



        /*FeatureLayer {
            id: workingLayer
            featureTable:gdb.geodatabaseFeatureTablesByTableName["points"] ?
                             gdb.geodatabaseFeatureTablesByTableName["point"] :
                             null
            onComponentCompleted: {
                console.log("Geladen");
            }
        }*/

        FeatureLayer {
            id: featureLayer
                       // obtain the feature table from the geodatabase by name

        // declare as child of feature layer, as featureTable is the default property
        ServiceFeatureTable {
            id: featureTable
            url: "http://sampleserver6.arcgisonline.com/arcgis/rest/services/DamageAssessment/FeatureServer/0"

            // make sure edits are successfully applied to the service
            onApplyEditsStatusChanged: {
                if (applyEditsStatus === Enums.TaskStatusCompleted) {
                    console.log("successfully added feature");
                }
            }

            // signal handler for the asynchronous addFeature method
            onAddFeatureStatusChanged: {
                if (addFeatureStatus === Enums.TaskStatusCompleted) {
                    // apply the edits to the service
                    featureTable.applyEdits();
                }
            }

            onDeleteFeatureStatusChanged: {
                if (deleteFeatureStatus === Enums.TaskStatusCompleted) {
                    // apply the edits to the service
                    featureTable.applyEdits();
                }
            }
        }
        // signal handler for asynchronously fetching the selected feature
        onSelectedFeaturesStatusChanged: {
            if (selectedFeaturesStatus === Enums.TaskStatusCompleted) {
                while (selectedFeaturesResult.iterator.hasNext) {
                    // obtain the feature
                    var feat = selectedFeaturesResult.iterator.next();

                    // delete the feature in the feature table asynchronously
                    featureTable.deleteFeature(feat);
                }
            }
        }

        // signal handler for selecting features
        onSelectFeaturesStatusChanged: {
            if (selectFeaturesStatus === Enums.TaskStatusCompleted) {
                if (!selectFeaturesResult.iterator.hasNext)
                    return;

                var feat  = selectFeaturesResult.iterator.next();
                damageType = feat.attributes.attributeValue("typdamage");

                // show the callout
                callout.x = mousePointX;
                callout.y = mousePointY;
                callout.visible = true;
            }
        }
    }
        }

    QueryParameters {
        id: params
        maxFeatures: 1
    }

    // hide the callout after navigation
    onViewpointChanged: {
        callout.visible = false;
    }

    onMouseClicked: {  // mouseClicked came from the MapView
        // reset the map callout and update window
        featureLayer.clearSelection();
        callout.visible = false;

        mousePointX = mouse.x;
        mousePointY = mouse.y - callout.height;
        //! [DeleteFeaturesFeatureService identify feature]
        // call identify on the feature layer
        var tolerance = 10;
        var returnPopupsOnly = false;
        mV.identifyLayer(featureLayer, mouse.x, mouse.y, tolerance, returnPopupsOnly);
        //! [DeleteFeaturesFeatureService identify feature]
    }

    onIdentifyLayerStatusChanged: {
        if (identifyLayerStatus === Enums.TaskStatusCompleted) {
            if (identifyLayerResult.geoElements.length > 0) {
                // get the objectid of the identifed object
                params.objectIds = [identifyLayerResult.geoElements[0].attributes.attributeValue("objectid")];
                // query for the feature using the objectid
                featureLayer.selectFeaturesWithQuery(params, Enums.SelectionModeNew);
            }
        }
    }

    // map callout window
    Rectangle {
        id: callout
        width: row.width + (10 * scaleFactor) // add 10 for padding
        height: 40 * scaleFactor
        radius: 5
        border {
            color: "lightgrey"
            width: .5
        }
        visible: false

        MouseArea {
            anchors.fill: parent
            onClicked: mouse.accepted = true
        }

        Row {
            id: row
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                margins: 5 * scaleFactor
            }
            spacing: 10

            Text {
                text: damageType
                font.pixelSize: 18 * scaleFactor
            }

            Rectangle {
                radius: 100
                width: 22 * scaleFactor
                height: width
                color: "transparent"
                antialiasing: true
                border {
                    width: 2
                    color: "red"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: -4 * scaleFactor

                    text: "-"
                    font {
                        bold: true
                        pixelSize: 22 * scaleFactor
                    }
                    color: "red"
                }

                // create a mouse area over the (-) text to delete the feature
                MouseArea {
                    anchors.fill: parent
                    // once the delete button is clicked, hide the window and fetch the currently selected features
                    onClicked: {
                        callout.visible = false;
                        featureLayer.selectedFeatures();
                    }
                }
            }
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
                 /*var featureAttributes = {"ID_TAG" : tag, "ID_IMG_01": img, "COMMENT": comment };
                     console.log(featureAttributes.ID_TAG);
                 var point = ArcGISRuntimeEnvironment.createObject("Point", bm.center);
                     console.log(point);
                 var table = gdb.geodatabaseFeatureTablesByTableName["points"];
                     console.log(table);
                 var feature = table.createFeatureWithAttributes(featureAttributes, point);
                     console.log(feature);

                    table.addFeature(feature);
                    table.updateFeature(feature);
             console.log(table.numberOfFeatures);*/

             var featureAttributes = {"typdamage" : "Major", "primcause" : "Earthquake"};

             // create a new feature using the mouse's map point
             var feature = featureTable.createFeatureWithAttributes(featureAttributes,GeometryEngine.project(mV.currentViewpointCenter.center, mV.spatialReference));

             // add the new feature to the feature table
             featureTable.addFeature(feature);
             console.log(GeometryEngine.project(mV.currentViewpointCenter.center, mV.spatialReference));


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
                      onClicked: { mainStack.push("./map.qml"); uiStack.push("../pagesStackView/confButtons.qml"); addPoint();

                                  }
                  }
              }




     }











