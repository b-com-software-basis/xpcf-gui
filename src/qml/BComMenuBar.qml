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
    property bool displayHelp
    property var previousButton


    function toggleSelected(button,index) {
        if (button !== previousButton) {
            root.currentIndex = index
            button.enabled = false
            previousButton.enabled = true
            previousButton = button
            currentTitle = "/ " + button.text
        }
    }

    function helpSelected() {
        displayHelp=true
    }

    Rectangle {
        id:bcombloc
        color: "black"
        height: parent.height
        anchors {
              top: parent.top
              bottom: parent.bottom
              left: parent.left
        }
        width: 348

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

    Rectangle {
        id:titlebloc
        color: "black"
        height: parent.height
        anchors {
              top: parent.top
              leftMargin: 2
              bottom: parent.bottom
              left: bcombloc.right
              right:tabButtonsBloc.left
        }
        //width : 150

        BComTextStyle3 {
            id:currentTitleText
            anchors {
                left: parent.left
                leftMargin: 13
                top: parent.top
                topMargin: 11
                bottom: parent.bottom
            }
            color: BComStyles.white
            text: ""
            x:100 ; y:11
            height:14
        }
    }

    Rectangle {
        id: tabButtonsBloc
        color: "black"
        height: parent.height
        width: tabButtonsLayout.width
        anchors {
              top: parent.top
              bottom: parent.bottom
              right: configButtonsBloc.left
        }
        RowLayout {
            id: tabButtonsLayout
            height: parent.height
            spacing: 0
            anchors {
                right: parent.right
                rightMargin: 2
            }

            BComButton {
                id:homeButton
                height: 40
                enabled:false
                Layout.fillWidth: true
                Layout.preferredWidth: 90
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
                Layout.fillWidth: true
                Layout.preferredWidth: 90
                buttonColor : "purple"
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
                Layout.fillWidth: true
                Layout.preferredWidth: 130
                buttonColor : "blue"
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
                Layout.fillWidth: true
                Layout.preferredWidth: 130
                buttonColor : "green"
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
                Layout.fillWidth: true
                Layout.preferredWidth: 130
                buttonColor : "yellow"
                text:"Configurator"
                onClicked: {
                    toggleSelected(configuratorButton,4)
                }
                tooltip: "display configurator"
            }
        }
    }

    Rectangle {
        id: configButtonsBloc
        color: "black"
        height: parent.height
        width: configButtonsLayout.width
        anchors {
              top: parent.top
              bottom: parent.bottom
              right: parent.right
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
                Layout.fillWidth: true
                Layout.preferredWidth: 110
                buttonColor : "green"
                text:"[?] help"
                onClicked: {
                    helpSelected()
                }
            }
            BComPictButton {
                id: paramButton
                enabled:true
                height: configButtonsLayout.height
                Layout.fillWidth: true
                Layout.preferredWidth: 150
                buttonColor : "yellow"
                buttonText:"parameters"
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
                Layout.fillWidth: true
                Layout.preferredWidth:100
                buttonColor : "red"
                buttonText:"Quit"
                imagepicto: "images/closepictoenabled.png"
                onClicked: {
                    Qt.quit();
                }
            }
        }
    }

    Component.onCompleted: {
        currentIndex = 0
        previousButton = homeButton
        displayHelp = false
    }
}
