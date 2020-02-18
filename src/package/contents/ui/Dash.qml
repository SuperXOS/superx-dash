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

Rectangle {
    anchors.fill: parent
    color: "#55ffffff"

    ListModel {
        id: appsModel

        ListElement { text: "1" }
        ListElement { text: "2" }
        ListElement { text: "3" }
        ListElement { text: "4" }
        ListElement { text: "5" }
        ListElement { text: "6" }
        ListElement { text: "7" }
        ListElement { text: "8" }
        ListElement { text: "9" }
        ListElement { text: "10" }
    }

    GridView {
        id: appsGrid

        anchors.fill: parent
        cellWidth: 50
        cellHeight: 50

        model: appsModel
        delegate: AppItem {
            cellWidth: appsGrid.cellWidth
            cellHeight: appsGrid.cellHeight
        }
    }
}