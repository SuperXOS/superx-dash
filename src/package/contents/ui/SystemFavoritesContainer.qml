import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.14

import org.kde.kirigami 2.7 as Kirigami
import com.superxos.dash 1.0 as SuperXDashPlugin

Rectangle {
    property int spacing: 30

    id: root
    z: 1000

    Item {
        id: shutdownButton
        width: parent.height
        height: parent.height
        anchors {
            left: root.left
            top: root.top
            leftMargin: root.spacing
            rightMargin: root.spacing
        }

        Kirigami.Icon {
            anchors.fill: parent
            source: "system-shutdown"

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#ffffffff"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                SuperXDashPlugin.SystemFavourites.onShutdownClicked();
                toggleDash();
            }
        }
    }

    Item {
        id: logoutButton
        width: parent.height
        height: parent.height
        anchors {
            left: shutdownButton.right
            top: root.top
            leftMargin: root.spacing
            rightMargin: root.spacing
        }

        Kirigami.Icon {
            anchors.fill: parent
            source: "system-log-out"

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#ffffffff"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                SuperXDashPlugin.SystemFavourites.onLogoutClicked();
                toggleDash();
            }
        }
    }

    Item {
        id: rebootButton
        width: parent.height
        height: parent.height
        anchors {
            left: logoutButton.right
            top: root.top
            leftMargin: root.spacing
            rightMargin: root.spacing
        }

        Kirigami.Icon {
            anchors.fill: parent
            source: "system-reboot"

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#ffffffff"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                SuperXDashPlugin.SystemFavourites.onRebootClicked();
                toggleDash();
            }
        }
    }
}
