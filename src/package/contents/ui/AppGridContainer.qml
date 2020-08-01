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
    property TextArea queryField: null
    property alias appsGrid: appsGrid
    property alias krunnerResultsGrid: krunnerResultsGrid
    property string headingText: "Applications"
    property var searchedItems: []

//    Milou.ResultsModel {
//        id: krunnerResultsModel
//        queryString: queryField.text
//        limit: 15
//        onRowsInserted: {
//            krunnerResultsGrid.totalCount = krunnerResultsModel.rowCount();
//            krunnerResultsGrid.reset();

//            appsGrid.hoverEnabled = false;
//            appsGrid.highlightIndex = 0;

//            krunnerResultsGrid.hoverEnabled = false;
//            krunnerResultsGrid.highlightIndex = 0;
//        }
//    }

    Connections {
        target: queryField

        function onTextChanged() {
            SuperXDashPlugin.AppsList.search(queryField.text);
        }
    }

    Connections {
        target: SuperXDashPlugin.AppsList

        function onSearchResult(searchResultList) {
            searchedItems = searchResultList;
            krunnerResultsGrid.totalCount = searchedItems.length;
            krunnerResultsGrid.reset();
        }
    }

    Menu {
        id: _appsCtxMenu
        property int index

        MenuItem {
            text: "Pin to top"
            onClicked: {
                var pinnedJsonObj = JSON.parse(settings.pinned);
                var model = apps[_appsCtxMenu.index];
                var desktopFile = model.url.split("/").pop();
                var modelJson = {
                    name: model.name,
                    icon: model.icon,
                    url: model.url
                };

                pinnedJsonObj[desktopFile] = modelJson;
                settings.pinned = JSON.stringify(pinnedJsonObj);
                populateAppsModel("/");

                appsGridContainer.appsGrid.totalCount = apps.length;
                appsGridContainer.appsGrid.reset();
            }
        }
    }

    Menu {
        id: _searchCtxMenu
        property int index

        MenuItem {
            text: "Pin to top"
            visible: searchedItems[_searchCtxMenu.index] ? searchedItems[_searchCtxMenu.index].isApplication : false
            onClicked: {
                var pinnedJsonObj = JSON.parse(settings.pinned);
                var model = searchedItems[_searchCtxMenu.index];
                var modelJson;

                if (model.url.toString().startsWith("applications:")) {
                    model.url = model.url.toString().replace("applications:", "");
                }

                for (var i in apps) {
                    if (apps[i].url.split("/").pop() === model.url) {
                        modelJson = apps[i];
                        break;
                    }
                }

                pinnedJsonObj[model.url] = modelJson;
                settings.pinned = JSON.stringify(pinnedJsonObj);
                populateAppsModel("/");

                appsGridContainer.appsGrid.totalCount = apps.length;
                appsGridContainer.appsGrid.reset();
            }
        }

        MenuItem {
            text: "Open"
            onClicked: {
                SuperXDashPlugin.AppsList.runSearchedItem(searchedItems[_searchCtxMenu.index].index);
                toggleDash();
                queryField.text = "";
            }
        }
    }

    Menu {
        id: _pinnedCtxMenu
        property int index

        MenuItem {
            text: "Unpin"
            onClicked: {
                var pinnedJsonObj = JSON.parse(settings.pinned);
                var url = apps[_pinnedCtxMenu.index].url.split("/").pop();

                if (pinnedJsonObj[url]) {
                    delete pinnedJsonObj[url];
                }

                settings.pinned = JSON.stringify(pinnedJsonObj);
                populateAppsModel("/");

                appsGridContainer.appsGrid.totalCount = apps.length;
                appsGridContainer.appsGrid.reset();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 50

        Heading {
            id: heading
            Layout.fillWidth: true
            text: queryField.text.length > 0 ? "Results" : headingText
        }

        /**
          * Gridview for listing installed applications
          */
        PaginatedGrid {
            id: appsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !krunnerResultsGrid.visible

            cellWidth: settings.gridItemSize
            cellHeight: settings.gridItemSize
            totalCount: apps.length

            delegate: IconItem {
                anchors.fill: parent
                icon: apps[itemIndex] ? apps[itemIndex].icon : ""
                label: apps[itemIndex] ? apps[itemIndex].name : ""
                isPinned: apps[itemIndex] ? (apps[itemIndex].isPinned ? true : false) : false

                onOpenContextMenu: {
                    if (apps[itemIndex].isPinned) {
                        _pinnedCtxMenu.index = itemIndex;
                        _pinnedCtxMenu.popup();
                    } else {
                        _appsCtxMenu.index = itemIndex;
                        _appsCtxMenu.popup();
                    }
                }
                onClicked: {
                    SuperXDashPlugin.AppsList.openApp(apps[itemIndex].url);
                    toggleDash();
                }
            }
            onHighlightClicked: {
                SuperXDashPlugin.AppsList.openApp(apps[index].url);
                toggleDash();
            }
            onScrollingInitiated: {
                _pinnedCtxMenu.close();
                _appsCtxMenu.close();
                _searchCtxMenu.close();
            }
        }

        PaginatedGrid {
            id: krunnerResultsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: queryField.text.length > 0

            cellWidth: settings.gridItemSize
            cellHeight: settings.gridItemSize
            totalCount: 0

            delegate: IconItem {
                anchors.fill: parent
                icon: searchedItems[itemIndex] ? searchedItems[itemIndex].icon : ""
                label: searchedItems[itemIndex] ? searchedItems[itemIndex].name : ""

                onOpenContextMenu: {
                    _searchCtxMenu.index = itemIndex;
                    _searchCtxMenu.popup();
                }
                onClicked: {
                    SuperXDashPlugin.AppsList.runSearchedItem(searchedItems[itemIndex].index);
                    toggleDash();
                    queryField.text = "";
                }
            }
            onHighlightClicked: {
                SuperXDashPlugin.AppsList.runSearchedItem(searchedItems[index].index);
                toggleDash();
                queryField.text = "";
            }
        }
    }
}
