import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import com.superxos.dash 1.0 as SuperXDashPlugin

RowLayout {
    z: 1000

    IconItem {
        width: 100
        height: 100
        icon: "system-shutdown"
        label: "Shutdown"
        onClicked: SuperXDashPlugin.SystemFavourites.onShutdownClicked()
    }

    IconItem {
        width: 100
        height: 100
        icon: "system-log-out"
        label: "Logout"
        onClicked: SuperXDashPlugin.SystemFavourites.onLogoutClicked()
    }

    IconItem {
        width: 100
        height: 100
        icon: "system-reboot"
        label: "Reboot"
        onClicked: SuperXDashPlugin.SystemFavourites.onRebootClicked()
    }
}
