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

    Milou.ResultsModel {
        id: krunnerResultsModel
        queryString: queryField.text
        limit: 15
        onRowsInserted: {
            krunnerResultsGrid.totalCount = krunnerResultsModel.rowCount()
            krunnerResultsGrid.reset()
        }
    }

    Menu {
        id: _appsCtxMenu
        property int index

        MenuItem {
            text: "Pin to top"
            onClicked: {
                var pinnedJsonArray = plasmoid.configuration.pinned && JSON.parse(plasmoid.configuration.pinned) || [];
                var model = apps[_appsCtxMenu.index];
                var modelJson = {
                    name: model.name,
                    icon: model.icon,
                    url: model.url
                };

                pinnedJsonArray.push(modelJson);
                plasmoid.configuration.pinned = JSON.stringify(pinnedJsonArray);
                populateAppsModel("/");
            }
        }
    }

    Menu {
        id: _pinnedCtxMenu
        property int index

        MenuItem {
            text: "Unpin"
            onClicked: {
                var pinnedJsonArray = JSON.parse(plasmoid.configuration.pinned);

                for (var index in pinnedJsonArray) {
                    if (pinnedJsonArray[index].url === apps[_pinnedCtxMenu.index].url) {
                        pinnedJsonArray.splice(index, 1);
                        break;
                    }
                }

                plasmoid.configuration.pinned = JSON.stringify(pinnedJsonArray);
                populateAppsModel("/");
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

            cellWidth: 180
            cellHeight: 180
            totalCount: apps.length

            delegate: IconItem {
                anchors.fill: parent
                icon: apps[itemIndex].icon
                label: apps[itemIndex].name
                isPinned: apps[itemIndex].isPinned ? true : false

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
        }

        PaginatedGrid {
            id: krunnerResultsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: queryField.text.length > 0

            cellWidth: 180
            cellHeight: 180
            totalCount: krunnerResultsModel.rowCount()

            delegate: IconItem {
                anchors.fill: parent
                icon: krunnerResultsModel.data(krunnerResultsModel.index(itemIndex, 0), 1)
                label: krunnerResultsModel.data(krunnerResultsModel.index(itemIndex, 0), 0)

                onClicked: {
                    krunnerResultsModel.run(krunnerResultsModel.index(itemIndex, 0));
                    toggleDash();
                    queryField.text = "";
                }
            }
            onHighlightClicked: {
                krunnerResultsModel.run(krunnerResultsModel.index(index, 0));
                toggleDash();
                queryField.text = "";
            }
        }
    }
}
