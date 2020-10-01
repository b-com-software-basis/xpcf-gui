import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import "BComStyles.js" as BComStyles

Rectangle {

    id:helpoverlaybloc_75
    opacity: 0.72
    x:0 ; y:0
    width:parent.width
    height:parent.height
    visible:true
    color:"black"

    // internal properties
    property int pictoSize : 44
    property int textWidth : 497
    property int textHeight : 105

    // Texts and positions
    property alias bHelp1Visible : helpArea1.visible
    property alias bHelp2Visible : helpArea2.visible
    property alias bHelp3Visible : helpArea3.visible
    property alias bHelp4Visible : helpArea4.visible
    property alias bHelp5Visible : helpArea5.visible
    property alias bHelp6Visible : helpArea6.visible
    property alias title : titleText.text
    property alias text1 : helpText_1.text
    property alias text2 : helpText_2.text
    property alias text3 : helpText_3.text
    property alias text4 : helpText_4.text
    property alias text5 : helpText_5.text
    property alias text6 : helpText_6.text
    property double text1XPart : 0
    property double text2XPart : 0
    property double text3XPart : 0
    property double text4XPart : 0
    property double text5XPart : 0
    property double text6XPart : 0
    property double text1YPart : 0
    property double text2YPart : 0
    property double text3YPart : 0
    property double text4YPart : 0
    property double text5YPart : 0
    property double text6YPart : 0

    // custo help 1
    property alias bHelpCustom1Visible : helpCustomArea1.visible
    property alias textCustom1 : helpCustomText_1.text
    property alias textCustom1XPart : helpCustomArea1.x
    property alias textCustom1YPart : helpCustomArea1.y

    // custo help 2
    property alias bHelpCustom2Visible : helpCustomArea2.visible
    property alias textCustom2 : helpCustomText_2.text
    property alias textCustom2XPart : helpCustomArea2.x
    property alias textCustom2YPart : helpCustomArea2.y

    // custo help 3
    property alias bHelpCustom3Visible : helpCustomArea3.visible
    property alias textCustom3 : helpCustomText_3.text
    property alias textCustom3XPart : helpCustomArea3.x
    property alias textCustom3YPart : helpCustomArea3.y

    // action on help screen
    MouseArea {
        anchors.fill: parent
    }

    Rectangle {

        id:titleArea
        anchors.top : parent.top
        anchors.topMargin: BComStyles.rightMargin*2
        anchors.left : parent.left
        anchors.leftMargin: BComStyles.rightMargin
        width:509
        height:103
        Text {
            id: titleText
            text:  appTitle
            font.family: "Bcom"
            //font.weight:Font.Bold
            color :"white"
            font.pixelSize: 18

        }
        color: "transparent"
    }


    Button {
        Image {source:"images/closebuttonimage.png"  }  //button close help
        id:closebuttonimage
        anchors.top : parent.top
        anchors.topMargin: BComStyles.rightMargin*2
        anchors.right : parent.right
        anchors.rightMargin: BComStyles.rightMargin
        width:40
        height:40

        onClicked: helpoverlaybloc_75.visible=false
        style: ButtonStyle {
            background: Rectangle {
                color: "transparent"
            }
        }
    }

    // Help 1
    Rectangle {
        id:helpArea1
        color:"transparent"
        x : text1XPart
        y : text1YPart
        width : helpPicto_1.width + helpTextArea_1.width + BComStyles.rightMargin
        height : Math.max(helpTextArea_1.height, helpPicto_1.height)
        visible: false

        Image {
            source:"images/helppicto_1.png"         //image picto <1>
            id:helpPicto_1
            anchors.left : parent.left
            anchors.top : parent.top
            width:pictoSize
            height:pictoSize
        }

        Rectangle{
            id:helpTextArea_1
            anchors.left : helpPicto_1.right
            anchors.leftMargin : BComStyles.rightMargin
            anchors.verticalCenter: parent.verticalCenter
            width:helpText_1.contentWidth
            height:helpText_1.contentHeight
            Text {
                id : helpText_1
                text:  "help text 1 - to be defined"
                font.family: "Bcom"
                font.weight:Font.Bold
                 color :"white"
                font.pixelSize: 20
            }
            color: "transparent"
        }
    }

    // Help 2
    Rectangle {
        id:helpArea2
        color:"transparent"
        x : text2XPart
        y : text2YPart
        width : helpPicto_2.width + helpTextArea_2.width + BComStyles.rightMargin
        height : Math.max(helpTextArea_2.height, helpPicto_2.height)
        visible: false

        Image {
            source:"images/helppicto_2.png"      //image picto <2>
            id:helpPicto_2
            anchors.left : parent.left
            anchors.top : parent.top
            width:pictoSize
            height:pictoSize
        }

        Rectangle {
            id : helpTextArea_2
            anchors.left : helpPicto_2.right
            anchors.leftMargin : BComStyles.rightMargin
            anchors.verticalCenter: parent.verticalCenter
            width:helpText_2.contentWidth
            height:helpText_2.contentHeight
            Text {
                id:helpText_2
                text:  "help text 2 - to be defined"
                font.family: "Bcom"
                font.weight:Font.Bold
                color :"white"
                font.pixelSize: 20
            }
            color: "transparent"
        }
    }

    // Help 3
    Rectangle {
        id:helpArea3
        color:"transparent"
        x : text3XPart
        y : text3YPart
        width : helpPicto_3.width + helpTextArea_3.width + BComStyles.rightMargin
        height : Math.max(helpTextArea_3.height, helpPicto_3.height)
        visible: false

        Image {
            source:"images/helppicto_3.png"         //image picto <3>
            id:helpPicto_3
            anchors.left : parent.left
            anchors.top : parent.top
            width:pictoSize
            height:pictoSize
        }

        Rectangle {
            id: helpTextArea_3
            anchors.left : helpPicto_3.right
            anchors.leftMargin : BComStyles.rightMargin
            anchors.verticalCenter: parent.verticalCenter
            width:helpText_3.contentWidth
            height:helpText_3.contentHeight
            Text {
                id:helpText_3
                text:  "help text 3 - to be defined"
                font.family: "Bcom"
                font.weight:Font.Bold
                color :"white"
                font.pixelSize: 20

            }
            color: "transparent"
        }
    }

    // Help 4
    Rectangle {
        id:helpArea4
        color:"transparent"
        x : text4XPart
        y : text4YPart
        width : helpPicto_4.width + helpTextArea_4.width + BComStyles.rightMargin
        height : Math.max(helpTextArea_4.height, helpPicto_4.height)
        visible: false

        // Help 4
        Image {
            source:"images/helppicto_4.png"
            id:helpPicto_4
            anchors.left : parent.left
            anchors.top : parent.top
            width:pictoSize
            height:pictoSize
        }

        Rectangle {
            id:helpTextArea_4
            anchors.left : helpPicto_4.right
            anchors.leftMargin : BComStyles.rightMargin
            anchors.verticalCenter: parent.verticalCenter
            width:helpText_4.contentWidth
            height:helpText_4.contentHeight
            Text {
                id:helpText_4
                text:  "help text 4 - to be defined"
                font.family: "Bcom"
                font.weight:Font.Bold
                color :"white"
                font.pixelSize: 20
                wrapMode: Text.WordWrap
            }
            color: "transparent"
        }
    }

    // Help 5
    Rectangle {
        id:helpArea5
        color:"transparent"
        x : text5XPart
        y : text5YPart
        width : helpPicto_5.width + helpTextArea_5.width + BComStyles.rightMargin
        height : Math.max(helpTextArea_5.height, helpPicto_5.height)
        visible: false

        // Help 5
        Image {
            source:"images/helppicto_5.png"
            id:helpPicto_5
            anchors.left : parent.left
            anchors.top : parent.top
            width:pictoSize
            height:pictoSize
        }

        Rectangle {
            id:helpTextArea_5
            anchors.left : helpPicto_5.right
            anchors.leftMargin : BComStyles.rightMargin
            anchors.verticalCenter: parent.verticalCenter
            width:helpText_5.contentWidth
            height:helpText_5.contentHeight
            Text {
                id:helpText_5
                text:  "help text 5 - to be defined"
                font.family: "Bcom"
                font.weight:Font.Bold
                color :"white"
                font.pixelSize: 20
                wrapMode: Text.WordWrap
            }
            color: "transparent"
        }
    }

    // Help 6
    Rectangle {
        id:helpArea6
        color:"transparent"
        x : text6XPart
        y : text6YPart
        width : helpPicto_6.width + helpTextArea_6.width + BComStyles.rightMargin
        height : Math.max(helpTextArea_6.height, helpPicto_6.height)
        visible: false

        // Help 6
        Image {
            source:"images/helppicto_6.png"
            id:helpPicto_6
            anchors.left : parent.left
            anchors.top : parent.top
            width:pictoSize
            height:pictoSize
        }

        Rectangle {
            id:helpTextArea_6
            anchors.left : helpPicto_6.right
            anchors.leftMargin : BComStyles.rightMargin
            anchors.verticalCenter: parent.verticalCenter
            width:helpText_6.contentWidth
            height:helpText_6.contentHeight
            Text {
                id:helpText_6
                text:  "help text 6 - to be defined"
                font.family: "Bcom"
                font.weight:Font.Bold
                color :"white"
                font.pixelSize: 20
                wrapMode: Text.WordWrap
            }
            color: "transparent"
        }
    }

    Button {
        id:helpurlblock
        anchors.bottom : parent.bottom
        anchors.bottomMargin: 25
        anchors.left : parent.left
        anchors.leftMargin: 25
        width:helpurlText.width + BComStyles.rightMargin
        height:25
        z:1

        Text {
            id : helpurlText
            text:  "www.b-com.com"
            font.family: "Bcom"
            color :"black"
            font.pixelSize: 18
            anchors.centerIn: parent
        }

        onClicked:
            Qt.openUrlExternally("http://b-com.com/");
        style: ButtonStyle {

            background: Rectangle {
               color: "white"
            }
        }
    }

    Button {
        id:helpSupportEmailBlock
        anchors.bottom : parent.bottom
        anchors.bottomMargin: 25
        anchors.left : helpurlblock.right
        anchors.leftMargin: 25
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

    Rectangle {
        id:versionArea
        anchors.bottom : parent.bottom
        anchors.bottomMargin: 25
        anchors.right : parent.right
        anchors.rightMargin: 25
        width:100
        height:parent.height/27.7
        Text {
            id: versionText
            text:  "Version : " + version
            font.family: "Bcom"
            //font.weight:Font.DemiBold
            color :"white"
            font.pixelSize: 18

        }
        color: "transparent"
    }

    // Custom Help 1
    Rectangle {
        id:helpCustomArea1
        color:"transparent"
        width:helpCustomText_1.contentWidth
        height:helpCustomText_1.contentHeight
        visible: false

        BComTextBlock {
            id : helpCustomText_1
            text:  "help custom text 1 - to be defined"
            textFontFamily: "Bcom"
            color :"white"
            textFontSize: 20
            textFontWeight: Font.Bold
            textWrapMode: Text.WordWrap
            source : "images/arrowup.png"
            labelVerticalCentered : false
            pictoVerticalCentered  : false
            textHorizontalAlignment : Text.AlignLeft
        }
    }

    // Custom Help 2
    Rectangle {
        id:helpCustomArea2
        color:"transparent"
        width:helpCustomText_2.contentWidth
        height:helpCustomText_2.contentHeight
        visible: false

        BComTextBlock {
            id : helpCustomText_2
            text:  "help custom text 2 - to be defined"
            textFontFamily: "Bcom"
            color :"white"
            textFontSize: 20
            textFontWeight: Font.Bold
            textWrapMode: Text.WordWrap
            source : "images/arrowup.png"
            labelVerticalCentered : false
            pictoVerticalCentered  : false
            textHorizontalAlignment : Text.AlignLeft
        }
    }

    // Custom Help 3
    Rectangle {
        id:helpCustomArea3
        color:"transparent"
        width:helpCustomText_3.contentWidth
        height:helpCustomText_3.contentHeight
        visible: false

        BComTextBlock {
            id : helpCustomText_3
            text:  "help custom text 3 - to be defined"
            textFontFamily: "Bcom"
            color :"white"
            textFontSize: 20
            textFontWeight: Font.Bold
            textWrapMode: Text.WordWrap
            source : "images/arrowup.png"
            labelVerticalCentered : false
            pictoVerticalCentered  : false
            textHorizontalAlignment : Text.AlignLeft
        }
    }
}



