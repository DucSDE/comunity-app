import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Button{
    id: btnTopBar
    // CUSTOM PROPERTIES
    property string btnIconSource: "qrc:/UI/assets/images/cil-fullscreen.png"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272E"
    property color btnColorClicked: "#00a1f1"

    layer.smooth: true
    layer.enabled: true
    focus: true
    antialiasing: true
    clip: true
    flat: true

    implicitWidth: 35
    implicitHeight: 35

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property color dynamicColor: if(btnTopBar.down){
                                       btnTopBar.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnTopBar.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    width: 35
    height: 35

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
        Image {
            id: iconBtn
            source: btnIconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 20
            sourceSize.width: 20
            height: 20
            width: 20
            visible: true
            fillMode: Image.PreserveAspectFit
            antialiasing: false
        }

        ColorOverlay{
            anchors.fill: iconBtn
            source: iconBtn
            color: "#ffffff"
            antialiasing: false
        }
    }


}



/*##^##
Designer {
    D{i:0;height:35;width:35}
}
##^##*/
