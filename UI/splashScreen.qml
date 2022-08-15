import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Timeline 1.0
import QtQml
import "components"

Window {
    id: splashScreen
    width: 380
    height: 580
    visible: true
    color: "#00000000"

    // Remove Title Bar
    flags: Qt.WindowStaysOnTopHint | Qt.SplashScreen | Qt.FramelessWindowHint

    // Internal Functions
    QtObject{
        id: internal

        function checkLogin(username, password){
            _authHandler.login(username, password);
        }

        function getStatusCode() {
            var code = _authHandler.getResponeCode();
            return code;
        }
        function openPopup( msg: string ) {
            popup.msg = msg
            popup.visible = true
        }
    }


    // Properties
    property int timeInterval: 1500

    Timer {
        id: timer
        interval: timeInterval
        repeat: false
        onTriggered: {
            var component = Qt.createComponent("qrc:/UI/main.qml")
            var win = component.createObject()
            win.show()
            visible = false
        }
    }


    Rectangle {
        id: bg
        color: "#151515"
        width: parent.width - 20
        height: parent.height - 20
        radius: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        z: 1

        CustomButton {
            id: btnClose
            x: 20
            width: 30
            height: 30
            opacity: 1
            text: "X"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.rightMargin: 15
            colorPressed: "#558b1f"
            colorMouseOver: "#7ece2d"
            colorDefault: "#2aafd3"
            font.family: "Segoe UI"
            font.pointSize: 10
            onClicked: splashScreen.close()
        }

        CircularProgressBar {
            id: circularProgressBar
            x: 55
            y: 198
            opacity: 0
            anchors.verticalCenter: parent.verticalCenter
            value: 100
            progressWidth: 8
            strokeBgWidth: 4
            progressColor: "#2aafd3"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: logoImage
            width: 360
            height: 120
            anchors{
                top: parent.top
                topMargin: 80
                horizontalCenter: parent.horizontalCenter
            }
            source: "qrc:/UI/assets/images/hcl_logo.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            antialiasing: true
        }

        Label {
            id: labelAppTitle
            x: 100
            y: 294
            opacity: 1
            color: "#ffffff"
            text: qsTr("HCL Training Comunity")
            anchors.bottom: labelSubTitle.top
            anchors.bottomMargin: 10
            font.family: "Segoe UI"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: labelSubTitle
            x: 55
            y: 330
            opacity: 1
            color: "#ffffff"
            text: qsTr("Welcome to our training comunity")
            anchors.bottom: textUsername.top
            anchors.bottomMargin: 20
            anchors.horizontalCenterOffset: 0
            font.family: "Segoe UI"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 10
        }

        CustomTextField {
            id: textUsername
            width: btnLogin.width
            height: 40

            anchors {
                bottom: textPassword.top
                bottomMargin: 10
                horizontalCenter: textPassword.horizontalCenter
            }
            placeholderText: "Username or email"
            placeholderTextColor: "gray"
            font.family: "Segoe UI"
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: "test@gmail.com"
        }

        CustomTextField {
            id: textPassword
            opacity: 1
            width: btnLogin.width
            height: 40

            anchors {
                bottom: btnLogin.top
                bottomMargin: 10
                horizontalCenter: btnLogin.horizontalCenter
            }
            placeholderText: "Password"
            placeholderTextColor: "gray"

            echoMode: TextInput.Password
            font.family: "Segoe UI"
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: "password123"
            onAccepted: btnLogin.clicked()
        }

        CustomButton {
            signal isDone
            id: btnLogin
            x: 30
            y: 469
            width: 300
            height: 40
            opacity: 1
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            text: "Sign In"
            font.family: "Segeo UI"
            font.pointSize: 10
            colorPressed: "#1f8b84"
            colorMouseOver: "#3cdabf"
            colorDefault: "#2aafd3"
            onClicked: {
                timer.start();
//                                internal.checkLogin(textUsername.text, textPassword.text)
            }
        }

        Connections {
            target: _authHandler

            function onSignedInSuccess() {
                timer.start();
            }
            function onSignInError() {
                internal.openPopup(internal.getStatusCode());
            }
        }

    }

    ModalPopup {
        id: popup
        width: 320
        height: 150
        visible: false
        anchors.centerIn: bg
        z: 1
    }

    DropShadow{
        anchors.fill: bg
        source: bg
        verticalOffset: 0
        horizontalOffset: 0
        radius: 10
        color: "#40000000"
        z: 0
    }

    DropShadow{
        anchors.fill: popup
        source: popup
        verticalOffset: 0
        horizontalOffset: 0
        radius: 10
        color: "#40000000"
        z: 0
    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                duration: 3000
                running: true
                loops: 1
                to: 3000
                from: 0
            }
        ]
        enabled: true
        startFrame: 0
        endFrame: 3000

        KeyframeGroup {
            target: circularProgressBar
            property: "value"
            Keyframe {
                frame: 0
                value: 0
            }

            Keyframe {
                frame: 1300
                value: 100
            }
        }

        KeyframeGroup {
            target: circularProgressBar
            property: "opacity"
            Keyframe {
                frame: 1301
                value: 1
            }

            Keyframe {
                frame: 1800
                value: 0
            }

            Keyframe {
                frame: 0
                value: 1
            }
        }

        KeyframeGroup {
            target: logoImage
            property: "opacity"
            Keyframe {
                frame: 1801
                value: 0
            }

            Keyframe {
                frame: 2300
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: labelAppTitle
            property: "opacity"
            Keyframe {
                frame: 1899
                value: 0
            }

            Keyframe {
                frame: 2396
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: labelSubTitle
            property: "opacity"
            Keyframe {
                frame: 1996
                value: 0
            }

            Keyframe {
                frame: 2504
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: textUsername
            property: "opacity"
            Keyframe {
                frame: 2097
                value: 0
            }

            Keyframe {
                frame: 2652
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: textPassword
            property: "opacity"
            Keyframe {
                frame: 2198
                value: 0
            }

            Keyframe {
                frame: 2796
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: btnLogin
            property: "opacity"
            Keyframe {
                frame: 2298
                value: 0
            }

            Keyframe {
                frame: 2951
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: bg
            property: "height"
            Keyframe {
                frame: 1301
                value: 360
            }

            Keyframe {
                easing.bezierCurve: [0.221,-0.00103,0.222,0.997,1,1]
                frame: 1899
                value: 560
            }

            Keyframe {
                frame: 0
                value: 360
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
