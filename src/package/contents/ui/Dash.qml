

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
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.7 as Kirigami
import com.superxos.dash 1.0 as SuperXDashPlugin
import org.kde.plasma.plasmoid 2.0
import org.kde.milou 0.3 as Milou


/**
  * Master element of the Dashboard
  */
Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0,0,0,0.7)

    RowLayout {
        z: 1000
        visible: false

        IconItem {
            width: 100
            height: 100
            icon: "system-shutdown"
            label: "Shutdown"
            onClicked: SuperXDashPlugin.SystemFavourites.onShutdownClicked()
        }

        IconItem {
            width: 100
            height: 100
            icon: "system-log-out"
            label: "Logout"
            onClicked: SuperXDashPlugin.SystemFavourites.onLogoutClicked()
        }

        IconItem {
            width: 100
            height: 100
            icon: "system-reboot"
            label: "Reboot"
            onClicked: SuperXDashPlugin.SystemFavourites.onRebootClicked()
        }
    }

    Milou.ResultsModel {
        id: krunnerResultsModel
        queryString: queryField.text
        limit: 10
    }

    TextInput {
        id: queryField
        visible: false
        x: 250
        z: 1000
        width: 200
        height: 50
        text: "firefox"
    }

    ColumnLayout {
        visible: queryField.visible
        Repeater {
            model: krunnerResultsModel

            RowLayout {
                Kirigami.Icon {
                    id: typePixmap
                    width: 50
                    height: 50

                    source: model.decoration
                }

                Label {
                    text: model.display
                    color: "#000000"
                }
            }
        }
    }


    /**
      * Model for storing list of installed applications.
      * This is used by the Gridview to render the components.
      */
    ListModel {
        id: appsModel

        // { name, icon, url }
    }

    /**
      * Model for storing favorite applications.
      */
    ListModel {
        id: favoritesModel

        // { name, icon, url }
    }

//    MouseArea {
//        id: scrollArea
//        anchors.fill: parent
//
//
//        /**
//          * Handle Scroll event for pagination logic
//          */
//        onWheel: {
//            // TODO : Implement pagination functionality
//            console.log(wheel.angleDelta)
//        }
//    }

    Menu {
        id: _favoritesCtxMenu
        property int index

        MenuItem {
            text: "Open"
            onClicked: openApp(favoritesModel.get(_favoritesCtxMenu.index).url)
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
                        listModelSort(appsModel, (a, b) => a.name.localeCompare(b.name));
                        listModelSort(favoritesModel, (a, b) => a.name.localeCompare(b.name));
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
            onClicked: openApp(appsModel.get(_appsCtxMenu.index).url)
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
                listModelSort(appsModel, (a, b) => a.name.localeCompare(b.name));
                listModelSort(favoritesModel, (a, b) => a.name.localeCompare(b.name));
                appsModel.remove(_appsCtxMenu.index)
                plasmoid.configuration.favorites = JSON.stringify(favoritesJsonArray);

                appsGrid.reset();
                favoritesGrid.reset();
            }
        }
    }


    /**
      * Gridview for listing favourite applications
      */
    PaginatedGrid {
        id: favoritesGrid
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 200
        visible: true

        cellWidth: 140
        cellHeight: 140
        model: favoritesModel
        iconModelKey: "icon"
        labelModelKey: "name"
        onOpenContextMenu: {
            _favoritesCtxMenu.index = index;
            _favoritesCtxMenu.popup();
        }
        onClicked: openApp(model.url)
    }

    PaginatedGrid {
        id: appsGrid
        anchors {
            top: favoritesGrid.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        visible: favoritesGrid.visible

        cellWidth: 140
        cellHeight: 140
        model: appsModel
        iconModelKey: "icon"
        labelModelKey: "name"
        onOpenContextMenu: {
            _appsCtxMenu.index = index;
            _appsCtxMenu.popup();
        }

        onClicked: openApp(model.url)
    }

    Connections {
        target: SuperXDashPlugin.AppsList


        /**
          * Receive and inset applications list to model for rendering.
          */
        onAppsListResult: {
            apps.forEach(function (e) {
                if (e.mimeType === "inode/directory") {
                    return
                } else if (e.name === ".") {
                    return
                }

                var favoritesJsonArray = plasmoid.configuration.favorites && JSON.parse(plasmoid.configuration.favorites) || [];

                for (var index in favoritesJsonArray) {
                    if (favoritesJsonArray[index].url === e.url) {
                        return;
                    }
                }

                appsModel.append({
                                     "name": e.name.split("/").pop(),
                                     "icon": e.icon,
                                     "url": e.url
                                 })
            })

            listModelSort(appsModel, (a, b) => a.name.localeCompare(b.name));
        }
    }


    /**
      * Fetch the applications list when QML gets loaded
      */
    Component.onCompleted: {
        var favoritesJsonArray = plasmoid.configuration.favorites && JSON.parse(plasmoid.configuration.favorites) || [];

        for (var index in favoritesJsonArray) {
            favoritesModel.append({
                                      name: favoritesJsonArray[index].name,
                                      icon: favoritesJsonArray[index].icon,
                                      url: favoritesJsonArray[index].url
                                  });
        }

        listModelSort(favoritesModel, (a, b) => a.name.localeCompare(b.name));
        SuperXDashPlugin.AppsList.appsList()
    }    

    function openApp(url) {
        SuperXDashPlugin.AppsList.openApp(url);
    }

    function listModelSort(listModel, compareFunction) {
        let indexes = [ ...Array(listModel.count).keys() ]
        indexes.sort( (a, b) => compareFunction( listModel.get(a), listModel.get(b) ) )
        let sorted = 0
        while ( sorted < indexes.length && sorted === indexes[sorted] ) sorted++
        if ( sorted === indexes.length ) return
        for ( let i = sorted; i < indexes.length; i++ ) {
            listModel.move( indexes[i], listModel.count - 1, 1 )
            listModel.insert( indexes[i], { } )
        }
        listModel.remove( sorted, indexes.length - sorted )
    }
}
