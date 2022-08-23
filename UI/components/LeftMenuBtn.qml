import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Button{
    id: btnLeftMenu
    text: qsTr("Left Menu Text")
    flat: true
    display: AbstractButton.IconOnly

    // CUSTOM PROPERTIES
    property string btnIconSource: "qrc:/UI/assets/images/cil-home.png"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272E"
    property color btnColorClicked: "#00a1f1"
    property int iconWidth: 18
    property int iconHeight: 18
    property color activeMenuColor: "#55aaff"
    property color activeMenuColorRight: "#2c313c"
    property bool isActiveMenu: false

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property color dynamicColor: if(btnLeftMenu.down){
                                      return btnLeftMenu.down ? btnColorClicked : btnColorDefault
                                   } else {
                                      return btnLeftMenu.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    implicitWidth: 250
    implicitHeight: 60

    background: Rectangle{

        color: internal.dynamicColor

        Rectangle{
            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
            color: activeMenuColor
            width: 3
            visible: isActiveMenu
        }

        Rectangle{
            anchors{
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            color: activeMenuColor
            width: 3
            visible: isActiveMenu
        }

    }

    Item{
        id: content
        anchors.fill: parent

        Image {
            id: iconBtn
            source: btnIconSource
            anchors.leftMargin: 26
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            sourceSize.width: iconWidth
            sourceSize.height: iconHeight
            width: iconWidth
            height: iconHeight
            fillMode: Image.PreserveAspectFit
            visible: true
            antialiasing: true
        }

        ColorOverlay{
            anchors.fill: iconBtn
            source: iconBtn
            color: "#ffffff"
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            width: iconWidth
            height: iconHeight
        }

        Text{
            color: "#ffffff"
            text: btnLeftMenu.text
            font: btnLeftMenu.font
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 75
        }
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:60;width:250}
}
##^##*/
