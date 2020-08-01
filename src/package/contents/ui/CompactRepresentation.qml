/***************************************************************************
 *   Copyright (C) 2013-2014 by Eike Hein <hein@kde.org>                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import Qt.labs.settings 1.0

Item {
    id: root

    readonly property bool inPanel: (plasmoid.location === PlasmaCore.Types.TopEdge
        || plasmoid.location === PlasmaCore.Types.RightEdge
        || plasmoid.location === PlasmaCore.Types.BottomEdge
        || plasmoid.location === PlasmaCore.Types.LeftEdge)
    readonly property bool vertical: (plasmoid.formFactor === PlasmaCore.Types.Vertical)
    property QtObject dashWindow: null
    property var apps: [];
    property var allAppsSorted: [];

    onWidthChanged: updateSizeHints()
    onHeightChanged: updateSizeHints()

    onDashWindowChanged: {
        if (dashWindow) {
            dashWindow.visualParent = root;
        }
    }

    function updateSizeHints() {
        root.Layout.minimumWidth = units.iconSizes.small;
        root.Layout.maximumWidth = inPanel ? units.iconSizeHints.panel : -1;
        root.Layout.minimumHeight = units.iconSizes.small;
        root.Layout.maximumHeight = inPanel ? units.iconSizeHints.panel : -1;
    }

    Connections {
        target: units.iconSizeHints

        onPanelChanged: root.updateSizeHints()
    }

    PlasmaCore.IconItem {
        id: buttonIcon

        anchors.fill: parent

        readonly property double aspectRatio: (root.vertical ? implicitHeight / implicitWidth
            : implicitWidth / implicitHeight)

        source: "start-here-kde"

        active: mouseArea.containsMouse && !justOpenedTimer.running

        smooth: true

        // A custom icon could also be rectangular. However, if a square, custom, icon is given, assume it
        // to be an icon and round it to the nearest icon size again to avoid scaling artifacts.
        roundToIconSize: !root.useCustomButtonImage || aspectRatio === 1

        onSourceChanged: root.updateSizeHints()
    }

    MouseArea
    {
        id: mouseArea
        property bool wasExpanded: false;

        anchors.fill: parent

        hoverEnabled: !root.dashWindow || !root.dashWindow.visible

        onClicked: {
            root.dashWindow.toggleDash();
            justOpenedTimer.start();
        }
    }

    Settings {
        id: settings
        category: "SuperXDash"

        property int gridItemSize: 180;
        property int paginationSpeed: 1000;
        property string pinned: "{}";
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

    Component.onCompleted: {
        dashWindow = Qt.createQmlObject("Dash {}", root);
        plasmoid.activated.connect(function() {
            dashWindow.toggleDash();
            justOpenedTimer.start();
        })
    }

    ListModel {
        id: categoriesModel
    }

    function populateCategories() {
        var categoriesArray = [
            {
              "icon": "applications-all",
              "name": "Applications",
              "url": "/"
            },
            {
              "icon": "applications-development",
              "name": "Development",
              "url": "Development/"
            },
            {
              "icon": "applications-education",
              "name": "Education",
              "url": "Education/"
            },
            {
              "icon": "applications-games",
              "name": "Games",
              "url": "Games/"
            },
            {
              "icon": "applications-graphics",
              "name": "Graphics",
              "url": "Graphics/"
            },
            {
              "icon": "applications-internet",
              "name": "Internet",
              "url": "Internet/"
            },
            {
              "icon": "applications-multimedia",
              "name": "Multimedia",
              "url": "Multimedia/"
            },
            {
              "icon": "applications-office",
              "name": "Office",
              "url": "Office/"
            },
            {
              "icon": "applications-system",
              "name": "System",
              "url": "System/"
            },
            {
              "icon": "applications-utilities",
              "name": "Utilities",
              "url": "Utilities/"
            },
            {
              "icon": "applications-other",
              "name": "Others",
              "url": "Applications/"
            }
        ];

        categoriesModel.clear();

        for (var i in categoriesArray) {
            var category = categoriesArray[i];

            if (appsSource.data[category.url].entries.length > 0) {
                categoriesModel.append(category);
            }

        }
    }

    function populateAppsModel(source, shouldPopulateCategories=true) {
        if (shouldPopulateCategories) {
            populateCategories();
        }

        var entries = appsSource.data[source].entries;
        var _apps = {};
        var pinnedJsonObj = JSON.parse(settings.pinned);

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
                            _apps[entry.menuId] = {
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
                allAppsSorted = Object.keys(_apps).map((e) => [e, _apps[e].name]).sort((a,b) => a[1].localeCompare(b[1])).map((e) => _apps[e[0]]);
            }
        }

        apps = []

        if (source === "/") {
            Object.keys(pinnedJsonObj).map((k) => {
                apps.push({
                    name: pinnedJsonObj[k].name,
                    icon: pinnedJsonObj[k].icon,
                    url: pinnedJsonObj[k].url,
                    isPinned: true
                });
            });

            allAppsSorted.forEach((app) => {
                var skip = false;

                if (!pinnedJsonObj[app.url]) {
                    apps.push(app);
                }
            });
        } else {
            Object.keys(_apps).map((e) => [e, _apps[e].name]).sort((a,b) => a[1].localeCompare(b[1])).map((e) => apps.push(_apps[e[0]]));
        }
    }
}
