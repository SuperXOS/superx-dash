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
    property Menu contextMenu
    
    
    ListView {
        id: pageHolder
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
            
//         Repeater {
            model: calculatePages()
            
            /**
            * Gridview for listing the installed applications
            */
            delegate: GridLayout {
                property int startIndex: index*calculateItemsPerPage()
                
                width: pageHolder.width
                height: pageHolder.height
                columns: calculateColumns()

    //             highlight: Rectangle {
    //                 width: parent.cellWidth
    //                 height: parent.cellHeight
    //                 color: "lightsteelblue"
    //             }

                Repeater {
                    model: calculateItemsPerPage()
                    IconItem {
                        Layout.fillHeight: true
                        Layout.fillWidth: true 
                        Layout.margins: 20
                        icon: root.model.get(startIndex + index).icon
                        label: root.model.get(startIndex + index).name
                    }
                }
            }
//         }
    }
    
//     Timer {
//         id: startTimer
//         interval: 100
//         repeat: false
//         onTriggered: {
//             pageRepeater.model = calculatePages();
//             console.log(">>>", calculateItemsPerPage());
//         }
//     }
    
//     Component.onCompleted: startTimer.start()
    
//     function updateMeasurements() {
//         var rows = Math.floor(pageHolder.height/root.cellHeight);
//         var cols = Math.floor(pageHolder.width/root.cellWidth);
// 
//         grid.columns = cols;
//         grid.width = cols*root.cellWidth;
//         gridRepeater.model = generateDisplayModel(0, rows*cols);
//     }
    
    function calculatePages() {
        var rows = Math.floor(pageHolder.height/root.cellHeight);
        var cols = Math.floor(pageHolder.width/root.cellWidth);
        
        return Math.floor(model.count/(rows*cols));
    }
    
    function calculateColumns() {
        var cols = Math.floor(pageHolder.width/root.cellWidth);
        
        return cols;
    }
    
    function calculateItemsPerPage() {
        var rows = Math.floor(pageHolder.height/root.cellHeight);
        var cols = Math.floor(pageHolder.width/root.cellWidth);
        
        return rows*cols;
    }
    /*
    function generateDisplayModel(start, count) {
        var displayModel = Qt.createQmlObject("import QtQuick 2.14; ListModel {}", root);
        
        for (var i=start; i<start+count; i++) {
            console.log(i);
            if (i == root.model.count) {
                break;
            }
            
            displayModel.append(root.model.get(i));
        }
        
        return displayModel;
    }*/
}
