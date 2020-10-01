import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3
import "BComStyles.js" as BComStyles

Dialog {
    id: root

    title : rootWindow.title

    property alias titleText:titleText.text
    //property alias componentUuid:componentUuid.text
    property alias popupText:popupText.text
    property alias button1Text:button1Text.text
    property alias button2Text:button2Text.text
    property alias button3Text:button3Text.text

    signal button1Clicked
    signal button2Clicked
    signal button3Clicked

    contentItem: Rectangle {
        color: "black"
        implicitWidth: 688
        implicitHeight: 512


        BComTextBlock {
            id:titleArea
            bPictoBefore: false
            bCenterText: false
            anchors.top: parent.top
            anchors.left:parent.left
            anchors.right: parent.right
            height:60
            BComTextStyle2 {
                id:titleText
                text:"warning"
                anchors.verticalCenter:  parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            color:BComStyles.blue
        }

        //  Text {
        //    id:componentUuid
        //visible: false
        //   }

        BComTextBlock {
            id:popupArea
            bPictoBefore: false
            bCenterText: false
            anchors.top: titleArea.bottom
            anchors.topMargin: BComStyles.horizontalCellSpacing
            anchors.bottomMargin: BComStyles.horizontalCellSpacing
            anchors.left:parent.left
            anchors.right: parent.right
            labelVerticalCentered: false
            color: BComStyles.black
            BComTextStyle2 {
                id:popupText
                anchors.top: parent.top
                anchors.verticalCenter:  parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                text:"You did not save your results.\n\nDo you want to save results ?"
            }
        }
        Rectangle {
            id: paramListRect
            anchors.top:popupArea.bottom
            anchors.topMargin: BComStyles.rightMargin
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: BComStyles.rightMargin
            anchors.bottom:buttonBar.top
            anchors.bottomMargin: BComStyles.rightMargin
            //height:componentListStatus.height
            color : BComStyles.darkGrey

            Component {
                id: paramListDelegate
                Item {
                    id : paramItemRect
                    //property alias name: componentItemText.text // added this property alias to access the text of the current list item
                    width: parameterValuesList.width-parameterListScrollBar.width;
                    height: 30
                    BComTextStyle3 {
                        id: paramItemText
                        text: "1"
                        color: BComStyles.white
                        anchors.left : parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5
                        font.weight: Font.Light
                    }
                    MouseArea {
                        id: mouseRegion
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            //parameterValuesList.currentIndex = index
                        }
                    }
                }
            }

            ListView {
                id:parameterValuesList
                anchors.top: parent.top
                anchors.topMargin: BComStyles.horizontalCellSpacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: BComStyles.horizontalCellSpacing
                anchors.left:parent.left
                anchors.right: parent.right
                model:parameterValuesModel
                delegate: paramListDelegate
                height:50
                visible: true
                highlight:
                    Rectangle {
                    color: BComStyles.lightGrey
                }
            }
            Scrollbar {
                id : parameterListScrollBar
                flickable: parameterValuesList
            }
        }

        Rectangle {
            id: buttonBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height:90
            color:"transparent"

            BComButton {
                id:button1
                enabled:true
                anchors.top:parent.top
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.verticalCellSpacing
                anchors.bottom: parent.bottom
                width:(parent.width-2*BComStyles.verticalCellSpacing)/3
                BComTextStyle9 {
                    id : button1Text
                    text: "button1"
                    anchors.centerIn: parent
                }

                onClicked: {
                    root.button1Clicked()
                }
            }
            BComButton {
                id:button2
                enabled:true
                anchors.top:parent.top
                anchors.bottom: parent.bottom
                anchors.left: button1.right
                anchors.leftMargin: BComStyles.verticalCellSpacing
                width:(parent.width-2*BComStyles.verticalCellSpacing)/3
                BComTextStyle9 {
                    id : button2Text
                    text:"button2"
                    anchors.centerIn: parent
                }
                onClicked: {
                    root.button2Clicked()
                }
            }

            BComButton {
                id:button3
                enabled:true
                anchors.top:parent.top
                anchors.bottom: parent.bottom
                anchors.left: button2.right
                anchors.leftMargin: BComStyles.verticalCellSpacing
                anchors.right: parent.right
                anchors.rightMargin: BComStyles.verticalCellSpacing
                BComTextStyle9 {
                    id : button3Text
                    text:"button3"
                    anchors.centerIn: parent
                }
                onClicked: {
                    root.button3Clicked()
                }
            }
        }
    }
    // Focus on button by default
//    onVisibleChanged: {
//        if(visible === true){
//            button1.focus = true;
//        }
//    }
}
