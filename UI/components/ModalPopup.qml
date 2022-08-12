import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: popup

    property string msg

    implicitWidth: 300
    implicitHeight: 150

    color: "#151515"
    clip: true
    z: 2
    visible: true

    CustomButton {
        id: btnClose
        width: 30
        height: 30
        opacity: 1
        text: qsTr("X")
        flat: true
        antialiasing: true
        layer.smooth: true
        anchors {
            right: parent.right
            top: parent.top
            margins: 10
        }

        colorPressed: "#558b1f"
        colorMouseOver: "#7ece2d"
        colorDefault: "#2aafd3"
        font.family: "Segoe UI"
        font.pointSize: 10
        onClicked: {
            popup.visible = false
        }
    }

    Text {
        id: messageText
        text: msg
        anchors {
            bottom: btnOK.top
            bottomMargin: 10
            horizontalCenter: btnOK.horizontalCenter
        }

        width: parent.width - 50
        height: 40
        font.pointSize: 14
        font.family: "Segoe UI"
        color: "yellow"
        verticalAlignment: Text.AlignVCenter
    }

    CustomButton {
        id: btnOK
        width: parent.width / 2
        height: 40
        opacity: 1
        text: "OK"
        antialiasing: true
        flat: true
        layer.smooth: true
        anchors.bottomMargin: 10
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        colorPressed: "#558b1f"
        colorMouseOver: "#7ece2d"
        colorDefault: "#2aafd3"
        font.family: "Segoe UI"
        font.pointSize: 10
        onClicked: {
            popup.visible = false
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/
