import QtQuick 2.15
import QtQuick.Controls 2.13
import QtLocation 5.11
import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.13
import QtQuick.Dialogs 1.3
import "../components"

Page{
    property double mousePointX
    property double mousePointY
    property string damageType
    property QtObject vp

    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------

    MapView {
        id: mV
        anchors.fill: parent
        wrapAroundMode: Enums.WrapAroundModeDisabled
        rotationByPinchingEnabled: true
        zoomByPinchingEnabled: true


        //----------------------------------------------------------------------------------------------------------------------------------------------------------------------

        Map {
            id: bm

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


            FeatureLayer {
                id: featureLayer

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

                    // apply the edits to the service
                    onDeleteFeatureStatusChanged: {
                        if (deleteFeatureStatus === Enums.TaskStatusCompleted) {
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


        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------

        QueryParameters {
            id: params
            maxFeatures: 1
        }

        // hide the callout after navigation
        onViewpointChanged: {
            callout.visible = false;
        }

        onMouseClicked: {
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

        //Scale bar

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
            ms.text=((m1.width * mV.unitsPerDIP/500 >= 1)?(m1.width*mV.unitsPerDIP/500).toFixed(0) +"km":(m1.width*mV.unitsPerDIP*2).toFixed(0)+"m"); /*console.log(Math.pow( 10, ( Math.round(tWid*mV.unitsPerDIP, 0)).toString().length-1 )); */}


    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //
    Button_wide{

        id: start_edit_button
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: "Start Editing"
        z:10
        MouseArea{
            anchors.fill: parent
            onClicked: {
                menuLoad.source ="";
                start_edit_button.visible= false;
                accept_geom.visible=true;
                cancel_geom.visible=true;
                north_arrow_button.visible=false;
                gps_button.visible=false;
                layer_button.visible=false;
                console.log("Stated editing");
            }
        }
    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Button_half{
        visible: false
        id: cancel_geom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: "Cancel"

        MouseArea{
            anchors.fill:parent
            onClicked: {
                start_edit_button.visible= true;
                menuLoad.source="../pagesMain/menu.qml";
                north_arrow_button.visible=true;
                gps_button.visible=true;
                layer_button.visible=true;
                accept_geom.visible=false;
            }
        }
    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Button_half{
        visible: false
        id: accept_geom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 5
        text: "Confirm"

        MouseArea{
            anchors.fill:parent
            onClicked: {
                //addPoint();
                north_arrow_button.visible=true;
                gps_button.visible=true;
                layer_button.visible=true;
                rect_conf.visible=true;
                vp= GeometryEngine.project(mV.currentViewpointCenter.center, mV.spatialReference)
            }
        }
    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // Button showing the north arrow + pressing it, returns to initial Viewpoint

    RoundButton_map{
        id: north_arrow_button
        anchors.top: parent.top
        anchors.left: parent.left
        text: "A"
        transform: Rotation { origin.x: 25; origin.y: 25; angle: 90}
    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    // Hier wird der Standort wieder deaktiviert
    RoundButton_map{
        id: gps_button
        anchors.top: north_arrow_button.bottom
        anchors.left: parent.left
        MouseArea {
            anchors.fill: location_picture
            onClicked: {
                location_b.visible=true;
                menuLoad.source ="";
                console.log("GPS button pressed");
            }
        }



        //Permission muss entzogen werden
        Image {
            id: location_picture
            source: "../images/location_off.png"
            anchors.centerIn: gps_button
            transform:
                Scale {
                origin.x: 17;
                origin.y: 25;
                xScale: 0.8;
                yScale: 0.8
            }
        }


        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        // Button to open layer selection

        RoundButton_map{
            id: layer_button
            anchors.top: gps_button.bottom
            anchors.left: parent.left
            text: "Layer"
        }


        //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        // Button to open the legend

        RoundButton_map{
            id: legend_button
            anchors.top: layer_button.bottom
            anchors.left: parent.left
            text: "Legende"
        }

    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Rectangle{
        id: location_b
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - 4
        height: 80
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 2
        color: "white"
        radius: 10

        Text {
            id: text_location
            text: "Möchten Sie ihren Standort aktivieren?"
            font.pointSize: 14
            anchors.horizontalCenter: location_b.horizontalCenter
        }

        // Button mit dem der Standort freigegeben wird
        Button_half{
            id: cancel_location
            anchors.left: location_b.left
            anchors.leftMargin: 2
            anchors.bottom: location_b.bottom
            anchors.bottomMargin: 2
            text: "No"

            MouseArea{
                anchors.fill: cancel_location
                onClicked: {
                    location_b.visible=false;
                    menuLoad.source="./menu.qml";
                    console.log("Locator permission denied");

                }
            }
        }
        // Button mit dem der Standort nicht freigegeben wird
        Button_half{
            id: accept_location
            anchors.right: location_b.right
            anchors.rightMargin: 2
            anchors.bottom: location_b.bottom
            anchors.bottomMargin: 2
            text: "Yes"

            MouseArea{
                anchors.fill: accept_location
                onClicked: {
                    location_b.visible=false;
                    menuLoad.source="./menu.qml";
                    console.log("Locator permission given");

                }
            }
        }
    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Rectangle{
        id: rect_conf
        color: "beige"
        width: parent.width-10
        height: parent.height-10
        radius: 7
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        visible: false

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
            width: parent.width/2 -7
            text: "Cancel"

            MouseArea{
                anchors.fill:parent
                onClicked: {
                    menuLoad.source="../pagesMain/menu.qml";
                    cancel_geom.visible=false;
                    accept_geom.visible=false;
                    rect_conf.visible=false;
                    start_edit_button.visible=true;

                }
            }
        }

        Button_half{
            id: accept_conf
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            width: parent.width/2 -7
            text: "Submit"
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    menuLoad.source="../pagesMain/menu.qml";
                    cancel_geom.visible=false;
                    accept_geom.visible=false;
                    rect_conf.visible=false;
                    start_edit_button.visible=true;
                    addPoint();
                }
            }
        }

    }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    function addPoint(tag, img, comment){

        var featureAttributes = {"typdamage" : "Major", "primcause" : "Earthquake"};

        // create a new feature using the mouse's map point
        var feature = featureTable.createFeatureWithAttributes(featureAttributes,vp);

        // add the new feature to the feature table
        featureTable.addFeature(feature);
        console.log(GeometryEngine.project(mV.currentViewpointCenter.center, mV.spatialReference));


    }
}






