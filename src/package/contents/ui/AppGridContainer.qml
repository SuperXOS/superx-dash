/********************************************************************************
 *    superx-dash is a part of SuperX Open Source Project                       *
 *                                                                              *
 *    Copyright (C) 2020 Libresoft Technology Pvt. Ltd.                         *
 *    Author: Anupam Basak <anupam.basak27@gmail.com>                           *
 *                                                                              *
 *    This program is free software: you can redistribute it and/or modify      *
 *    it under the terms of the GNU General Public License as published by      *
 *    the Free Software Foundation, either version 3 of the License, or         *
 *    (at your option) any later version.                                       *
 *                                                                              *
 *    This program is distributed in the hope that it will be useful,           *
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 *    GNU General Public License for more details.                              *
 *                                                                              *
 *    You should have received a copy of the GNU General Public License         *
 *    along with this program.  If not, see <https://www.gnu.org/licenses/>.    *
 *                                                                              *
 ********************************************************************************/

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import org.kde.milou 0.3 as Milou
import com.superxos.dash 1.0 as SuperXDashPlugin
import "tools.js" as Tools

Item {
    Milou.ResultsModel {
        id: krunnerResultsModel
        queryString: queryField.text
        limit: 20
    }

//    ColumnLayout {
//        visible: queryField.visible
//        Repeater {
//            model: krunnerResultsModel

//            RowLayout {
//                Kirigami.Icon {
//                    id: typePixmap
//                    width: 50
//                    height: 50

//                    source: model.decoration
//                }

//                Label {
//                    text: model.display
//                    color: "#000000"
//                }
//            }
//        }
//    }
    Menu {
        id: _favoritesCtxMenu
        property int index

        MenuItem {
            text: "Open"
            onClicked: {
                SuperXDashPlugin.AppsList.openApp(favoritesModel.get(_favoritesCtxMenu.index).url);
                toggle();
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

    Menu {
        id: _appsCtxMenu
        property int index

        MenuItem {
            text: "Open"
            onClicked: {
                SuperXDashPlugin.AppsList.openApp(appsModel.get(_appsCtxMenu.index).url);
                toggle();
            }
        }
        MenuItem {
            text: "Add to Favourites"
            onClicked: {
                var favoritesJsonArray = plasmoid.configuration.favorites && JSON.parse(plasmoid.configuration.favorites) || [];
                var model = appsModel.get(_appsCtxMenu.index);
                var modelJson = {
                    name: model.name,
                    icon: model.icon,
                    url: model.url
                };

                favoritesJsonArray.push(modelJson);
                favoritesModel.append(modelJson);
                Tools.listModelSort(appsModel, (a, b) => a.name.localeCompare(b.name));
                Tools.listModelSort(favoritesModel, (a, b) => a.name.localeCompare(b.name));
                appsModel.remove(_appsCtxMenu.index)
                plasmoid.configuration.favorites = JSON.stringify(favoritesJsonArray);

                appsGrid.reset();
                favoritesGrid.reset();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 50

        Item {
            height: 70
            Layout.fillWidth: true
            Layout.topMargin: 50

            TextArea {
                id: queryField
                width: 200
                anchors.centerIn: parent
            }
        }

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
            height: 140

            cellWidth: 140
            cellHeight: 140
            model: favoritesModel
            iconModelKey: "icon"
            labelModelKey: "name"
            onOpenContextMenu: {
                _favoritesCtxMenu.index = index;
                _favoritesCtxMenu.popup();
            }
            onClicked: {
                SuperXDashPlugin.AppsList.openApp(model.url);
                toggle();
            }
        }

        Heading {
            Layout.fillWidth: true
            text: "Applications"
        }

        /**
          * Gridview for listing installed applications
          */
        PaginatedGrid {
            id: appsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !krunnerResultsGrid.visible

            cellWidth: 140
            cellHeight: 140
            model: appsModel
            iconModelKey: "icon"
            labelModelKey: "name"

            onOpenContextMenu: {
                _appsCtxMenu.index = index;
                _appsCtxMenu.popup();
            }
            onClicked: {
                SuperXDashPlugin.AppsList.openApp(model);
                toggle();
            }
        }

        /**
          * Gridview for listing krunner results
          */
        GridView {
            id: krunnerResultsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: queryField.text.length > 0
            cellWidth: 140
            cellHeight: 140

            model: krunnerResultsModel
            delegate: IconItem {
                id: gridItem
                width: 100
                height: 100
                icon: model.decoration
                label: model.display
            }
        }

    }
}
