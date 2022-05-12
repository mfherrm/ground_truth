function getPoint(mV)
{
        if(mV.currentViewpointCenter.center) {
            app.theNewPoint = mapView.currentViewpointCenter.center;
        } else {
            app.theNewPoint = ArcGISRuntimeEnvironment.createObject("Point", {x: positionSource.position.coordinate.longitude, y: positionSource.position.coordinate.latitude, spatialReference: Factory.SpatialReference.createWgs84()});
        }
}
