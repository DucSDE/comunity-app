import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: bg
    visible: true
    color: "#2c313c"
    border.color: "#353b48"
    border.width: 1

    Rectangle {
        id: appContainer
        color: "transparent"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 1
        anchors.leftMargin: 1
        anchors.bottomMargin: 1
        anchors.topMargin: 1

        Rectangle {
            id: topBar
            color: "#1c1d20"
            width: parent.width
            height: 60
            anchors {
                top: appContainer.top
                left: appContainer.left
                right: appContainer.right
            }
            Button {
                id: toggleButton
                width: 70
                height: 60
                text: "Foo"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.leftMargin: 0
            }

            Rectangle {
                height: 35
                id: titleBar
                anchors {
                    left: toggleButton.right
                }
                color: "transparent"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: topbarDescription.top
                anchors.rightMargin: 105
                anchors.bottomMargin: 0
                anchors.topMargin: 0


                Image {
                    id: appIcon
                    height: 30
                    width: 30
                    anchors {
                        left: parent.left
                        leftMargin: 5
                        verticalCenter: titleBar.verticalCenter
                    }
                    source: "qrc:/UI/assets/icons/group.ico"
                }

                Label {
                    id: labelAppTitle
                    opacity: 1
                    color: "white"
                    text: "HCL Training Comunity"
                    anchors.left: appIcon.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.family: "Segoe UI"
                    font.bold: true
                    font.pointSize: 10
                    anchors{
                        leftMargin: 5
                    }
                    wrapMode: Label.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

            }

            Row {
                id: systemButton
                width: 105
                height: 35

                anchors.verticalCenter: titleBar.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 0

                Button {
                    id: btnMinimized
                    height: 35
                    width: 35
                    anchors.verticalCenter: btnMaximized.verticalCenter
                    text : "_"
                }
                Button {
                    id: btnMaximized
                    width: 35
                    height: 35
                    anchors.verticalCenter: btnClose.verticalCenter
                    text : "^"

                }
                Button {
                    id: btnClose
                    width: 35
                    height: 35
                    anchors.verticalCenter: parent.verticalCenter
                    text : "X"
                }
            }

            Rectangle {
                id: topbarDescription
                height: 25
                anchors {
                    bottom: topBar.bottom
                    left: toggleButton.right
                    right: topBar.right
                }
                color: "#282c34"
            }



        }

        MainScreen {
            id: mainSreen
            anchors {
                top: topBar.bottom
                bottom: appContainer.bottom
                left: appContainer.left
                right: appContainer.right
            }
        }

        onWidthChanged: {
            if (bg.width < 580) {
                labelAppTitle.font.pointSize = 13
            }
            else if (bg.width > 600) {
                labelAppTitle.font.pointSize = 15
            }
        }


        DropShadow {
            id: dropShadowTopbar
            anchors.fill: topBar
            source: topBar
            verticalOffset: 0
            horizontalOffset: 0
            radius: 10
            color: "white"
            z: 0
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.66;height:680;width:1080}D{i:4}D{i:8}D{i:7}
}
##^##*/
