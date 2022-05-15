import QtQuick 2.15
import QtQuick.Controls 2.13
import QtLocation 5.11
import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.13
import QtQuick.Dialogs 1.3
import "../components"
import "../functions"

Page{
    property double mousePointX
    property double mousePointY
    property string damageType
    property QtObject vp
    property string labclass
    property string comment

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
                console.log("Started editing");
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
                cancel_geom.visible=false;
                accept_geom.visible=false;
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
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        if (rect_legend.visible == false) {
                            rect_legend.visible = true;
                            console.log(rect_legend.visible)
                        } else {
                            rect_legend.visible = false;
                            console.log(rect_legend.visible)
                        }
                    }
                }
            }

        // Legend
            property bool expanded: true
            Rectangle{
                id: rect_legend
                anchors.top: legend_button.top
                anchors.left: legend_button.right
                visible: false
                width: 300
                height: 250
                color: "lightgrey"
                opacity: 0.95
                radius: 10
                clip: true
                border {
                    color: "darkgrey"
                    width: 1
                }
                Text {
                    id: legText
                    text: "Legend"
                    color: "black"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                // Catch mouse signals so they don't propagate to the map
                MouseArea {
                    anchors.fill: rect_legend
                    onClicked: mouse.accepted = true
                    onWheel: wheel.accepted = true
                }
                // Animate the expand and collapse of the legend
                Behavior on visible {
                    SpringAnimation {
                        spring: 3
                        damping: .8
                    }
                }
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
        width: parent.width-30
        height: parent.height-30
        radius: 7
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 15
        visible: false

        Text {
            id: infoText
            text: "Confirm Geometry"
            color: "black"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 24

        }


        //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        Rectangle{
            id: labelRect
            anchors.bottom: treeRect.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width-20
            height: imgTxt.height

            color: "black"
            opacity: 0.2
            Text{
                id:labTxt
                text: "Selected class label:"
                font.pointSize: 12
            }
        }

        Rectangle{
            id: treeRect
            anchors.bottom: shaderTxt.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width-20
            height: parent.height-440
            color: "transparent"

            Labels {
                id: tree
                anchors.fill: treeRect
                anchors.margins: 10
                clip: true
                z: 3
            }
            Rectangle{
                anchors.fill: treeRect
                color: "black"
                opacity: 0.1
            }
        }


        //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        Rectangle{
            id: shaderTxt
            anchors.bottom: imgTxtRect.top
            anchors.bottomMargin: 3
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width-20
            height: parent.height-450
            color: "light grey"
            opacity: 0.2
            radius: 3
        }
        TextArea{
            id: txtComm
            placeholderText: "Comment:"
            placeholderTextColor: "grey"
            anchors.fill: shaderTxt


        }


        //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        Rectangle{
            id: imgTxtRect
            anchors.bottom: imgPrev.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width-20
            height: imgTxt.height
            color: "black"
            opacity: 0.2
            Text{
                id:imgTxt
                text: "Added images"
                font.pointSize: 12
            }
        }

        Rectangle{
            id: imgPrev
            anchors.bottom: cameraBttn.top
            anchors.bottomMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width-20
            height: parent.height-525
            radius: 3
            color: "black"
            opacity: 0.1

            Row{
                anchors.left: parent.left
                anchors.leftMargin: 4
                spacing: 4

                Rectangle{
                    id: img01
                    width: (imgPrev.width/3)-5
                    height: imgPrev.height-8
                    color: "black"
                    anchors.top: parent.top
                    anchors.topMargin: 4
                }

                Rectangle{
                    id: img02
                    width: (imgPrev.width/3)-6
                    height: imgPrev.height-8
                    color: "black"
                    anchors.top: parent.top
                    anchors.topMargin: 4
                }

                Rectangle{
                    id: img03
                    width: (imgPrev.width/3)-5
                    height: imgPrev.height-8
                    color: "black"
                    anchors.top: parent.top
                    anchors.topMargin: 4
                }
            }
        }

        Button_wide{
            id: cameraBttn
            width: parent.width-10
            anchors.left:parent.left
            anchors.bottom: cancel_conf.top
            anchors.leftMargin: 5
            text: "Camera"

        }


    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        Button_half{
            id: cancel_conf
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
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
                    txtComm.text="";

                }
            }
        }

        Button_half{
            id: accept_conf
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
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
                    comment= txtComm.text;
                    console.log(comment);
                    txtComm.text="";
                    addPoint();
                }
            }
        }


        //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        function update() {
            var data = [
                        {"childrent":[

                                {"childrent":[
                                        {"childrent":[],"label":"Metal roof","type":""},
                                        {"childrent":[],"label":"Concrete roof","type":""},
                                        {"childrent":[],"label":"Sheet roof","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"Ia - Homestead","type":"4 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Occupied dwelling","type":""},
                                        {"childrent":[],"label":"Vacant dwelling","type":""},
                                        {"childrent":[],"label":"Cattle shed","type":""},
                                        {"childrent":[],"label":"Garage shed","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"Ib - Homestead","type":"5 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Fence","type":""},
                                        {"childrent":[],"label":"Wall","type":""},
                                        {"childrent":[],"label":"Hedge","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"II - Plot boundaries","type":"4 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Pavement","type":""},
                                        {"childrent":[],"label":"Grass meadow","type":""},
                                        {"childrent":[],"label":"Unused land","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"III - Miscellaneous land cover in settlement","type":"4 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Maize","type":""},
                                        {"childrent":[],"label":"Sorghum","type":""},
                                        {"childrent":[],"label":"Wheat","type":""},
                                        {"childrent":[],"label":"Beans","type":""},
                                        {"childrent":[],"label":"Beetroots","type":""},
                                        {"childrent":[],"label":"Cabbage","type":""},
                                        {"childrent":[],"label":"Carrots","type":""},
                                        {"childrent":[],"label":"Cowpeas","type":""},
                                        {"childrent":[],"label":"Fruit tree(s)","type":""},
                                        {"childrent":[],"label":"Groundnuts","type":""},
                                        {"childrent":[],"label":"Lettuce","type":""},
                                        {"childrent":[],"label":"Onions","type":""},
                                        {"childrent":[],"label":"Spinach","type":""},
                                        {"childrent":[],"label":"Tomatoes","type":""},
                                        {"childrent":[],"label":"Fallow land","type":""},
                                        {"childrent":[],"label":"Burnt area","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"IV - Agriculture","type":"17 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Tarmac road","type":""},
                                        {"childrent":[],"label":"Paved road","type":""},
                                        {"childrent":[],"label":"Dirt road","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"V - Roads","type":"4 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Industry","type":""},
                                        {"childrent":[],"label":"Car park","type":""},
                                        {"childrent":[],"label":"Open ground","type":""},
                                        {"childrent":[],"label":"Outcrop","type":""},
                                        {"childrent":[],"label":"Dumpsite","type":""},
                                        {"childrent":[],"label":"Cemetery","type":""},
                                        {"childrent":[],"label":"Golf club","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"VI - Other urban land use","type":"8 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Forest","type":""},
                                        {"childrent":[],"label":"Bushland","type":""},
                                        {"childrent":[],"label":"Shrubland","type":""},
                                        {"childrent":[],"label":"Grassland","type":""},
                                        {"childrent":[],"label":"Rangeland","type":""},
                                        {"childrent":[],"label":"Single tree(s)","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"VII - Natural Vegetation","type":"7 items"},

                                {"childrent":[
                                        {"childrent":[],"label":"Stream","type":""},
                                        {"childrent":[],"label":"Dried river bank","type":""},
                                        {"childrent":[],"label":"Natural Pond","type":""},
                                        {"childrent":[],"label":"Water dam","type":""},
                                        {"childrent":[],"label":"Water tank (closed)","type":""},
                                        {"childrent":[],"label":"Other","type":""}
                                    ],"label":"VIII - Water bodies","type":"6 items"}],
                            "label":"LUC","type":""},

                        {"childrent":[
                                {"childrent":[{"childrent":[],"label":"Other","type":""}],"label":"I - Places","type":"Comment"},
                                {"childrent":[{"childrent":[],"label":"Other","type":""}],"label":"II - Purpose","type":"Comment"}]
                            ,"label":"Other","type":""}];

            tree.model.clear();
            data.forEach(function(row) {
                tree.model.append(row);
            });
        }

        Component.onCompleted: {
            update();
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






