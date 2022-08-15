import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Button{
    id: btnToggle
    // CUSTOM PROPERTIES
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272E"
    property color btnColorClicked: "#00a1f1"
    layer.smooth: true
    layer.enabled: true
    focus: true
    antialiasing: true
    clip: true
    flat: true

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property color dynamicColor: if(btnToggle.down){
                                       btnToggle.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnToggle.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    implicitWidth: 70
    implicitHeight: 60



    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
        Image {
            id: iconBtn
            source: "qrc:/UI/assets/images/menu.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.width: 20
            sourceSize.height: 20
            width: 25
            height: 25
            fillMode: Image.PreserveAspectFit
            visible: true
            smooth: true

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
    D{i:0;height:60;width:70}
}
##^##*/
