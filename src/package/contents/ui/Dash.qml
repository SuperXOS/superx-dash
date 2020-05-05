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

import org.kde.kirigami 2.7 as Kirigami
import com.superxos.dash 1.0 as SuperXDashPlugin
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.plasma.core 2.0 as PlasmaCore

import "tools.js" as Tools

/**
  * Master element of the Dashboard
  */
Kicker.DashboardWindow {
    property bool isOpen: false;
    property bool showPinned: true;
    property var allAppsSorted: [];

    backgroundColor: Qt.rgba(0,0,0,0.7)
    onKeyEscapePressed: {
        toggleDash();
    }

    mainItem: Item {
        id: root
        anchors.fill: parent

        /**
        * Model for storing list of installed applications.
        * This is used by the Gridview to render the components.
        */
        ListModel {
            id: appsModel

            // { name, icon, url }
        }

        /**
        * Model for storing categories
        */
        ListModel {
            id: categoriesModel

            ListElement {
              icon: "applications-all"
              name: "Applications"
              url: "/"
            }
            ListElement {
                icon: "applications-development"
                name: "Development"
                url: "Development/"
            }
            ListElement {
              icon: "applications-education"
              name: "Education"
              url: "Education/"
            }
            ListElement {
              icon: "applications-games"
              name: "Games"
              url: "Games/"
            }
            ListElement {
              icon: "applications-graphics"
              name: "Graphics"
              url: "Graphics/"
            }
            ListElement {
              icon: "applications-internet"
              name: "Internet"
              url: "Internet/"
            }
            ListElement {
              icon: "applications-multimedia"
              name: "Multimedia"
              url: "Multimedia/"
            }
            ListElement {
              icon: "applications-office"
              name: "Office"
              url: "Office/"
            }
            ListElement {
              icon: "applications-system"
              name: "System"
              url: "System/"
            }
            ListElement {
              icon: "applications-utilities"
              name: "Utilities"
              url: "Utilities/"
            }
            ListElement {
              icon: "applications-other"
              name: "Others"
              url: "Applications/"
            }
        }

        SystemFavoritesContainer {
            visible: false
            height: 40
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 30
            }
        }

        Kirigami.Icon {
            width: 40
            height: 40
            source: "window-close"
            anchors {
                top: parent.top
                right: parent.right
                margins: 30
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
                                    appsModel.clear();

                                    appsGridContainer.headingText = model.name;
                                    populateAppsModel(model.url)

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
            }
        }

        PlasmaCore.DataSource {
            id: appsSource
            engine: "apps"

            onSourceAdded: {
                connectSource(source);
            }

            onSourcesChanged: {
                sourcesChangedTimer.stop();
                sourcesChangedTimer.start();
            }

            Component.onCompleted: {
                connectedSources = sources;
                populateAppsModel("/");
            }
        }

        Timer {
            id: dashOpenTimer
            repeat: false
            interval: 100
            onTriggered: {
                appsGridContainer.appsGrid.reset();
            }
        }
    }

    function populateAppsModel(source) {
        var entries = appsSource.data[source].entries;
        var apps = {};
        var pinnedJsonArray = plasmoid.configuration.pinned && JSON.parse(plasmoid.configuration.pinned) || [];

        console.log("### All Apps length", allAppsSorted.length)

        /**
         * If source is "All Apps" then populate allAppsSorted if not populated and continue
         * If source is something else, populate and continue
         **/
        if ((source === "/" && allAppsSorted.length === 0) || source !== "/") {

            while (entries.length > 0) {
                var entry = appsSource.data[entries.shift()];

                if (entry) {
                    if (entry.isApp) {
                        if (entry.display) {
                            apps[entry.menuId] = {
                               name: entry.name,
                               icon: entry.iconName,
                               url: entry.entryPath
                            };
                        }
                    } else {
                        entries.unshift(...entry.entries);
                    }
                }
            }

            if (source === "/") {
                allAppsSorted = Object.keys(apps).map((e) => [e, apps[e].name]).sort((a,b) => a[1].localeCompare(b[1])).map((e) => apps[e[0]]);
            }
        }

        appsModel.clear();

//        console.log("All Apps Sorted", JSON.stringify(allAppsSorted, null, 2));

        if (source === "/") {
            pinnedJsonArray.map((e) => {
                appsModel.append({
                    name: e.name,
                    icon: e.icon,
                    url: e.url,
                    isPinned: true
                });
            });

            allAppsSorted.forEach((app) => {
                var skip = false;

                for (var index in pinnedJsonArray) {
                    if (pinnedJsonArray[index].url === app.url) {
                        skip = true
                        break;
                    }
                }

                if (!skip) {
                    appsModel.append(app);
                }
            });
        } else {
            Object.keys(apps).map((e) => [e, apps[e].name]).sort((a,b) => a[1].localeCompare(b[1])).map((e) => appsModel.append(apps[e[0]]));
        }

        appsGridContainer.appsGrid.reset();
    }

    function toggleDash() {
        topContainer.queryField.text = "";
        isOpen = !isOpen;
//        SuperXDashPlugin.Utils.showDesktop(isOpen);
        toggle();

        if (isOpen) {
            dashOpenTimer.start();
        }
    }
}
