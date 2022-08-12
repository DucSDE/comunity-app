import QtQuick 2.0
import Buttons 1.0

Rectangle {
    id: leftSideBar
    width: 70
    height: parent.height
    color: "#1c1d20"
    anchors {
        top: parent.top
        left: parent.left
        bottom: parent.bottom
    }

    Column {
        id: menuColumns
//        CustomButton {
//            id: settingButton

//            anchors {
//                bottom: leftSideBar.bottom
//                left: leftSideBar.left
//                right: leftSideBar.right
//            }

//            width: 50
//            height: width
//            text: "X"
//        }
    }
}
