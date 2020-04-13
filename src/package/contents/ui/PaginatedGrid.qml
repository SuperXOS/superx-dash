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

Item {
    id: root
    
    property int cellWidth
    property int cellHeight
    property ListModel model
    property string iconModelKey
    property string labelModelKey
    
    property int rows: Math.floor(pageHolder.height/root.cellHeight)
    property int cols: Math.floor(pageHolder.width/root.cellWidth)
    property int pages: Math.ceil(model.count/(rows*cols))
    property int itemsPerPage: rows*cols
    
    signal clicked(var model)
    signal openContextMenu(int index);
    
    Connections {
        target: root
        onModelChanged: {
            console.log("Model Changed")
        }
    }
    
    ListView {
        id: pageHolder
        
        clip: true
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        model: pages
            
        delegate: GridLayout {
            id: grid
            property int startIndex: index*itemsPerPage
            
            width: pageHolder.width
            height: pageHolder.height
            columns: cols
            
            Repeater {
                id: gridItemRepeater
                model: itemsPerPage
                property int itemIndex: index

                delegate: IconItem {                    
                    id: gridItem
                    
                    Layout.fillHeight: true
                    Layout.fillWidth: true 
                    Layout.margins: 40
                    icon: root.model.get(startIndex+index) ? root.model.get(startIndex+index)[iconModelKey] : ""
                    label: root.model.get(startIndex+index) ? root.model.get(startIndex+index)[labelModelKey] : ""
                    onOpenContextMenu: root.openContextMenu(startIndex+index)
                    onClicked: root.clicked(root.model.get(startIndex+index))
                }
            }
        }
    }

    function reset() {
        root.rows = 0;
        root.cols = 0;
        root.pages = 0;
        root.itemsPerPage = 0;

        root.rows = Math.floor(pageHolder.height/root.cellHeight);
        root.cols = Math.floor(pageHolder.width/root.cellWidth);
        root.pages = Math.ceil(model.count/(rows*cols));
        root.itemsPerPage = rows*cols;
    }
}
