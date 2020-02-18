import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14

Rectangle {
    id: appItemRoot

    property alias cellWidth: appItemRoot.width
    property alias cellHeight: appItemRoot.height

    color: "#fff44336"

    Label {
        text: model.text
    }
}
