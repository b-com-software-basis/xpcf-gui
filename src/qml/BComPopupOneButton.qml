import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.2
import "BComStyles.js" as BComStyles

Dialog {
    id: root

    title : appTitle

    property alias titleText:titleText.text
    property alias popupText:popupText.text
    property alias buttonText:buttonText.text
    property alias displaySupportEmail:helpSupportEmailBlock.visible

    signal buttonClicked

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
            color:BComStyles.red
        }

        BComTextBlock {
            id:popupArea
            bPictoBefore: false
            bCenterText: false
            anchors.top: titleArea.bottom
            anchors.topMargin: BComStyles.horizontalCellSpacing
            anchors.bottom: helpSupportEmailBlock.visible ? helpSupportEmailBlock.top : buttonBar.top
            anchors.bottomMargin: BComStyles.horizontalCellSpacing
            anchors.left:parent.left
            anchors.right: parent.right
            labelVerticalCentered: false
            color: BComStyles.black
            BComTextStyle2 {
                id:popupText
                anchors.verticalCenter:  parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                wrapMode: Text.Wrap
                width: parent.width
                text:"popup text"
            }
        }

        Button {
            id:helpSupportEmailBlock
            anchors.bottom : buttonBar.top
            anchors.bottomMargin : BComStyles.rightMargin*2
            anchors.left : parent.left
            anchors.leftMargin: 20
            width:helpSupportEmailText.width + BComStyles.rightMargin
            height:25
            z:1
            visible : false

            Text {
                id: helpSupportEmailText
                text:  "support_xpcf@b-com.com"
                font.family: "Bcom"
                color :"black"
                font.pixelSize: 18
                anchors.centerIn: parent
            }

            onClicked:
                Qt.openUrlExternally("mailto:support_xpcf@b-com.com ");
            style: ButtonStyle {

                background: Rectangle {
                   color: "white"
                }
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
                id:button
                enabled:true
                bPictoBefore: false
                bCenterText: true
                anchors.top:parent.top
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.verticalCellSpacing
                anchors.bottom: parent.bottom
                width:(parent.width-2*BComStyles.verticalCellSpacing)
                BComTextStyle9 {
                    id : buttonText
                    text: "button"
                    anchors.centerIn: parent
                    }

                onClicked: {
                    root.buttonClicked()
                }
            }
        }
    }
    // Focus on button by default
    onVisibleChanged: {
        if(visible === true){
            button.focus = true;
        }
    }
}
