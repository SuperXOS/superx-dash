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
    property alias focusScope: keyboardNavFocusScope
    property alias appsGrid: appsGrid
    property alias krunnerResultsGrid: krunnerResultsGrid
    property alias krunnerResultsModel: krunnerResultsModel
    property PaginatedGrid favoritesGrid: null
    property string headingText: "Applications"

    FocusScope {
        id: keyboardNavFocusScope
        focus: true
        onActiveFocusChanged: {
            keyboardNavFocusScope.forceActiveFocus()
        }

        Keys.forwardTo: queryField
        Keys.onPressed: {
            console.log(event.key)
            switch(event.key) {
                case Qt.Key_Up:
                    appsGrid.moveHighlightUp();
                    krunnerResultsGrid.moveHighlightUp();
                    break;
                case Qt.Key_Down:
                    appsGrid.moveHighlightDown();
                    krunnerResultsGrid.moveHighlightDown();
                    break;
                case Qt.Key_Left:
                    console.log("left")
                    appsGrid.moveHighlightLeft();
                    krunnerResultsGrid.moveHighlightLeft();
                    break;
                case Qt.Key_Right:
                    console.log("right")
                    appsGrid.moveHighlightRight();
                    krunnerResultsGrid.moveHighlightRight();
                    break;

                case Qt.Key_Enter:
                case Qt.Key_Return:
                    if (appsGrid.visible) {
                        appsGrid.clickHighlightedItem();
                    } else if (krunnerResultsGrid.visible) {
                        krunnerResultsGrid.clickHighlightedItem();
                    }

                    break;
            }
        }
    }

    Milou.ResultsModel {
        id: krunnerResultsModel
        queryString: queryField.text
        limit: 15
//        onDataChanged: {
//        }
        onRowsInserted: {
            krunnerResultsGrid.totalCount = krunnerResultsModel.rowCount()
            krunnerResultsGrid.reset()
        }
    }

    Menu {
        id: _appsCtxMenu
        property int index

        MenuItem {
            text: "Open"
            onClicked: {
                SuperXDashPlugin.AppsList.openApp(appsModel.get(_appsCtxMenu.index).url);
                toggleDash();
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

//                appsGrid.reset();
//                favoritesGrid.reset();
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
            totalCount: appsModel.count

            delegate: IconItem {
                anchors.fill: parent
                icon: appsModel.get(itemIndex).icon
                label: appsModel.get(itemIndex).name
//                onOpenContextMenu: console.log("ctx menu", itemIndex) //root.openContextMenu(startIndex+index)
//                onClicked: console.log("click", itemIndex) //root.clicked(root.model.get(startIndex+index))
            }

//            onOpenContextMenu: {
//                _appsCtxMenu.index = index;
//                _appsCtxMenu.popup();
//            }
//            onClicked: {
//                SuperXDashPlugin.AppsList.openApp(model.url);
//                toggleDash();
//            }
        }

        /**
          * Gridview for listing krunner results
          */
//        GridView {
//            id: krunnerResultsGrid
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            visible: queryField.text.length > 0
//            cellWidth: 180
//            cellHeight: 180
//            interactive: false

//            model: krunnerResultsModel
//            delegate: Item {
//                id: gridItem
//                width: 180
//                height: 180

//                IconItem {
//                    width: parent.width - 35
//                    height: parent.height - 35
//                    anchors.centerIn: parent
//                    icon: model.decoration
//                    label: model.display
//                    onClicked: {
//                        krunnerResultsModel.run(krunnerResultsModel.index(index, 0));
//                        toggleDash();
//                        queryField.text = ""
//                    }
//                }
//            }
//        }
        PaginatedGrid {
            id: krunnerResultsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: queryField.text.length > 0

            cellWidth: 180
            cellHeight: 180
            totalCount: krunnerResultsModel.rowCount()
//            model: krunnerResultsModel
//            modelType: PaginatedGrid.ModelType.MilouModel
//            iconModelKey: "decoration"
//            labelModelKey: "display"

            delegate: IconItem {
                anchors.fill: parent
                icon: krunnerResultsModel.data(krunnerResultsModel.index(itemIndex, 0), 1)
                label: krunnerResultsModel.data(krunnerResultsModel.index(itemIndex, 0), 0)
            }

//            onClicked: {
//                krunnerResultsModel.run(krunnerResultsModel.index(index, 0));
//                toggleDash();
//                queryField.text = "";
//            }
        }
    }

    function focus() {
        keyboardNavFocusScope.focus = true;
    }
}
