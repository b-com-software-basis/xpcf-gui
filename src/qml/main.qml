import QtQuick 2.3
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0

Rectangle {
    id: rootWidget
    objectName: "rootWidget"

    function displayPopup(title, popuptext,displaySupportEmail,authExpired) {
        popupInfo.titleText = title
        popupInfo.popupText = popuptext
        popupInfo.visible = true
        popupInfo.displaySupportEmail = displaySupportEmail
    }

    function displayHomeState () {
        rootWidget.state = "modules"
    }


    visible:true
    property alias state: screen_loader.state
    property string parametersPreviousState: ""
    property string pictureRightsPreviousState: ""
    property string pictureSource:""
    property var emailRegExp: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
    property bool displayModules : true
    property bool logoutError : false
    // SLETODO : need to be change with error code
    property string errorType : "SERVICE"

    FontLoader { id: bcombold; source: "fonts/Bcom-SemiBold.otf" }
    FontLoader { id: bcom; source: "fonts/Bcom-Light.otf" }


    BusyIndicator {
        running: screen_loader.status === Loader.Loading
    }
    Loader {
        id: screen_loader
        objectName: "screen_loader"
        source: "Modules.qml"
        anchors.fill: parent

        states: [
            State {
                name: "modules"
                PropertyChanges { target: screen_loader; source: "Modules.qml" }
            },
            State {
                name: "components"
                PropertyChanges { target: screen_loader; source: "Components.qml" }
            },
            State {
                name: "interfaces"
                PropertyChanges { target: screen_loader; source: "Interfaces.qml" }
            },
            State {
                name: "configurator"
                PropertyChanges { target: screen_loader; source: "Configurator.qml" }
            },
            State {
                name: "parameters"
                PropertyChanges { target: screen_loader; source: "Parameters.qml" }
            },
            State {
                name: "error"
                PropertyChanges { target: screen_loader; source: "Error.qml" }
            }

        ]

        onLoaded: {
            console.log("[screen_loader] state loaded : " + screen_loader.state)
            if (screen_loader.state === "help") {
                var scene = screen_loader.item
                if (scene) {
                    scene.parent = rootWidget
                    scene.anchors.fill = rootWidget
                }
            }
        }

        onStateChanged: {
            console.log("[Main][screen_loader] state changed : " + screen_loader.state)
            console.log("[Main][screen_loader] parameters previous state changed : " + parametersPreviousState)
        }
    }


    Component.onCompleted: {
            displayHomeState()
    }

    BComPopupOneButton {
        id:popupInfo
        buttonText: "ok"

        onButtonClicked: {
            popupInfo.visible = false;
        }
    }
}
