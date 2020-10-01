import QtQuick 2.3
import QtQuick.Controls 1.4
import "BComStyles.js" as BComStyles

Rectangle {
    objectName: "parametersRootWidget"
    color: BComStyles.darkGrey

    // Check default params (duration & nbViews not empty)
    function checkParams () {
        if (defaultVisbilityText && defaultNbViewsText && applyButton)
        {
            if (defaultVisbilityText.text.length > 0 && defaultNbViewsText.text.length > 0)
            {
                applyButton.enabled = true
            }
            else
            {
                applyButton.enabled = false
            }
        }
    }

    BComMenuBar {
        id: menuBar
        productTitle: "*" + appTitle + "*"
        currentTitle: "/ parameters"
        helpEnabled: true
        paramEnabled: false
        closeEnabled: true
        interfacesEnabled: true
        componentsEnabled: true
        configuratorEnabled: true
        modulesEnabled: true
    }

    // Close button
    Rectangle {
        id: closeButtonRect
        anchors.left: parent.left
        anchors.leftMargin: BComStyles.rightMargin
        anchors.right: parent.right
        anchors.rightMargin: BComStyles.rightMargin
        anchors.top:menuBar.bottom
        anchors.topMargin: BComStyles.rightMargin
        color:"black"
        height : 60

        BComButton {
            Image {source:"images/closebuttonimage.png"
                   anchors.centerIn: parent}
            id:closebuttonimage
            anchors.verticalCenter: parent.verticalCenter
            anchors.right : parent.right
            anchors.rightMargin: BComStyles.rightMargin
            width:35
            height:35
            buttonColor : "black"
            bPictoBefore: false
            bCenterText: true

            onClicked: {
                rootWidget.state=rootWidget.parametersPreviousState
            }

            Component.onCompleted: {
                closebuttonimage.enabled = true;
            }
            tooltip: "close parameters"
        }
    }

    // Black backgroung rect
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: BComStyles.rightMargin
        anchors.right: parent.right
        anchors.rightMargin: BComStyles.rightMargin
        anchors.top:closeButtonRect.bottom
        anchors.bottom: parent.bottom
        color:"black"
    }

    // transparent rect (not aligned under 'closeButtonRect' in order to display 'defaultSettingsTitleLabel' at same 'y' level of 'closebuttonimage')
    Rectangle {
        id:parametersWidgetRect
        anchors.left: parent.left
        anchors.leftMargin: BComStyles.rightMargin
        anchors.right: parent.right
        anchors.rightMargin: BComStyles.rightMargin
        anchors.top:menuBar.bottom
        anchors.topMargin: BComStyles.rightMargin
        anchors.bottom: parent.bottom
        color:"transparent"

        // Add/remove Contact title
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

        // default Visibility
        BComTextStyle3 {
            id: defaultVisbilityLabel
            anchors.top: defaultSettingsTitleLabel.bottom
            anchors.topMargin: BComStyles.rightMargin
            anchors.left: defaultSettingsTitleLabel.left
            color: "white"
            visible:true
            wrapMode: Text.WordWrap
            text: "REMAKENROOT :"
        }
        TextField {
             id:defaultVisbilityText
             width: 140
             anchors.top: defaultVisbilityLabel.top
             anchors.left : defaultVisbilityLabel.right
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

        // default number of views
        BComTextStyle3 {
            id: defaultNbViewsLabel
            anchors.top: defaultVisbilityLabel.bottom
            anchors.topMargin: BComStyles.rightMargin
            anchors.left: defaultVisbilityLabel.left
            color: "white"
            visible:true
            wrapMode: Text.WordWrap
            text: "xpcf registry default path :"

        }
        TextField {
            id:defaultNbViewsText
            width: 140
            anchors.top: defaultNbViewsLabel.top
            anchors.left : defaultVisbilityLabel.right
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
            anchors.left: defaultNbViewsText.right
            anchors.leftMargin: BComStyles.rightMargin
            width: applyButton.width
            anchors.top:defaultVisbilityText.top
            anchors.bottom: defaultNbViewsText.bottom
            color:"black"

            BComButton {
                id:applyButton
                anchors.verticalCenter: parent.verticalCenter

                bPictoBefore: false
                bCenterText: true
                enabled: false
                width : 140
                height : 40
                buttonColor: "green"
                BComTextStyle3 {text:"Apply"
                 anchors.centerIn: parent}
                onClicked: {
                    enabled  = false;
                    // Applys settings values
                    user.setUserProperties(defaultVisbilityText.text, defaultNbViewsText.text)
                }
            }
        }


        // Separator
        Rectangle {
            id: separatorRect
            anchors.left: parent.left
            anchors.leftMargin: BComStyles.HorizontalComponentMargin
            anchors.top: defaultNbViewsLabel.bottom
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
        text1XPart : defaultVisbilityText.x + defaultVisbilityText.width + parametersWidgetRect.x
        text1YPart : defaultVisbilityText.y + parametersWidgetRect.y - 10
        text2XPart : defaultNbViewsText.x + defaultNbViewsText.width + parametersWidgetRect.x
        text2YPart : defaultNbViewsText.y + parametersWidgetRect.y

        bHelpCustom1Visible : true
        textCustom1: "display\nmodules\nlist"
        textCustom1XPart: parent.width-630
        textCustom1YPart: menuBar.height -20

        bHelpCustom2Visible : true
        textCustom2: "display\ncomponents"
        textCustom2XPart: parent.width-510
        textCustom2YPart: menuBar.height -20

        bHelpCustom3Visible : true
        textCustom3: "define\ndefault\nparameters"
        textCustom3XPart: parent.width-285
        textCustom3YPart: menuBar.height -20
    }

    Component.onCompleted:
    {
        applyButton.enabled = false
    }
}
