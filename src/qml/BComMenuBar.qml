import QtQuick 2.3
import QtQuick.Controls 1.4
import "BComStyles.js" as BComStyles

Rectangle {
    id: root
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    property alias currentTitle : currentTitleText.text
    property alias productTitle : producttext.text
    property alias helpEnabled : helpButton.enabled
    property alias paramEnabled : paramButton.enabled
    property alias closeEnabled : closeButton.enabled
    property alias configuratorEnabled : configuratorButton.enabled
    property alias interfacesEnabled : interfacesButton.enabled
    property alias componentsEnabled : componentsButton.enabled
    property alias modulesEnabled : modulesButton.enabled

    color:"transparent"
    height:40
    Rectangle {
        id:bcombloc
        color: "black"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width:348
    }
    Image {
        source:"images/bcomtext.png"
        id:bcomtext
        objectName: "bcomtext"
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.left: parent.left
        anchors.leftMargin: 24
        width:59
        height:17
    }
    BComTextStyle3 {
        id:producttext
        anchors.top: parent.top
        anchors.topMargin: 11
        anchors.left: bcomtext.right
        anchors.leftMargin: BComStyles.leftTextMargin
        color: BComStyles.blue
        text: ""
        x:100 ; y:11
        width:200
        height:14
    }
    BComTextBlock {
        id:currentTitleText
        enabled:true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: bcombloc.right
        anchors.leftMargin: 2
        anchors.right: helpButton.left
        anchors.rightMargin: 2
        color:BComStyles.black
        bPictoBefore: false
        text:""
    }
    BComButton {
        id: closeButton
        enabled:true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width:100
        buttonColor : "red"
        text:"Quit"
        imagepicto: "images/closepictoenabled.png"
        onClicked: {
                 Qt.quit();
        }
    }
    BComButton {
        id: paramButton
        enabled:true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: closeButton.left
        anchors.rightMargin: 2
        width:150
        buttonColor : "yellow"
        text:"parameters"
        imagepicto: "images/parameterspictoenabled.png"
        onClicked: {
            rootWidget.parametersPreviousState = rootWidget.state
            rootWidget.state="parameters"
        }
    }
    BComButton {
        id:helpButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: paramButton.left
        anchors.rightMargin: 2
        width:110
        buttonColor : "green"
        text:"[?] help"
        onClicked: {
            help.visible=true
        }
    }
    BComButton {
        id:configuratorButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: helpButton.left
        anchors.rightMargin: 2
        width:130
        buttonColor : "yellow"
        text:"Configurator"
        onClicked: {
            rootWidget.state="configurator"
        }
        tooltip: "display configurator"
    }
    BComButton {
        id:interfacesButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: configuratorButton.left
        anchors.rightMargin: 2
        width:130
        buttonColor : "green"
        text:"Interfaces"
        onClicked: {
            rootWidget.state="interfaces"
        }
        tooltip: "display interfaces"
    }
    BComButton {
        id:componentsButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: interfacesButton.left
        anchors.rightMargin: 2
        width:130
        buttonColor : "blue"
        text:"Components"
        onClicked: {
            rootWidget.state="components"
        }
        tooltip: "display module components"
    }
    BComButton {
        id:modulesButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: componentsButton.left
        anchors.rightMargin: 2
        width:90
        buttonColor : "purple"
        text:"Modules"
        onClicked: {
            rootWidget.state="modules"
        }
        tooltip: "select and display modules"
    }
}
