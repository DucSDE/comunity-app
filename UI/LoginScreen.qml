import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12

Rectangle {

    width: 400
    height: 680
    color: "#394454"

    Image {
        id: logo
        width: 150
        height: 150
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: inputArea.top
        }

        source: "qrc:/UI/assets/images/hcl_logo.png"
    }

    Rectangle {
        id: inputArea
        width:  parent.width * .9
        height: 120
        color: "transparent"
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            centerIn: parent
        }

        Rectangle {
            id: usernamRect
            width: parent.width
            height: 50
            color: "transparent"
            radius: 10
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            TextField {
                id: username
                width: parent.width * .95
                height: parent.height * .8
                anchors {
                    centerIn: parent
                }
                font.pointSize: 14
                color: "white"
                placeholderText: "User Name / email"
                placeholderTextColor: "lightGray"
                background: Rectangle {
                    width: parent.width
                    height: 2
                    color: "green"
                    anchors.bottom: parent.bottom
                }
                font.family: "UTM Avo"
            }
        }

        Rectangle {
            id: passwordRect
            width: parent.width
            height: usernamRect.height
            color: "transparent"
            radius: 10

            anchors
            {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 10
            }
            TextField {
                id: password
                width: parent.width * .95
                height: parent.height * .8
                anchors {
                    centerIn: parent
                }
                font.pointSize: 14
                color: "white"
                placeholderText: "Password"
                placeholderTextColor: "lightGray"
                background: Rectangle {
                    width: parent.width
                    height: 2
                    color: "green"
                    anchors.bottom: parent.bottom
                }
                echoMode: TextInput.Password
                font.family: "UTM Avo"
            }
        }

        Button {
            id: loginButton
            width: parent.width
            height: 50
            anchors{
                top: inputArea.bottom
                topMargin: 10
                horizontalCenter: inputArea.horizontalCenter
            }
            background: Rectangle {
                width: parent.width
                height: parent.height
                color: loginButton.hovered ? "grey" : "green"
                border.width: loginButton.down ? 3 : 0
                radius: 10
            }
            contentItem: Text {
                text: "Login"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 22
                color: loginButton.hovered ? "aqua" : "white"
                font.family: "UTM Avo"
            }
            onClicked: {
                print(username.text)
                print(password.text)
                _authHandler.login(username.text, password.text)
            }
        }
    }
}
