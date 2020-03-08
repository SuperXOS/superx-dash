

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

import org.kde.kirigami 2.7 as Kirigami


/**
  * Provides the delegate to display an application item
  */
Item {
    property var cellWidth
    property var cellHeight

    signal openApp

    id: appItem
    width: cellWidth
    height: cellHeight

    Kirigami.Icon {
        id: appIcon
        width: parent.width - 40
        height: parent.height - 40
        anchors.horizontalCenter: parent.horizontalCenter
        source: model.icon
    }
    Text {
        id: appName

        anchors {
            top: appIcon.bottom
            topMargin: 20
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
        }
        text: model.name
        color: "#ff444444"
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.GridView.view.currentIndex = index
            openApp()
        }
    }
}
