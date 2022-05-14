import QtQuick 2.13
import QtQuick.Controls 2.13
import Esri.ArcGISRuntime 100.13
import ArcGIS.AppFramework 1.0

App {
    property real scaleFactor: AppFramework.displayScaleFactor
    id: gt
    width: 400
    height: 640

    StackView{
        id: mainStack
        anchors.fill: gt
        initialItem:  "./pagesMain/start.qml"
    }

    Loader{
        id: menuLoad
        anchors.fill: parent
        source: ""
    }

}

