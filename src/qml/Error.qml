import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3
import "BComStyles.js" as BComStyles

Rectangle {
    id:errorRootWidget
    //width:1920
    //height:1080
    color: BComStyles.darkGrey

    BComMenuBar {
        id: menuBar
        productTitle: "*" + appTitle + "*"
        currentTitle: "/ Error"
        helpEnabled: false
        paramEnabled: false
        closeEnabled: true
        contactsEnabled: false
        modulesEnabled: false
    }

    Rectangle {
        id:errorWidgetRect
        anchors.left: parent.left
        anchors.leftMargin: BComStyles.rightMargin
        anchors.right: parent.right
        anchors.rightMargin: BComStyles.rightMargin
        anchors.top:menuBar.bottom
        anchors.topMargin: BComStyles.rightMargin
        anchors.bottom: parent.bottom
        color:"black"

        // default Visibility
        BComTextStyle1 {
            id: errorLabel
            anchors.left: parent.left
            anchors.leftMargin: BComStyles.rightMargin
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            visible:true
            wrapMode: Text.WordWrap

            Component.onCompleted: {
                switch (rootWidget.errorType) {
                    case "SERVICE":
                    default :
                        text = "Application can't access "+ appTitle +" service\n\nPlease check your network or parameters and retry\n\nOr contact "+ appTitle +" support : "
                        break;
                }
            }
        }

        Button {
            id:helpSupportEmailBlock
            anchors.top : errorLabel.bottom
            anchors.topMargin : BComStyles.rightMargin
            anchors.left : parent.left
            anchors.leftMargin: BComStyles.rightMargin
            width:helpSupportEmailText.width + BComStyles.rightMargin
            height:25
            z:1

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
    }


}
