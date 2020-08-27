import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import com.superxos.dash 1.0 as SuperXDashPlugin
import "tools.js" as Tools

Item {
    property alias favoritesGrid: favoritesGrid
    property PaginatedGrid appsGrid: null



    ColumnLayout {
        anchors.fill: parent
        spacing: 50

        Heading {
            Layout.fillWidth: true
            text: "Favorites"
        }

        /**
          * Gridview for listing favourite applications
          */
        PaginatedGrid {
            id: favoritesGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 160
            cellHeight: 160
//            model: favoritesModel
//            iconModelKey: "icon"
//            labelModelKey: "name"
//            onOpenContextMenu: {
//                _favoritesCtxMenu.index = index;
//                _favoritesCtxMenu.popup();
//            }
//            onClicked: {
//                SuperXDashPlugin.AppsList.openApp(model.url);
//                toggleDash();
//            }
        }
    }
}

