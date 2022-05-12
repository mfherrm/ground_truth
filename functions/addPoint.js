function addPoint(tag, img, comment){
        var featureAttributes = {"ID_TAG" : tag, "ID_IMG_01": img, "COMMENT": comment };

        var point = ArcGISRuntimeEnvironment.createObject("Point", {x: initialViewpoint.center.x, y: initialViewpoint.center.y});
        // create a new feature using the mouse's map point
        var feature = gdb.geodatabaseFeatureTablesByTableName["fact_point"].createFeatureWithAttributes(featureAttributes, point);

        // add the new feature to the feature table
        gdb.geodatabaseFeatureTablesByTableName["fact_point"].addFeature(feature);
    }
