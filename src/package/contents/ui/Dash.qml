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
import QtGraphicalEffects 1.14

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
    property bool showFavorites: false;

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

        ListModel {
            id: categoriesModel

            ListElement {
              icon: "applications-all"
              name: "Applications"
              url: "applications:///"
            }
            ListElement {
                icon: "applications-development"
                name: "Development"
                url: "applications:///Development"
            }
            ListElement {
              icon: "applications-education"
              name: "Education"
              url: "applications:///Education"
            }
            ListElement {
              icon: "applications-games"
              name: "Games"
              url: "applications:///Games"
            }
            ListElement {
              icon: "applications-graphics"
              name: "Graphics"
              url: "applications:///Graphics"
            }
            ListElement {
              icon: "applications-internet"
              name: "Internet"
              url: "applications:///Internet"
            }
            ListElement {
              icon: "applications-multimedia"
              name: "Multimedia"
              url: "applications:///Multimedia"
            }
            ListElement {
              icon: "applications-office"
              name: "Office"
              url: "applications:///Office"
            }
            ListElement {
              icon: "applications-system"
              name: "System"
              url: "applications:///System"
            }
            ListElement {
              icon: "applications-utilities"
              name: "Utilities"
              url: "applications:///Utilities"
            }
            ListElement {
              icon: "applications-other"
              name: "Others"
              url: "applications:///Applications"
            }
        }

        SystemFavoritesContainer {
            height: 40
            anchors {
                top: parent.top
                left: parent.left
                margins: 10
            }
        }

        Kirigami.Icon {
            width: 40
            height: 40
            source: "window-close"
            anchors {
                top: parent.top
                right: parent.right
                margins: 10
            }

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#ffeeeeee"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    toggleDash();
                }
            }
        }

        Item {
            property int spacing: 100
            property int topPaneMargin: 70

            id: container
            anchors.fill: parent

            Item {
                id: topPane
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: container.topPaneMargin
                }
                height: 100

                TopContainer {
                    id: topContainer
                    anchors.fill: parent
                }
            }

            Item {
                id: leftPane
                width: 400
                anchors {
                    top: topPane.bottom
                    bottom: bottomPane.top
                    left: parent.left
                    leftMargin: container.spacing
                    rightMargin: container.spacing
                    bottomMargin: container.spacing
                    topMargin: container.topPaneMargin
                }

                FavoritesContainer {
                    id: favoritesGridContainer
                    anchors.fill: parent
                    appsGrid: appsGridContainer.appsGrid
                }
            }

            Item {
                id: rightPane
                anchors {
                    left: leftPane.right
                    top: topPane.bottom
                    bottom: bottomPane.top
                    right: parent.right
                    leftMargin: container.spacing
                    rightMargin: container.spacing
                    bottomMargin: container.spacing
                    topMargin: container.topPaneMargin
                }

                AppGridContainer {
                    id: appsGridContainer
                    anchors.fill: parent
                    queryField: topContainer.queryField
                    favoritesGrid: favoritesGridContainer.favoritesGrid
                }
            }

            Item {
                id: bottomPane
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: 120

                RowLayout {
                    height: parent.height
                    anchors.centerIn: parent

                    Repeater {
                        model: categoriesModel

                        Kirigami.Icon {
                            width: 80
                            height: 40
                            source: model.icon
                            anchors.margins: 20

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    appsModel.clear();

                                    if (model.url === "applications:///") {
                                        showFavorites = false;
                                    } else {
                                        showFavorites = true;
                                    }

                                    appsGridContainer.headingText = model.name
                                    SuperXDashPlugin.AppsList.appsList(model.url);
                                }
                            }
                        }
                    }

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

                    if (!showFavorites) {
                        var favoritesJsonArray = plasmoid.configuration.favorites && JSON.parse(plasmoid.configuration.favorites) || [];

                        for (var index in favoritesJsonArray) {
                            if (favoritesJsonArray[index].url === e.url) {
                                return;
                            }
                        }
                    }

                    console.log(">>>", e.name.split("/").pop())

                    appsModel.append({
                                        "name": e.name.split("/").pop(),
                                        "icon": e.icon,
                                        "url": e.url
                                    })
                })

                if (appsGridContainer && appsGridContainer.appsGrid) {
                    appsGridContainer.appsGrid.reset();
                }
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
            SuperXDashPlugin.AppsList.appsList("applications:///")
        }
    }

    function toggleDash() {
        isOpen = !isOpen;
//        SuperXDashPlugin.Utils.showDesktop(isOpen);
        toggle();
    }
}
