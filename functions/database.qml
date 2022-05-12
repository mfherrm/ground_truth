import QtQuick 2.9
import QtQuick.Controls 2.3
import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Sql 1.0

Item {
    FileFolder {
      id: sqlFolder
      path: "~/ArcGIS/AppStudio\Apps\e851a47a6d8d4ad281a2435f63bbe1b3\data"
    }

    SqlDatabase {
        id: db
        databaseName: sqlFolder.filePath("db_gt.sqlite")
    }

    Component.onCompleted: {
        sqlFolder.makeFolder();
        db.open();
    }
}
