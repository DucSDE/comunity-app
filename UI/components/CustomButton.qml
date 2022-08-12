import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Button {
    id: button

    // Custom Properties
    property color colorDefault: "#4891d9"
    property color colorMouseOver: "#55AAFF"
    property color colorPressed: "#3F7EBD"

    QtObject{
        id: internal

        property var dynamicColor: if(button.down){
                                       button.down ? colorPressed : colorDefault
                                   }else{
                                       button.hovered ? colorMouseOver : colorDefault
                                   }
    }

    text: qsTr("Button")
    layer.smooth: true
    display: AbstractButton.TextOnly
    focus: true
    smooth: true
    layer.enabled: true
    contentItem: Item{
        Text {
            id: name
            text: button.text
            font: button.font
            color: "#ffffff"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    background: Rectangle{
        color: internal.dynamicColor
        radius: 10
    }
    flat: true
    antialiasing: true
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:40;width:200}
}
##^##*/
