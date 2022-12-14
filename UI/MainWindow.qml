import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

import "components"

Window {
    id: mainWindow
    width: 600
    height: 680
    minimumWidth: 800
    minimumHeight: 680
    visible: true
    color: "#00000000"
    title: "HCL Training Community Application v1.0.0"
    // Remove title bar
    flags: Qt.WindowStaysOnTopHint | Qt.Window | Qt.FramelessWindowHint
    // Propeties
    property int windowStatus: 0
    property int windowMargin: 10

    property bool currentLeftButton: true

    // Internal functions
    QtObject{
        id: internal

        function resetResizeBorders(){
            // Resize visibility
            resizeLeft.visible = true
            resizeRight.visible = true
            resizeBottom.visible = true
            resizeWindow.visible = true
        }

        function maximizeRestore(){
            if(windowStatus == 0){
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                // Resize visibility
                resizeLeft.visible = false
                resizeRight.visible = false
                resizeBottom.visible = false
                resizeWindow.visible = false
                btnMaximizeRestore.btnIconSource = "qrc:/UI/assets/images/cil-fullscreen-exit.png"
            }
            else{
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                btnMaximizeRestore.btnIconSource = "qrc:/UI/assets/images/cil-fullscreen.png"
            }
        }

        function ifMaximizedWindowRestore(){
            if(windowStatus == 1){
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                btnMaximizeRestore.btnIconSource = "qrc:/UI/assets/images/cil-fullscreen.png"
            }
        }

        function restoreMargins(){
            windowStatus = 0
            windowMargin = 10
            // Resize visibility
            internal.resetResizeBorders()
            btnMaximizeRestore.btnIconSource = "qrc:/UI/assets/images/cil-fullscreen.png"
        }
    }



    Rectangle {
        id: bg
        color: "#2c313c"
        border.color: "#383e4c"
        border.width: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin
        z: 1

        Rectangle {
            id: appContainer
            color: "#00000000"
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1

            Rectangle {
                id: topBar
                height: 60
                color: "#1c1d20"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                ToggleButton {
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    clip: true
                    onClicked: animationMenu.running = true
                }

                Rectangle {
                    id: titleBar
                    height: 35
                    color: "#00000000"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 105
                    anchors.leftMargin: 70
                    anchors.topMargin: 0

                    DragHandler {
                        onActiveChanged: if(active){
                                             mainWindow.startSystemMove()
                                             internal.ifMaximizedWindowRestore()
                                         }
                    }

                    Image {
                        id: iconApp
                        width: 22
                        height: 22
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "qrc:/UI/assets/images/cil-terminal.png"
                        autoTransform: true
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 5
                        anchors.topMargin: 0
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: label
                        color: "#c3cbdd"
                        text: mainWindow.title
                        anchors.left: iconApp.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 10
                        anchors.leftMargin: 5
                    }
                }

                Row {
                    id: rowBtns
                    x: 872
                    width: 105
                    height: 35
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.rightMargin: 0

                    TopBarButton{
                        id: btnMinimize
                        display: AbstractButton.IconOnly
                        onClicked: {
                            mainWindow.showMinimized()
                            internal.restoreMargins()
                        }
                    }

                    TopBarButton {
                        id: btnMaximizeRestore
                        display: AbstractButton.IconOnly
                        btnIconSource: "qrc:/UI/assets/images/cil-fullscreen.png"
                        onClicked: internal.maximizeRestore()
                    }

                    TopBarButton {
                        id: btnClose
                        btnColorMouseOver: "#f21c3b"
                        btnColorClicked: "#ff0000"
                        btnIconSource: "qrc:/UI/assets/images/cil-x.png"
                        onClicked: window.close()
                    }
                }

                Rectangle {
                    id: topBarDescription
                    y: 28
                    height: 25
                    color: "#282c34"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 70
                    anchors.bottomMargin: 0

                    Label {
                        id: labelTopInfo
                        color: "#5f6a82"
                        text: qsTr("Application description")
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.rightMargin: 300
                        anchors.topMargin: 0
                        anchors.leftMargin: 10
                    }

                    Label {
                        id: labelRightInfo
                        color: "#5f6a82"
                        text: qsTr("| HOME")
                        anchors.left: labelTopInfo.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        anchors.topMargin: 0
                        anchors.rightMargin: 10
                        anchors.leftMargin: 0
                        anchors.bottomMargin: 0
                    }
                }


            }

            Rectangle {
                id: content
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: topBar.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 0

                Rectangle {
                    id: leftMenu
                    width: 70
                    color: "#1c1d20"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    clip: true
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0

                    PropertyAnimation{
                        id: animationMenu
                        target: leftMenu
                        property: "width"
                        to: if(leftMenu.width == 70) return 250; else return 70
                        duration: 500
                        easing.type: Easing.InOutQuint
                    }

                    Column {
                        id: columnMenus
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        clip: true
                        anchors.rightMargin: 0
                        anchors.leftMargin: 0
                        anchors.bottomMargin: 90
                        anchors.topMargin: 0

                        LeftMenuBtn {
                            id: btnHome
                            width: leftMenu.width
                            text: qsTr("Home")
                            isActiveMenu: true
                            onClicked: {
                                btnHome.isActiveMenu = currentLeftButton
                                btnOpen.isActiveMenu = false
                                btnSave.isActiveMenu = false
                                btnSettings.isActiveMenu = false
                                contentLoader.source = ""
                                contentLoader.source = "qrc:/UI/pages/HomePage.qml"
                            }
                        }

                        LeftMenuBtn {
                            id: btnOpen
                            width: leftMenu.width
                            text: qsTr("Explore")
                            btnIconSource: "qrc:/UI/assets/images/cil-folder-open.png"

                            onClicked: {
                                btnHome.isActiveMenu = false
                                btnOpen.isActiveMenu = currentLeftButton
                                btnSave.isActiveMenu = false
                                btnSettings.isActiveMenu = false
                                contentLoader.source = ""
                                contentLoader.source = "qrc:/UI/pages/ExplorePage.qml"
                            }

                        }

                        LeftMenuBtn {
                            id: btnSave
                            width: leftMenu.width
                            text: qsTr("Message")
                            btnIconSource: "qrc:/UI/assets/images/cil-save.png"

                            onClicked: {
                                btnHome.isActiveMenu = false
                                btnOpen.isActiveMenu = false
                                btnSave.isActiveMenu = currentLeftButton
                                btnSettings.isActiveMenu = false
                                contentLoader.source = ""
                                contentLoader.source = "qrc:/UI/pages/ChatPage.qml"
                            }
                        }
                    }

                    LeftMenuBtn {
                        id: btnSettings
                        width: leftMenu.width
                        text: qsTr("Settings")
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 25
                        btnIconSource: "qrc:/UI/assets/images/cil-settings.png"
                        onClicked: {
                            btnHome.isActiveMenu = false
                            btnOpen.isActiveMenu = false
                            btnSave.isActiveMenu = false
                            btnSettings.isActiveMenu = currentLeftButton
                            contentLoader.source = ""
                            contentLoader.source = "qrc:/UI/pages/SettingPage.qml"
                        }
                    }
                }

                Rectangle {
                    id: contentPages
                    color: "transparent"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    clip: true
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 25
                    anchors.topMargin: 0

                    Loader {
                        id: contentLoader
                        anchors.fill: parent
                        source: "qrc:/UI/pages/HomePage.qml"
                        clip: true
                        layer.smooth: true
                        antialiasing: true
                    }
                }

                Rectangle {
                    id: statusBar
                    color: "#282c34"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: contentPages.bottom
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0

                    Label {
                        id: statusText
                        color: "#5f6a82"
                        text: qsTr("Application description")
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        anchors.topMargin: 0
                        anchors.rightMargin: 30
                        anchors.leftMargin: 10
                        anchors.bottomMargin: 0
                    }

                    MouseArea {
                        id: resizeWindow
                        x: 884
                        y: 0
                        width: 25
                        height: 25
                        opacity: 0.5
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.rightMargin: 0
                        cursorShape: Qt.SizeFDiagCursor

                        DragHandler{
                            target: null
                            onActiveChanged: if (active){
                                                 mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                                             }
                        }

                        Image {
                            id: resizeImage
                            width: 16
                            height: 16
                            anchors.fill: parent
                            source: "qrc:/UI/assets/images/back.png"
                            anchors.leftMargin: 5
                            anchors.topMargin: 5
                            sourceSize.height: 16
                            sourceSize.width: 16
                            fillMode: Image.PreserveAspectFit
                            antialiasing: false
                        }
                    }
                }
            }
        }
    }


    DropShadow{
        anchors.fill: bg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        color: "#80000000"
        source: bg
        layer.enabled: true
        layer.samples: 16
        z: 0
    }

    MouseArea {
        id: resizeLeft
        width: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor

        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.LeftEdge) }
        }
    }

    MouseArea {
        id: resizeRight
        width: 10
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor

        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.RightEdge) }
        }
    }

    MouseArea {
        id: resizeBottom
        height: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 0
        cursorShape: Qt.SizeVerCursor

        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.BottomEdge) }
        }
    }

//    Connections{
//        target: backend

//        function onReadText(text){
//            actualPage.setText = text
//        }
//    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5;height:680;width:1080}
}
##^##*/
