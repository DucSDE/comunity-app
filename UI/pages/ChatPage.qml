import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../components"

Rectangle {
    id: chatPage

    anchors.fill: parent
    color: "transparent"

    Rectangle {
        id: topBar
        height: 60
        width: parent.width
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        color: "#f3b89f"

        Text {
            text: "Message"
            anchors {
                left: parent.left
                leftMargin: 20
                verticalCenter: topBar.verticalCenter
            }
//            verticalAlignment: Text.AlignVCenter
            font.pointSize: 14
            font.bold: true
            font.family: "UTM Avo"
        }
    }

    Rectangle {
        id: content
        color: "transparent"

        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }


        Rectangle {
            id: messageListPanel
            width: 270
            color: "red"
            border.width: 0

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            antialiasing: true
            clip: true
            smooth: true

            ListView {
                id: listView
                anchors.fill: parent
                anchors {
                    leftMargin: 10
                    rightMargin: 10
                }

                model: 20
                delegate: chatDelegate
                clip: true

            }

        }

        Rectangle {
            id: messagePanel
            width: content.width - ( messageListPanel.width + detailMessagePanel.width )
            color: "#af5f3d"
            border.width: 0
            anchors.right: detailMessagePanel.left
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors {
                left: messageListPanel.right
                top: parent.top
            }

            Text{
                id: defaultMessage
                text: "Start new message with your friend with click on their avatar ^-^"
                width: messagePanel.width
                font.bold: true
                font.family: "UTM Avo"
                font.pointSize: 12
                anchors.centerIn: parent
                wrapMode: Text.WordWrap
                visible: true
            }

            Rectangle {
                id: onMessageReading

                anchors.fill: parent
                visible: defaultMessage.visible ? false : true

                ToggleButton {
                    id: openDetail
                    anchors {
                        right: parent.right
                        top: parent.top
                        margins: 24
                    }
                    onClicked: animationDetai.start()
                    clip: true
                }
            }

        }

        Rectangle {
            id: detailMessagePanel
            width: 200
            PropertyAnimation {
                id: animationDetai

                target: detailMessagePanel
                property: "width"
                to: {
                    if(detailMessagePanel.width == 0)
                        return 200;
                    else
                        return 0
                }

                duration: 1000
                easing.type: Easing.InOutQuint
            }

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            color: "#45e972"
            border.width: 0
        }

        Component {
            id: chatDelegate

            Row {
                id: row
                width: listView.width
                height: 80

                Rectangle {
                    id: imageArea
                    height: parent.height
                    width: height
                    color: "yellow"
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    radius: width/2
                    Image {
                        id: avatarUser
                        width: 45
                        height: 45
                        sourceSize.width:  35
                        sourceSize.height: 35

                        anchors.verticalCenter: imageArea.verticalCenter
                        source: "qrc:/UI/assets/images/hcl_logo_bluepng.png"
                    }

                }

                Rectangle {
                    height: parent.height
                    anchors {
                        right: parent.right
                        left: imageArea.right
                    }
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10

                    color: "green"
                    anchors.leftMargin: 10
                }
            }
        }
    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:580;width:1080}D{i:4}D{i:6}D{i:8}D{i:12}
D{i:11}
}
##^##*/
