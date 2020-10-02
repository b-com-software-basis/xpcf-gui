import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

Rectangle {
    id: root
    Layout.alignment: Qt.AlignTop
    Layout.fillWidth: true
    color: "transparent"
    height:40
    property alias currentTitle : currentTitleText.text
    property alias productTitle : producttext.text
    property int currentIndex
    property BComButton previousButton


    function toggleSelected(button,index) {
        if (button !== previousButton) {
            root.currentIndex = index
            button.enabled = false
            previousButton.enabled = true
            previousButton = button
            currentTitle = "/" + button.text
        }
    }
    Rectangle {
        id:bcombloc
        color: "black"
        height: parent.height
        anchors {
            top: parent.top
              bottom: parent.bottom
              left: parent.left
              right: tabButtonsLayout.left
              rightMargin: BComStyles.rightMargin
        }
        width: 450

        Image {
            id:bcomtext
            anchors {
                top: parent.top
                    topMargin: 7
                    left: parent.left
                    leftMargin: 24
            }
            source:"images/bcomtext.png"
            objectName: "bcomtext"
            width:59
            height:17
        }
        BComTextStyle3 {
            id:producttext
            anchors {
                top: parent.top
                topMargin: 11
                left: bcomtext.right
                leftMargin: BComStyles.leftTextMargin
            }

            color: BComStyles.blue
            text: ""
            x:100 ; y:11
            width:200
            height:14
        }

    }
    BComTextStyle3 {
        id:currentTitleText
      /*  anchors {
            right: bcombloc.right
            top: parent.top
            topMargin: 11
            bottom: parent.bottom
            leftMargin: 2
        }*/
        color: BComStyles.white
        text: ""
        x:100 ; y:11
        width:150
        height:14
    }

    RowLayout {
        id: tabButtonsLayout
        height: parent.height
        spacing: 0
        anchors {
            right: configButtonsLayout.left
            rightMargin: 2
        }
        BComButton {
            id:homeButton
            height: 40
            enabled:false
            width:90
            buttonColor : "purple"
            text:"Home"
            onClicked: {
                toggleSelected(homeButton,0)
            }
            tooltip: "select and display modules"
        }
    BComButton {
        id:modulesButton
        height: 40
        enabled:true
        width:90
        buttonColor : "blue"
        text:"Modules"
        onClicked: {
            toggleSelected(modulesButton,1)
        }
        tooltip: "select and display modules"
    }
    BComButton {
        id:componentsButton
        enabled:true
        height: tabButtonsLayout.height
        width:130
        buttonColor : "green"
        text:"Components"
        onClicked: {
            toggleSelected(componentsButton,2)
        }
        tooltip: "display module components"
    }
    BComButton {
        id:interfacesButton
        enabled:true
        height: tabButtonsLayout.height
       // width:130
        buttonColor : "yellow"
        text:"Interfaces"
        onClicked: {
            toggleSelected(interfacesButton,3)
        }
        tooltip: "display interfaces"
    }
    BComButton {
        id:configuratorButton
        enabled:true
        height: tabButtonsLayout.height
        width:130
        buttonColor : "blue"
        text:"Configurator"
        onClicked: {
            toggleSelected(configuratorButton,4)
        }
        tooltip: "display configurator"
    }
    }

    RowLayout {
        id: configButtonsLayout
        height: parent.height
        spacing: 2
        anchors {
            right: parent.right
        }
    BComButton {
        id:helpButton
        enabled:true
        height: configButtonsLayout.height
        width:110
        buttonColor : "green"
        text:"[?] help"
        onClicked: {
            help.visible=true
        }
    }
    BComPictButton {
        id: paramButton
        enabled:true
        height: configButtonsLayout.height
        width:150
        buttonColor : "yellow"
        text:"parameters"
        imagepicto: "images/parameterspictoenabled.png"
        onClicked: {
            toggleSelected(paramButton,5)

        }
    }
    BComPictButton {
        id: closeButton
        enabled:true
        height: configButtonsLayout.height
        Layout.alignment: Qt.AlignRight
        width:100
        buttonColor : "red"
        text:"Quit"
        imagepicto: "images/closepictoenabled.png"
        onClicked: {
            Qt.quit();
        }
    }
    }

    Component.onCompleted: {
        currentIndex = 0
        previousButton = homeButton
    }
}
