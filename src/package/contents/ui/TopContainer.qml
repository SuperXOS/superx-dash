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
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.14

import org.kde.kirigami 2.7 as Kirigami

Item {
    property alias queryField: queryField
    id: root

//    SystemFavoritesContainer {
//        anchors {
//            left: parent.left
//            top: parent.top
//            bottom: parent.bottom
//        }
//    }

    Kirigami.Icon {
        width: 30
        height: 30
        source: "window-close"
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 20
        }

        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: "#ffeeeeee"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                toggleDash();
            }
        }
    }

    TextArea {
        id: queryField
        width: 500
        height: 30
        anchors.centerIn: parent
        placeholderText: "Search"
        onCursorVisibleChanged: cursorVisible = false
        background: Rectangle {
            radius: 4
            color: Kirigami.Theme.activeBackgroundColor
        }
        color: Kirigami.Theme.textColor
        focus: true
        onActiveFocusChanged: {
            queryField.focus = true;
        }

        onTextChanged: {
            var t = text.trim();

            if (t.length === 0) {
                text = "";
            }
        }
        Keys.onPressed: {
            switch(event.key) {
                case Qt.Key_Up:
                    appsGridContainer.appsGrid.moveHighlightUp();
                    appsGridContainer.krunnerResultsGrid.moveHighlightUp();
                    event.accepted = true;
                    break;
                case Qt.Key_Down:
                    appsGridContainer.appsGrid.moveHighlightDown();
                    appsGridContainer.krunnerResultsGrid.moveHighlightDown();
                    event.accepted = true;
                    break;
                case Qt.Key_Left:
                    appsGridContainer.appsGrid.moveHighlightLeft();
                    appsGridContainer.krunnerResultsGrid.moveHighlightLeft();
                    event.accepted = true;
                    break;
                case Qt.Key_Right:
                    appsGridContainer.appsGrid.moveHighlightRight();
                    appsGridContainer.krunnerResultsGrid.moveHighlightRight();
                    event.accepted = true;
                    break;

                case Qt.Key_Enter:
                case Qt.Key_Return:
                    if (appsGridContainer.appsGrid.visible) {
                        appsGridContainer.appsGrid.clickHighlightedItem();
                    } else if (appsGridContainer.krunnerResultsGrid.visible) {
                        appsGridContainer.krunnerResultsGrid.clickHighlightedItem();
                    }

                    break;
            }
        }
    }

    Kirigami.Icon {
        width: 20
        height: 20
        source: "window-close"
        anchors {
            right: queryField.right
            verticalCenter: queryField.verticalCenter
            rightMargin: 5
        }

        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: "#ff888888"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                queryField.text = "";
            }
        }
    }

    SystemFavoritesContainer {
        id: infoContainer
        height: 48
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            margins: 10
        }
    }
}
