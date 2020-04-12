import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import com.superxos.dash 1.0 as SuperXDashPlugin

RowLayout {
    z: 1000

    IconItem {
        width: parent.width/3
        height: 100
        icon: "system-shutdown"
        label: "Shutdown"
        color: "#ffffffff"
        onClicked: {
            SuperXDashPlugin.SystemFavourites.onShutdownClicked();
            toggle();
        }
    }

    IconItem {
        width: parent.width/3
        height: 100
        icon: "system-log-out"
        label: "Logout"
        color: "#ffffffff"
        onClicked: {
            SuperXDashPlugin.SystemFavourites.onLogoutClicked();
            toggle();
        }
    }

    IconItem {
        width: parent.width/3
        height: 100
        icon: "system-reboot"
        label: "Reboot"
        color: "#ffffffff"
        onClicked: {
            SuperXDashPlugin.SystemFavourites.onRebootClicked();
            toggle();
        }
    }
}
