import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles
import SortFilterProxyModel 0.1

Rectangle {
    id: componentsRootWidget
    objectName: "componentsRootWidget"
    color: BComStyles.darkGrey

    function addComponentInfos(uuid,name) {
        // int conversion (for sort on integer)
        // componentInfosTableViewModel.append({uuid: uuid, name: name})
    }

    function updateComponentInfos(component) {
        interfacesModel.clear();
        user.getComponentInfos(component)
    }

    function getComponents(moduleName) {
        user.getComponents(moduleName)
    }

    function updateComponentParams(uuid) {
        //paramsTableViewModel.clear();
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
                id:modulesComboboxLabel
                enabled:true
                anchors.verticalCenter: titleRect.verticalCenter
                anchors.left: titleRect.left
                bCenterText : false
                text:"Select module:"
                textFontSize: 30
            }

            ComboBox {
                id: modulesCombobox
                property bool completed: false
                textRole: "name"
                anchors.verticalCenter: modulesComboboxLabel.verticalCenter
                anchors.left: modulesComboboxLabel.right
                anchors.leftMargin: 300
                visible:true
                //editable: true
                width: 250
                height:30
                model: modulesModel

                onCurrentIndexChanged: {
                    if (modulesCombobox.completed) {
                        user.getComponents(modulesModel.index(modulesCombobox.currentIndex,0))
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
                    user.getComponents(modulesModel.index(modulesCombobox.currentIndex,0))
                    completed = true
                }

                onCountChanged:
                {
                    if (count == 0) {
                        modulesCombobox.currentIndex = 0;
                    }
                    user.getModules();
                    user.getComponents(modulesModel.index(modulesCombobox.currentIndex,0))
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
                anchors.top: parent.top
                anchors.topMargin: BComStyles.rightMargin
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.rightMargin
                color: "white"
                visible:true
                wrapMode: Text.WordWrap
                text: "components:"
            }

            // buttons refresh/close
            Rectangle {
                id: buttonBarRect
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.rightMargin
                anchors.right: parent.right
                anchors.rightMargin: BComStyles.rightMargin
                anchors.top:parent.top
                color:"transparent"
                height : 60

                BComButton2 {
                    id:refreshButton
                    buttonColor: "black"
                    Image {source:"images/refreshbuttonimage.png"
                        anchors.centerIn: parent}
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right : parent.right
                    width:35
                    height:35
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
                anchors.top:componentsLabel.bottom
                anchors.topMargin: BComStyles.rightMargin
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.rightMargin
                anchors.bottom:parent.bottom
                anchors.bottomMargin: BComStyles.rightMargin
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
                            anchors.left : parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 5
                            font.weight: Font.Light
                        }
                        ToolTip {
                            id: componentTooltip
                            text: description
                            delay: 500
                            timeout: 1000
                        }

                        MouseArea {
                            id: mouseRegion
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                componentList.currentIndex = index
                                componentTooltip.open()
                            }
                            /* onEntered: {

                            }*/
                        }
                    }
                }

                ListView {
                    id: componentList
                    model : componentModel
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
                        if (paramsTableView.completed && modulesCombobox.completed) {
                            updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                        }
                        if (componentInfosTableView.completed  && modulesCombobox.completed) {
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
                anchors.top: componentListRect.top
                anchors.left: componentListRect.right
                anchors.leftMargin: BComStyles.rightMargin
                bCenterText : false
                color:BComStyles.darkGrey
                text:"Component interfaces :"
                textFontSize: 20
            }

            Rectangle {
                id: componentInfosTableViewBorderRect
                height: 250
                anchors {
                    left: componentListRect.right
                    leftMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top: interfacesLabel.bottom
                    topMargin: BComStyles.rightMargin
                }
                color : "transparent"
                border.width: 1
                border.color: BComStyles.grey

                TableView {
                    id : componentInfosTableView
                    property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
                    property var currentUUID: 0
                    columnWidthProvider: function (column) { return 200 }
                    rowHeightProvider: function (row) { return 50 }
                    anchors.fill: parent
                    anchors.leftMargin: 1
                    anchors.topMargin: 1
                    topMargin: columnsHeader.implicitHeight
                    model: interfacesModel
                    focus: true
                    delegate: textDelegate

                    Row {
                        id: columnsHeader
                        y: componentInfosTableView.contentY
                        //z: 2
                        Repeater {
                            model: componentInfosTableView.columns > 0 ? componentInfosTableView.columns : 1
                            Rectangle {
                                height: 25
                                width: componentInfosTableView.width / 3 // interfacesModel.columnCount
                                color: BComStyles.darkGrey
                                BComTextStyle3 {
                                    id: textItem
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.leftMargin: 12
                                    text: interfacesModel.headerData(modelData, Qt.Horizontal)
                                    elide: Text.ElideRight
                                    color: BComStyles.white
                                    font.weight: Font.Light
                                }

                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 1
                                    anchors.topMargin: 1
                                    width: 1
                                    color: "#ccc"
                                }
                            }
                        }
                    }

                    Component.onCompleted: {
                        completed = true
                        if (modulesCombobox.completed) {
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
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.leftMargin: BComStyles.verticalSpacing
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
            }

            Rectangle {
                id:saveStructureButtonRect
                anchors {
                    top:componentInfosTableViewBorderRect.bottom
                    topMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                }
                width: saveStructureButton.width
                color:"black"

                BComButton2 {
                    id:saveStructureButton
                    buttonColor: "grey"
                    anchors.verticalCenter: parent.verticalCenter
                    enabled: false
                    width : 300
                    height : 40
                    anchors.centerIn: parent
                    text:"Save module structure information"
                    onClicked: {
                        enabled  = false;
                        // Applys settings values
                        user.save(modulesCombobox.currentText)
                    }
                }
            }
            // Separator
            Rectangle {
                id: separatorRect
                anchors.left: componentListRect.right
                anchors.leftMargin: BComStyles.HorizontalComponentMargin
                anchors.top: saveStructureButtonRect.bottom
                anchors.topMargin: BComStyles.rightMargin
                anchors.right: parent.right
                anchors.rightMargin: BComStyles.HorizontalComponentMargin
                height:2
                color : BComStyles.darkGrey
            }

            ////////////////////
            // Component parameters table
            ////////////////////

            BComTextBlock {
                id:parametersLabel
                enabled:true
                anchors.top: separatorRect.bottom
                anchors.topMargin: BComStyles.rightMargin
                anchors.left: componentListRect.right
                anchors.leftMargin: BComStyles.rightMargin
                bCenterText : false
                color:BComStyles.darkGrey
                text:"Component parameters :"
                textFontSize: 20
            }

            Rectangle {
                id: paramsTableViewBorderRect
                height: 250
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
                color : "transparent"
                border.width: 1
                border.color: BComStyles.grey

                TableView {
                    id : paramsTableView
                    property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
                    property var currentUUID: 0
                    columnWidthProvider: function (column) { return 200 }
                    rowHeightProvider: function (row) { return 50 }
                    anchors.fill: parent
                    anchors.leftMargin: 1
                    anchors.topMargin: 1
                    topMargin: paramscolumnsHeader.implicitHeight
                    focus: true
                    delegate: paramsTextDelegate
                    model: parametersModel
                    Component.onCompleted: {
                        completed = true
                        if (modulesCombobox.completed) {
                            updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                        }
                    }

                    Row {
                        id: paramscolumnsHeader
                        y: paramsTableView.contentY
                        //z: 2
                        Repeater {
                            model: paramsTableView.columns > 0 ? paramsTableView.columns : 1
                            Rectangle {
                                height: 25
                                width: paramsTableView.width / 3 // interfacesModel.columnCount
                                color: BComStyles.darkGrey
                                BComTextStyle3 {
                                    id: paramstextItem
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.leftMargin: 12
                                    text: parametersModel.headerData(modelData, Qt.Horizontal)
                                    elide: Text.ElideRight
                                    color: BComStyles.white
                                    font.weight: Font.Light
                                }

                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 1
                                    anchors.topMargin: 1
                                    width: 1
                                    color: "#ccc"
                                }
                            }
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
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.leftMargin: BComStyles.verticalSpacing
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
            }

            Rectangle {
                id:saveParamsButtonRect
                anchors.right: parent.right
                anchors.rightMargin: BComStyles.rightMargin
                width: saveParamsButton.width
                anchors.bottom: parent.bottom
                anchors.bottomMargin: BComStyles.rightMargin
                color:"black"

                BComButton2 {
                    id:saveParamsButton
                    buttonColor: "grey"
                    anchors.verticalCenter: parent.verticalCenter
                    enabled: false
                    width : 300
                    height : 40
                    anchors.centerIn: parent
                    text:"Save parameters information"
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
        text2 : "Images shared for this component\n(with rights details seen/unseen...)"
        text3 : "click on an image to display\nimage configuration and download"
        text1XPart : contentRect.x + componentListRect.x
        text1YPart : contentRect.y + componentListRect.y
        /*text2XPart : contentRect.x + paramsTableView.x
        text2YPart : contentRect.y + paramsTableView.y
        text3XPart : contentRect.x + paramsTableView.x
        text3YPart : contentRect.y + paramsTableView.y + 100*/

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
        /*  if (paramsTableView.completed && modulesCombobox.completed) {
            updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
        }*/
        if (componentInfosTableView.completed  && modulesCombobox.completed) {
            updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
        }
    }
}
