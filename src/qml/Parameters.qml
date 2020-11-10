import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

Rectangle {
    objectName: "parametersRootWidget"
    color: BComStyles.darkGrey

    // Check default params (duration & nbViews not empty)
    function checkParams () {
        if (remakenrootText && xpcfRegistryDefaultPathText && applyButton)
        {
            if (remakenrootText.text.length > 0 && xpcfRegistryDefaultPathText.text.length > 0)
            {
                applyButton.enabled = true
            }
            else
            {
                applyButton.enabled = false
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        Layout.fillWidth: true
        spacing: 0

        Rectangle {
            id: titleRect
            color:BComStyles.darkGrey
            Layout.fillWidth: true
            height: 48

            BComTextBlock {
                id:parametersComboboxLabel
                enabled:true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                bCenterText : false
                text:"Parameters:"
                textFontSize: 30
            }

            /*BComButton2 {
                id:closebuttonimage
                buttonColor: BComStyles.darkGrey
                Image {source:"images/closebuttonimage.png"
                    anchors.centerIn: parent}
                anchors.verticalCenter: parent.verticalCenter
                anchors.right : parent.right
                anchors.rightMargin: BComStyles.rightMargin
                width:35
                height:35
                onClicked: {
                    rootWidget.state=rootWidget.parametersPreviousState
                }

                Component.onCompleted: {
                    closebuttonimage.enabled = true;
                }
                tooltip: "close parameters"
            }*/
        }

        // component list
        Rectangle {
            id: contentRect
            Layout.fillWidth: true
            Layout.fillHeight: true
            color:"black"

            // Default Settings title
            BComTextStyle1 {
                id: defaultSettingsTitleLabel
                anchors.top: parent.top
                anchors.topMargin: BComStyles.verticalSpacing
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.rightMargin
                color: "white"
                visible:true
                wrapMode: Text.WordWrap
                text: "default settings :"
            }

            // REMAKENROOT
            BComTextStyle3 {
                id: remakenrootLabel
                anchors.top: defaultSettingsTitleLabel.bottom
                anchors.topMargin: BComStyles.rightMargin
                anchors.left: defaultSettingsTitleLabel.left
                width : 200
                color: "white"
                visible:true
                wrapMode: Text.WordWrap
                text: "REMAKENROOT :"
            }
            TextField {
                id:remakenrootText
                width: 350
                anchors.top: remakenrootLabel.top
                anchors.left : remakenrootLabel.right
                anchors.leftMargin:  BComStyles.rightMargin
                font.family: "Bcom"
                font.weight: Font.Light
                font.pointSize:18
                placeholderText: qsTr("Enter path")
                validator: IntValidator { bottom:0; top: 2000}
                text : user.getDevRoot()
                onTextChanged: {
                    checkParams();
                }
            }

            // xpcf registry default path
            BComTextStyle3 {
                id: xpcfRegistryDefaultPathLabel
                anchors.top: remakenrootLabel.bottom
                anchors.topMargin: BComStyles.rightMargin
                anchors.left: remakenrootLabel.left
                width : 200
                color: "white"
                visible:true
                wrapMode: Text.WordWrap
                text: "xpcf registry default path :"

            }
            TextField {
                id:xpcfRegistryDefaultPathText
                width: 350
                anchors.top: xpcfRegistryDefaultPathLabel.top
                anchors.left : xpcfRegistryDefaultPathLabel.right
                anchors.leftMargin:  BComStyles.rightMargin
                font.family: "Bcom"
                font.weight: Font.Light
                verticalAlignment: Text.AlignVCenter
                font.pointSize:18
                placeholderText: qsTr("Enter path")
                validator: IntValidator { bottom:0; top: 2000}
                text : user.getXpcfRegistryDefaultPath()
                onTextChanged: {
                    checkParams();
                }
            }

            Rectangle {
                id:applyButtonRect
                anchors.left: remakenrootText.right
                anchors.leftMargin: BComStyles.rightMargin
                width: applyButton.width
                anchors.top:remakenrootText.top
                anchors.bottom: xpcfRegistryDefaultPathText.bottom
                color:"transparent"

                BComButton2 {
                    id:applyButton
                    enabled: false
                    buttonColor: BComStyles.darkGrey
                    anchors.centerIn: parent
                    width:140
                    height:40
                    text : "Apply"
                    onClicked: {
                        enabled  = false;
                        // Applys settings values
                        user.setUserProperties(remakenrootText.text, xpcfRegistryDefaultPathText.text)
                    }
                    tooltip: "Apply parameters"
                }
            }

            // Separator
            Rectangle {
                id: separatorRect
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.HorizontalComponentMargin
                anchors.top: xpcfRegistryDefaultPathLabel.bottom
                anchors.topMargin: BComStyles.rightMargin
                anchors.right: parent.right
                anchors.rightMargin: BComStyles.HorizontalComponentMargin
                height:2
                color : BComStyles.darkGrey
            }
        }

        Help {
            id:help
            visible:false;
            bHelp1Visible : true
            bHelp2Visible : true
            bHelp3Visible : true
            bHelp4Visible : true
            text1 : "Select the path for REMAKENROOT replacement"
            text2 : "Select the path for default xpcf registry location"
            text1XPart : remakenrootText.x + remakenrootText.width + contentRect.x
            text1YPart : remakenrootText.y + contentRect.y - 10
            text2XPart : xpcfRegistryDefaultPathText.x + xpcfRegistryDefaultPathText.width + contentRect.x
            text2YPart : xpcfRegistryDefaultPathText.y + contentRect.y

            bHelpCustom1Visible : true
            textCustom1: "display\nmodules\nlist"
            textCustom1XPart: parent.width-630
            textCustom1YPart: -20

            bHelpCustom2Visible : true
            textCustom2: "display\ncomponents"
            textCustom2XPart: parent.width-510
            textCustom2YPart: -20

            bHelpCustom3Visible : true
            textCustom3: "define\ndefault\nparameters"
            textCustom3XPart: parent.width-285
            textCustom3YPart: -20
        }

        Component.onCompleted:
        {
            applyButton.enabled = false
        }
    }
}
