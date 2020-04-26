import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import com.superxos.dash 1.0 as SuperXDashPlugin
import "tools.js" as Tools

Item {
    property alias favoritesGrid: favoritesGrid
    property PaginatedGrid appsGrid: null

    Menu {
        id: _favoritesCtxMenu
        property int index

        MenuItem {
            text: "Open"
            onClicked: {
                SuperXDashPlugin.AppsList.openApp(favoritesModel.get(_favoritesCtxMenu.index).url);
                toggleDash();
            }
        }
        MenuItem {
            text: "Remove from Favourites"
            onClicked: {
                var favoritesJsonArray = JSON.parse(plasmoid.configuration.favorites);

                for (var index in favoritesJsonArray) {
                    if (favoritesJsonArray[index].url === favoritesModel.get(_favoritesCtxMenu.index).url) {
                        appsModel.insert(0, {
                                                name: favoritesJsonArray[index].name,
                                                icon: favoritesJsonArray[index].icon,
                                                url: favoritesJsonArray[index].url
                                            });
                        favoritesModel.remove(_favoritesCtxMenu.index);
                        Tools.listModelSort(appsModel, (a, b) => a.name.localeCompare(b.name));
                        Tools.listModelSort(favoritesModel, (a, b) => a.name.localeCompare(b.name));
                        favoritesJsonArray.splice(index, 1);
                        break;
                    }
                }

                plasmoid.configuration.favorites = JSON.stringify(favoritesJsonArray);

                appsGrid.reset();
                favoritesGrid.reset();
            }
        }
    }

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
            model: favoritesModel
            iconModelKey: "icon"
            labelModelKey: "name"
            onOpenContextMenu: {
                _favoritesCtxMenu.index = index;
                _favoritesCtxMenu.popup();
            }
            onClicked: {
                SuperXDashPlugin.AppsList.openApp(model.url);
                toggleDash();
            }
        }
    }
}

