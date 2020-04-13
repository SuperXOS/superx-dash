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
    property PaginatedGrid favoritesGrid: null
    property alias headingText: heading.text

    Milou.ResultsModel {
        id: krunnerResultsModel
        queryString: queryField.text
        limit: 20
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

        Heading {
            id: heading
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

            cellWidth: 180
            cellHeight: 180
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
            cellWidth: 180
            cellHeight: 180

            model: krunnerResultsModel
            delegate: IconItem {
                id: gridItem
                width: 120
                height: 120
                icon: model.decoration
                label: model.display
            }
        }

    }
}
