import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

Rectangle {
    id: interfacesRootWidget
    objectName: "interfacesRootWidget"
    color: BComStyles.darkGrey

    function updateComponentInfos(component) {
        interfacesModel.clear();
        user.getComponentInfos(component)
    }

    function getComponents(moduleName) {
        user.getComponents(moduleName)
    }

    function updateComponentParams(uuid) {
        user.getComponentParams(uuid)
    }

    ColumnLayout {
        anchors.fill: parent
        Layout.fillWidth: true
        spacing: 0

        Rectangle {
            id: titleRect
            color:BComStyles.darkGrey
            height: 48

            BComTextBlock {
                id:interfacesComboboxLabel
                enabled:true
                anchors.verticalCenter: titleRect.verticalCenter
                anchors.left: titleRect.left
                bCenterText : false
                text:"Select interface:"
                textFontSize: 30
            }

            ComboBox {
                id: interfacesCombobox
                property bool completed: false
                textRole: 'name'
                anchors.verticalCenter: interfacesComboboxLabel.verticalCenter
                anchors.left: interfacesComboboxLabel.right
                anchors.leftMargin: 300
                visible:true
                editable: true
                width: 250
                height:30
                model: allInterfacesModel

                onCurrentIndexChanged: {
                    if (interfacesCombobox.completed) {
                        user.getComponentsForInterface(allInterfacesModel.index(interfacesCombobox.currentIndex,0))
                        if (componentList.count > 0) {
                            componentList.currentIndex = 0
                            if (paramsTableView.completed) {
                                updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                            }
                            if (componentInfosTableView.completed) {
                                updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    user.getModules();
                    user.getComponentsForInterface(allInterfacesModel.index(interfacesCombobox.currentIndex,0))
                    completed = true
                }
            }
        }

        // component list
        Rectangle {
            id: contentRect
            Layout.fillWidth: true
            Layout.fillHeight: true
            color:"black"

            // components  - title
            BComTextStyle1 {
                id: componentsLabel
                anchors {
                    top: parent.top
                    topMargin: BComStyles.rightMargin
                    left: parent.left
                    leftMargin: BComStyles.rightMargin
                }
                color: "white"
                visible:true
                wrapMode: Text.WordWrap
                text: "components:"
            }

            // buttons refresh/close
            Rectangle {
                id: buttonBarRect
                anchors {
                    left: parent.left
                    leftMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top:parent.top
                }
                color:"transparent"
                height : 60

                BComButton {
                    Image {
                        source:"images/refreshbuttonimage.png"
                        anchors.centerIn: parent
                    }
                    id:refreshButton
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right : parent.right
                    }
                    width:35
                    height:35
                    buttonColor : "black"
                    //               bCenterText: true

                    onClicked: {
                        updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                    }

                    Component.onCompleted: {
                        refreshButton.enabled = true;
                    }
                    tooltip: "refresh informations"
                }
            }


            Rectangle {
                id: componentListRect
                anchors {
                    top:componentsLabel.bottom
                    topMargin: BComStyles.rightMargin
                    left: parent.left
                    leftMargin: BComStyles.rightMargin
                    bottom:parent.bottom
                    bottomMargin: BComStyles.rightMargin
                }
                width: 550
                //height:componentListStatus.height
                color : BComStyles.darkGrey

                // components List
                Component {
                    id: componentListDelegate
                    Item {
                        id : componentItemRect
                        //property alias name: componentItemText.text // added this property alias to access the text of the current list item
                        width: componentList.width-componentListScrollBar.width;
                        height: 30
                        BComTextStyle3 {
                            id: componentItemText
                            text: name
                            color: BComStyles.white
                            anchors {
                                left : parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 5
                            }
                            font.weight: Font.Light
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                componentList.currentIndex = index
                            }
                        }
                    }
                }

                ListView {
                    id: componentList
                    model :componentModel
                    delegate: componentListDelegate
                    anchors {
                        left: parent.left
                        top:parent.top
                        right: parent.right
                        bottom:parent.bottom
                    }
                    spacing:2
                    clip: true
                    highlight:
                        Rectangle {
                        color: BComStyles.lightGrey
                    }
                    focus : true

                    onCurrentIndexChanged: {
                        console.log("componentList::onCurrentIndexChanged - index : " + currentIndex + " ; component : " + currentItem.name)
                        if (paramsTableView.completed && interfacesCombobox.completed) {
                            updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                        }
                        if (componentInfosTableView.completed  && interfacesCombobox.completed) {
                            updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                        }
                    }
                }

                Scrollbar {
                    id : componentListScrollBar
                    flickable: componentList
                }
            }

            ////////////////////
            // Component informations table
            ////////////////////

            BComTextBlock {
                id:interfacesLabel
                enabled:true
                anchors {
                    top: componentListRect.top
                    left: componentListRect.right
                    leftMargin: BComStyles.rightMargin
                }
                bCenterText : false
                color:BComStyles.darkGrey
                text:"Component interfaces :"
                textFontSize: 20
            }


            TableView {
                id : componentInfosTableView
                property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
                property var currentUUID: 0
                columnWidthProvider: function (column) { return 200 }
                rowHeightProvider: function (row) { return 50 }
                height: 250
                /*Layout {
                fillWidth: true
                alignment: Qt.AlignTop | Qt.AlignBottom
                topMargin: BComStyles.verticalSpacing
            }*/
                anchors {
                    left: componentListRect.right
                    leftMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top: interfacesLabel.bottom
                    topMargin: BComStyles.rightMargin
                }

                model: interfacesModel
                focus: true
                delegate: textDelegate
                Component.onCompleted: {
                    completed = true
                    if (interfacesCombobox.completed) {
                        updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                    }
                }
                // Delegate - text items
                Component {
                    id: textDelegate
                    Rectangle {
                        color: "transparent"
                        implicitWidth: 250
                        implicitHeight: 50
                        BComTextStyle3
                        {
                            id: rowText
                            anchors {
                                fill: parent
                                leftMargin: BComStyles.verticalSpacing
                            }
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter

                            text: tabledata
                            elide: Text.ElideRight
                            color: "white"
                        }
                        MouseArea {
                            id: mouseRegion
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (mouse.button & Qt.RightButton) {
                                    console.log( "Clicked" + rowText.text + modulesModel.uuid(modulesModel.index(row,0)))
                                    modulesTableView.currentUUID = modulesModel.uuid(modulesModel.index(row,0))
                                    modulesStack.currentIndex = 1
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id:saveStructureButtonRect
                anchors {
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top:componentInfosTableView.bottom
                    topMargin: BComStyles.rightMargin
                }
                width: saveStructureButton.width

                color:"black"

                BComButton {
                    id:saveStructureButton
                    anchors.verticalCenter: parent.verticalCenter
                    //bCenterText: true
                    enabled: false
                    width : 300
                    height : 40
                    buttonColor: "green"
                    BComTextStyle3 {text:"Save module structure information"
                        anchors.centerIn: parent}
                    onClicked: {
                        enabled  = false;
                        // Applys settings values
                        user.save(interfacesCombobox.currentText)
                    }
                }
            }
            // Separator
            Rectangle {
                id: separatorRect
                anchors {
                    left: componentListRect.right
                    leftMargin: BComStyles.HorizontalComponentMargin
                    top: saveStructureButtonRect.bottom
                    topMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.HorizontalComponentMargin
                }
                height:2
                color : BComStyles.darkGrey
            }

            ////////////////////
            // Component parameters table
            ////////////////////

            BComTextBlock {
                id:parametersLabel
                enabled:true
                anchors {
                    top: separatorRect.bottom
                    topMargin: BComStyles.rightMargin
                    left: componentListRect.right
                    leftMargin: BComStyles.rightMargin
                }
                bCenterText : false
                color:BComStyles.darkGrey
                text:"Component parameters :"
                textFontSize: 20
            }


            TableView {
                id : paramsTableView
                property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
                property var currentUUID: 0
                columnWidthProvider: function (column) { return 200 }
                rowHeightProvider: function (row) { return 50 }
                height: 250
                /*Layout {
                fillWidth: true
                alignment: Qt.AlignTop | Qt.AlignBottom
                topMargin: BComStyles.verticalSpacing
            }*/
                anchors {
                    left: componentListRect.right
                    leftMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top: parametersLabel.bottom
                    topMargin: BComStyles.rightMargin
                    bottom: saveParamsButtonRect.top
                    bottomMargin: BComStyles.rightMargin
                }
                focus: true
                delegate: paramsTextDelegate
                Component.onCompleted: {
                    completed = true
                    if (interfacesCombobox.completed) {
                        updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                    }
                }
                // Delegate - text items
                Component {
                    id: paramsTextDelegate
                    Rectangle {
                        color: "transparent"
                        implicitWidth: 250
                        implicitHeight: 50
                        BComTextStyle3
                        {
                            id: rowText
                            anchors {
                                fill: parent
                                leftMargin: BComStyles.verticalSpacing
                            }
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: tabledata
                            elide: Text.ElideRight
                            color: "white"
                        }
                        MouseArea {
                            id: mouseRegion
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (mouse.button & Qt.RightButton) {
                                    console.log( "Clicked" + rowText.text + modulesModel.uuid(modulesModel.index(row,0)))
                                    modulesTableView.currentUUID = modulesModel.uuid(modulesModel.index(row,0))
                                    modulesStack.currentIndex = 1
                                }
                            }
                        }
                    }
                }

                model: parametersModel
            }

            Rectangle {
                id:saveParamsButtonRect
                anchors {
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    bottom: parent.bottom
                    bottomMargin: BComStyles.rightMargin
                }
                width: saveStructureButton.width

                color:"black"

                BComButton {
                    id:saveParamsButton
                    anchors.verticalCenter: parent.verticalCenter
                    //bCenterText: true
                    enabled: false
                    width : 300
                    height : 40
                    buttonColor: "green"
                    BComTextStyle3 {text:"Save parameters information"
                        anchors.centerIn: parent}
                    onClicked: {
                        enabled  = false;
                        // Applys settings values
                        //user.setUserProperties(defaultVisbilityText.text, defaultNbViewsText.text)
                    }
                }
            }
        }
    }

    Help {
        id:help
        visible:false;
        bHelp1Visible : true
        bHelp2Visible : true
        bHelp3Visible : true
        text1 : "Your current\ncomponent list"
        text2 : "Help text 2"
        text3 : "Help text 3"
        text1XPart : contentRect.x + componentListRect.x
        text1YPart : contentRect.y + componentListRect.y
        text2XPart : contentRect.x + paramsTableView.x
        text2YPart : contentRect.y + paramsTableView.y
        text3XPart : contentRect.x + paramsTableView.x
        text3YPart : contentRect.y + paramsTableView.y + 100

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

    Component.onCompleted: {
        if (paramsTableView.completed && interfacesCombobox.completed) {
            updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
        }
        if (componentInfosTableView.completed  && interfacesCombobox.completed) {
            updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
        }
    }
}
