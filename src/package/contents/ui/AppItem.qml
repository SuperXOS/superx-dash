import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14

import org.kde.kirigami 2.7 as Kirigami

/**
  * Provides the delegate to display an application item
  */
Item {
    property var cellWidth;
    property var cellHeight;

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
        onClicked: parent.GridView.view.currentIndex = index
    }
}
