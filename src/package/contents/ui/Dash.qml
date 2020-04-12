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
import org.kde.plasma.private.kicker 0.1 as Kicker

import "tools.js" as Tools

/**
  * Master element of the Dashboard
  */
Kicker.DashboardWindow {
    property bool isOpen: false;

    backgroundColor: Qt.rgba(0,0,0,0.5)
    onKeyEscapePressed: {
        toggle();
    }

    mainItem: Item {
        id: root
        anchors.fill: parent

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

        Item {
            anchors.fill: parent
            anchors.margins: 20

            Item {
                id: leftPane
                width: 350
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: 30
                    topMargin: 160
                }

//                Layout.fillHeight: true
//                Layout.leftMargin: 30
//                Layout.topMargin: 168

                CategoriesSidebarContainer {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: systemFavoritesContainer.top
                }

                SystemFavoritesContainer {
                    id: systemFavoritesContainer
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                }
            }

            Item {
                id: rightPane
                anchors {
                    left: leftPane.right
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                AppGridContainer {
                    anchors.fill: parent
                }
            }
        }

        Connections {
            target: SuperXDashPlugin.AppsList


            /**
            * Receive and insert applications list to model for rendering.
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

                Tools.listModelSort(appsModel, (a, b) => a.name.localeCompare(b.name));
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

            Tools.listModelSort(favoritesModel, (a, b) => a.name.localeCompare(b.name));
            SuperXDashPlugin.AppsList.appsList()
        }
    }

    function toggleDash() {
        isOpen = !isOpen;
        SuperXDashPlugin.Utils.showDesktop(isOpen);
        toggle();
    }
}
