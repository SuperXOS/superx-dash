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
import QtGraphicalEffects 1.14
import Qt.labs.settings 1.0

import org.kde.kirigami 2.7 as Kirigami
import com.superxos.dash 1.0 as SuperXDashPlugin
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kcoreaddons 1.0 as KCoreAddons

import "tools.js" as Tools

/**
  * Master element of the Dashboard
  */
Kicker.DashboardWindow {
    property bool isOpen: false;
    property bool showPinned: true;

    backgroundColor: Qt.rgba(0,0,0,0.5)
    onKeyEscapePressed: {
        toggleDash();
    }

    mainItem: Item {
        id: root
        anchors.fill: parent

        KCoreAddons.KUser {
            id: kuser
        }

        /**
        * Model for storing list of installed applications.
        * This is used by the Gridview to render the components.
        */
        ListModel {
            id: appsModel

            // { name, icon, url }
        }

        Item {
            property int spacing: 20
            property int topPaneMargin: 0

            id: container
            anchors.fill: parent

            Item {
                id: topPane
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: container.topPaneMargin
                }
                height: 100

                TopContainer {
                    id: topContainer
                    anchors.fill: parent
                    anchors.topMargin: -32
                }
            }

            Item {
                id: leftPane
                visible: false
                width: 0
                anchors {
                    top: topPane.bottom
                    bottom: bottomPane.top
                    left: parent.left
                    leftMargin: container.spacing
                    rightMargin: container.spacing
                    bottomMargin: container.spacing
                    topMargin: container.topPaneMargin
                }
            }

            Item {
                id: rightPane
                anchors {
                    left: leftPane.right
                    top: topPane.bottom
                    bottom: bottomPane.top
                    right: parent.right
                    leftMargin: container.spacing
                    rightMargin: container.spacing
                    bottomMargin: container.spacing
                    topMargin: container.topPaneMargin
                }

                AppGridContainer {
                    id: appsGridContainer
                    anchors.fill: parent
                    queryField: topContainer.queryField
                }
            }

            Item {
                id: bottomPane
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: 120

                RowLayout {
                    height: parent.height
                    anchors.centerIn: parent

                    Repeater {
                        model: categoriesModel

                        Kirigami.Icon {
                            width: 80
                            height: 40
                            source: model.icon
                            anchors.margins: 20

                            ToolTip.visible: mousearea.containsMouse
                            ToolTip.text: model.name

                            MouseArea {
                                id: mousearea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    apps = [];

                                    appsGridContainer.headingText = model.name;
                                    populateAppsModel(model.url, false);

                                    appsGridContainer.appsGrid.totalCount = apps.length;
                                    appsGridContainer.appsGrid.reset();

                                    topContainer.queryField.text = "";
                                }
                            }
                        }
                    }

                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: toggleDash()
            z: -10
        }

        Timer {
            id: sourcesChangedTimer
            interval: 1000
            repeat: false
            onTriggered: {
                populateAppsModel("/");

                appsGridContainer.appsGrid.totalCount = apps.length;
                appsGridContainer.appsGrid.reset();
            }
        }

        Timer {
            id: dashOpenTimer
            repeat: false
            interval: 100
            onTriggered: {
                appsGridContainer.appsGrid.totalCount = apps.length
                appsGridContainer.appsGrid.reset();
            }
        }
    }

    function toggleDash() {
        topContainer.queryField.text = "";

        appsGridContainer.appsGrid.hoverEnabled = false;
        appsGridContainer.appsGrid.highlightIndex = 0;

        appsGridContainer.krunnerResultsGrid.hoverEnabled = false;
        appsGridContainer.krunnerResultsGrid.highlightIndex = 0;

        appsGridContainer.appsGrid.totalCount = apps.length;
        appsGridContainer.appsGrid.reset();

        isOpen = !isOpen;
        SuperXDashPlugin.Utils.showDesktop(isOpen);
        toggle();

        if (isOpen) {
            dashOpenTimer.start();
        }
    }
}
