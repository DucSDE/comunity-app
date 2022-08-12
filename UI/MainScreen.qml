import QtQuick 2.0
import QtQuick 2.15
import QtQuick.Controls 2.15

import Qt5Compat.GraphicalEffects

import "components"

Rectangle {
    id: content
    color: "transparent"
    LeftSideBar {
        id: leftSideBar
    }

    Rectangle {
        id: bottomNavigationBar
        width: parent.width
        height: 50
        color: "orange"
        anchors {
            bottom: parent.bottom
            left: leftSideBar.right
            right: parent.right
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.33;height:480;width:640}
}
##^##*/
