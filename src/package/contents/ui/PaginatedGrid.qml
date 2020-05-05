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

import org.kde.milou 0.3 as Milou
import org.kde.kirigami 2.7 as Kirigami

Item {
    id: root
    
    enum ModelType {
        ListModel,
        MilouModel
    }

    property int cellWidth
    property int cellHeight
    property int totalCount
    property Component delegate
    
    property int rows: Math.floor(pageHolder.height/root.cellHeight)
    property int cols: Math.floor(pageHolder.width/root.cellWidth)
    property int pages: Math.ceil(totalCount/(rows*cols))
    property int itemsPerPage: rows*cols
    property int highlightIndex: 0

    signal highlightClicked(int index);
    
    ListView {
        id: pageHolder
        
        clip: true
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        model: pages

        highlightMoveDuration: 1000
        highlightMoveVelocity: -1

        delegate: GridView {
            id: grid
            width: pageHolder.width
            height: pageHolder.height
            cellWidth: root.cellWidth
            cellHeight: root.cellHeight
            interactive: false
            currentIndex: highlightIndex
            highlight: Rectangle {
                width: root.cellWidth
                height: root.cellHeight
                radius: 4
                color: Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.2)
                visible: pageHolder.currentIndex == index
            }
            highlightFollowsCurrentItem: true

            property int startIndex: index*itemsPerPage

            model: (totalCount - startIndex) < itemsPerPage ? (totalCount - startIndex) : itemsPerPage
            delegate: Item {
                id: gridItem
                width: root.cellWidth
                height: root.cellHeight

                Item {
                    width: parent.width - 35
                    height: parent.height - 35
                    anchors.centerIn: parent

                    Loader {
                        anchors.fill: parent
                        sourceComponent: root.delegate
                        property int itemIndex: startIndex+index
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                    onEntered: {
                        highlightIndex = index;
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: toggleDash()
                z: -1
            }
        }
    }

    PageIndicator {
        currentIndex: pageHolder.currentIndex
        count: pages
        anchors.top: pageHolder.bottom
        anchors.horizontalCenter: pageHolder.horizontalCenter
    }

    Timer {
        id: scrollTimer
        interval: 1010
        repeat: false
    }

    MouseArea {
        id: scrollArea
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: {
            if (!scrollTimer.running) {
                var isMouseWheelUp = wheel.angleDelta.y < 0;

                if (isMouseWheelUp && (pageHolder.currentIndex+1) < pages) {
                    pageHolder.currentIndex++;
                    scrollTimer.start();
                } else if (!isMouseWheelUp && pageHolder.currentIndex > 0) {
                    pageHolder.currentIndex--;
                    scrollTimer.start();
                }

            }
        }
        z: 1000
    }

    function moveHighlightUp() {
        if(highlightIndex-cols < 0) {
            return
        } else {
            highlightIndex = highlightIndex-cols;
        }
    }
    function moveHighlightDown() {
        if(highlightIndex + cols >= pageHolder.currentItem.count || highlightIndex+cols >= itemsPerPage) {
            return
        } else {
            highlightIndex = highlightIndex+cols;
        }
    }
    function moveHighlightLeft() {
        if (highlightIndex%cols-1 >= 0) {
            highlightIndex--;
        } else if (pageHolder.currentIndex > 0) {
            pageHolder.currentIndex--;
            highlightIndex = highlightIndex+cols-1;
        }
    }
    function moveHighlightRight() {
        if (highlightIndex + 1 >= pageHolder.currentItem.count) {
            return
        }

        if (highlightIndex%cols+1 < cols) {
            highlightIndex++;
        } else if (pageHolder.currentIndex < pages-1) {
            pageHolder.currentIndex++;
            highlightIndex = highlightIndex-cols+1;
        }
    }
    function clickHighlightedItem() {
        root.highlightClicked(pageHolder.currentIndex*itemsPerPage+highlightIndex)
    }

    function reset() {
        root.rows = 0;
        root.cols = 0;
        root.pages = 0;
        root.itemsPerPage = 0;
        root.highlightIndex = 0;

        root.rows = Math.floor(pageHolder.height/root.cellHeight);
        root.cols = Math.floor(pageHolder.width/root.cellWidth);
        root.pages = Math.ceil(totalCount/(rows*cols));
        root.itemsPerPage = rows*cols;
    }
}
