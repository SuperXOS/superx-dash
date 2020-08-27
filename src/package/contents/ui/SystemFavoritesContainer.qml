import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.14

import org.kde.kirigami 2.7 as Kirigami
import com.superxos.dash 1.0 as SuperXDashPlugin

//Rectangle {
//    property int spacing: 30

//    id: root
//    z: 1000

//    Item {
//        id: shutdownButton
//        width: parent.height
//        height: parent.height
//        anchors {
//            left: root.left
//            top: root.top
//            leftMargin: root.spacing
//            rightMargin: root.spacing
//        }

//        Kirigami.Icon {
//            anchors.fill: parent
//            source: "system-shutdown"

//            ColorOverlay {
//                anchors.fill: parent
//                source: parent
//                color: "#ffffffff"
//            }
//        }

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                SuperXDashPlugin.SystemFavourites.onShutdownClicked();
//                toggleDash();
//            }
//        }
//    }

//    Item {
//        id: logoutButton
//        width: parent.height
//        height: parent.height
//        anchors {
//            left: shutdownButton.right
//            top: root.top
//            leftMargin: root.spacing
//            rightMargin: root.spacing
//        }

//        Kirigami.Icon {
//            anchors.fill: parent
//            source: "system-log-out"

//            ColorOverlay {
//                anchors.fill: parent
//                source: parent
//                color: "#ffffffff"
//            }
//        }

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                SuperXDashPlugin.SystemFavourites.onLogoutClicked();
//                toggleDash();
//            }
//        }
//    }

//    Item {
//        id: rebootButton
//        width: parent.height
//        height: parent.height
//        anchors {
//            left: logoutButton.right
//            top: root.top
//            leftMargin: root.spacing
//            rightMargin: root.spacing
//        }

//        Kirigami.Icon {
//            anchors.fill: parent
//            source: "system-reboot"

//            ColorOverlay {
//                anchors.fill: parent
//                source: parent
//                color: "#ffffffff"
//            }
//        }

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                SuperXDashPlugin.SystemFavourites.onRebootClicked();
//                toggleDash();
//            }
//        }
//    }
//}

RowLayout {
    Item {
        width: parent.height
        height: parent.height

        Kirigami.Icon {
            anchors.fill: parent
            source: kuser.faceIconUrl
            anchors.margins: 6
        }

        Rectangle {
            anchors.margins: 3
            anchors.fill: parent
            color: "transparent"
            border.color: Qt.rgba(255,255,255,0.8)
            border.width: 2
            radius: parent.width
        }
    }

    Text {
        id: username
        text: kuser.fullName
        verticalAlignment: Text.AlignVCenter
        color: "#fff"
        font.pointSize: 10
        leftPadding: 4
        rightPadding: 4
    }

    Item {
        width: 1
        height: parent.height

        Rectangle {
            width: 1
            height: parent.height
            anchors.centerIn: parent
            opacity: 0.5
        }
    }

    Rectangle {
        width: parent.height*3-30
        height: parent.height
        radius: parent.height
        color: Qt.rgba(0,0,0,0.5)
        Layout.leftMargin: 5

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Item {
                width: parent.height
                height: parent.height

                Kirigami.Icon {
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    source: "system-shutdown"
                    smooth: true
                    antialiasing: true

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
                width: parent.height
                height: parent.height

                Kirigami.Icon {
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    source: "system-reboot"
                    smooth: true
                    antialiasing: true

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
            Item {
                width: parent.height
                height: parent.height

                Kirigami.Icon {
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    source: "system-log-out"
                    smooth: true
                    antialiasing: true

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
        }
    }
}
