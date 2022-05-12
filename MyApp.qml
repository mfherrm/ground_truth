/* Copyright 2020 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


// You can run your app in Qt Creator by pressing Alt+Shift+R.
// Alternatively, you can run apps through UI using Tools > External > AppStudio > Run.
// AppStudio users frequently use the Ctrl+A and Ctrl+I commands to
// automatically indent the entirety of the .qml file.


import QtQuick 2.13
import QtQuick.Controls 2.13
import Esri.ArcGISRuntime 100.13
import ArcGIS.AppFramework 1.0
//import Esri.ArcGISRuntime 100.6

App {
    id: app
    width: 400
    height: 640

    StackView{
        id: mainStack
        anchors.fill: parent
        initialItem:  "./pagesLoader/start.qml"
    }



    StackView{
        id: uiStack
        anchors.fill: parent
        initialItem: "./pagesStackView/startButtons.qml"
    }

    Loader{
        id: menuLoad
        anchors.fill: parent
        source: ""
    }

    Geodatabase {
        id: gdb
        path: "../data/db_gt.geodatabase"

    }

    MapView{
        id: mV
    }
    property real scaleFactor: AppFramework.displayScaleFactor

}

