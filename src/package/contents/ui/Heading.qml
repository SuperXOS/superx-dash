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

Item {
    property alias text: t.text
    property real textSize: 22
    property string textColor: "#ffffff"

    Text {
        id: t
        anchors {
            left: parent.left
            leftMargin: 20
            rightMargin: 20
        }
        font.pixelSize: textSize
        color: textColor

        padding: 10
        rightPadding: 250
    }
    Rectangle {
        height: 1
        anchors {
            left: parent.left
            right: parent.right
            bottom: t.bottom
        }
        color: "#bbb"
        visible: false
    }
} 
