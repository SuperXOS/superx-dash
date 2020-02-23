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

import org.kde.kirigami 2.4 as Kirigami
import com.superxos.dash 1.0 as SuperXDashPlugin

/**
  * Master element of the Dashboard
  */
Rectangle {
    id: root
    anchors.fill: parent
    color: "#ffffffff"

    /**
      * Model for storing list of installed applications.
      * This is used by the Gridview to render the components.
      */
    ListModel {
        id: appsModel

        // { name, icon, url }
    }

    MouseArea {
        id: scrollArea
        anchors.fill: parent

        /**
          * Handle Scroll event for pagination logic
          */
        onWheel: {
            // TODO : Implement pagination functionality
            console.log(wheel.angleDelta)
        }
    }

    /**
      * Gridview for listing the installed applications
      */
    GridView {
        id: appsGrid
        anchors.fill: parent

        cellWidth: 130
        cellHeight: 130
        focus: true
        model: appsModel
        snapMode: GridView.SnapPosition
        flow: GridView.FlowTopToBottom

        highlight: Rectangle {
            width: parent.cellWidth
            height: parent.cellHeight
            color: "lightsteelblue"
        }

        delegate: AppItem {
            cellWidth: appsGrid.cellWidth - 30
            cellHeight: appsGrid.cellHeight - 30            
            onOpenApp: {
                SuperXDashPlugin.AppsList.openApp(model.url)
            }
        }
    }

    Connections {
        target: SuperXDashPlugin.AppsList

        /**
          * Receive and inset applications list to model for rendering.
          */
        onAppsListResult: {
            apps.forEach((e) => {
                             if (e.mimeType === "inode/directory") {
                                 return;
                             } else if (e.name === ".") {
                                 return;
                             }

                             appsModel.append({
                                name: e.name.split("/").pop(),
                                icon: e.icon,
                                url: e.url
                             });
                         })
        }
    }

    /**
      * Fetch the applications list when QML gets loaded
      */
    Component.onCompleted: {
        SuperXDashPlugin.AppsList.appsList();
    }
}
