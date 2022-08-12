import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Window {
    id: window
    width: 1080
    height: 680
    minimumWidth: 380
    minimumHeight: 680
    visible: true
    visibility: Window.Maximized
    color: "transparent"
    title: "HCL Training Community Application v1.0.0"

    Component.onCompleted: {
        flags: ~Qt.SplashScreen | ~Qt.FramelessWindowHint
        flags: Qt.Window | Qt.WindowStaysOnTopHint
    }

    Loader{
        id: mainLoader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors{
            margins: 10
        }
        source: "./MainWindow.qml"
        clip: true
        layer.smooth: true
        antialiasing: true
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10

        function reload(){
            mainLoader.source = "";
            QmlEngine.clearCache();
            mainLoader.source = "./MainWindow.qml"
        }
    }

    Connections{
        target: QmlEngine

        function onReloadUI(){
            console.log("Reloading UI");
            mainLoader.reload();
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
