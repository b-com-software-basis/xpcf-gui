import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

Rectangle {
    id: configuratorRootWidget
    objectName: "configuratorRootWidget"
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
                                updateComponentParams(selectedComponentTableView.currentUUID)
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

            BComButton2 {
                id:pickButton
                enabled:true
                anchors.top: configuratorToolBar.top
                anchors.left: componentListRect.right
                anchors.leftMargin: -40
                width:130
                buttonColor : "grey"
                text:"-- pick ->"
                onClicked: {
                    // SLETODO : disabled if empty!
                    user.pickComponent(modulesModel.uuid(modulesModel.index(modulesCombobox.currentIndex,0)),componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                }
                tooltip: "pick a component"
            }

            ConfiguratorToolBar {
                id: configuratorToolBar
                anchors.top: parent.top
                anchors.topMargin: BComStyles.rightMargin
                anchors.right: refreshButton.left
                anchors.rightMargin: BComStyles.rightMargin
                visible: true
            }

            BComButton2 {
                Image {source:"images/refreshbuttonimage.png"
                    anchors.centerIn: parent}
                id:refreshButton
                anchors.top:configuratorToolBar.top
                anchors.topMargin: 2
                anchors.right: parent.right
                anchors.rightMargin: BComStyles.rightMargin
                width:35
                height:35
                buttonColor : "black"
                onClicked: {
                    updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                }

                Component.onCompleted: {
                    refreshButton.enabled = true;
                }
                tooltip: "refresh informations"
            }

            Rectangle {
                id: componentListRect
                anchors.top:componentsLabel.bottom
                anchors.topMargin: BComStyles.rightMargin
                anchors.left: parent.left
                anchors.leftMargin: BComStyles.rightMargin
                height: parent.height*2/3
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
                        MouseArea {
                            anchors.fill: parent
                            drag.target: componentItemText
                            onReleased: parent = componentItemText.Drag.target !== null ? componentItemText.Drag.target : componentItemRect
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
                    anchors.left: parent.left
                    anchors.top:parent.top
                    anchors.right: parent.right
                    anchors.bottom:parent.bottom
                    spacing:2
                    clip: true
                    highlight:
                        Rectangle {
                        color: BComStyles.lightGrey
                    }
                    focus : true

                    onCurrentIndexChanged: {
                        console.log("componentList::onCurrentIndexChanged - index : " + currentIndex + " ; component : " + currentItem.name)
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

            Rectangle {
                id: componentInfosBorderRect
                anchors {
                    left: parent.left
                    leftMargin: BComStyles.rightMargin
                    right: componentListRect.right
                    top: componentListRect.bottom
                    topMargin: BComStyles.rightMargin
                    bottom : parent.bottom
                    bottomMargin: BComStyles.rightMargin
                }
                color : "transparent"
                border.width: 1
                border.color: BComStyles.grey

                TableView {
                    id : componentInfosTableView
                    property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
                    property var currentUUID: 0
                    anchors.fill: parent
                    anchors.leftMargin: 1
                    anchors.topMargin: 1
                    topMargin: paramscolumnsHeader.implicitHeight
                    focus: true
                    model: interfacesModel
                    delegate: textDelegate
                    ScrollBar.horizontal: ScrollBar{}
                    ScrollBar.vertical: ScrollBar{}
                    ScrollIndicator.horizontal: ScrollIndicator {}
                    ScrollIndicator.vertical: ScrollIndicator {}
                    clip: true

                    Component.onCompleted: {
                        completed = true
                        if (modulesCombobox.completed) {
                            updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                        }
                    }

                    Row {
                        id: componentInfoscolumnsHeader
                        y: componentInfosTableView.contentY
                        //z: 2
                        Repeater {
                            model: componentInfosTableView.columns > 0 ? componentInfosTableView.columns : 1
                            Rectangle {
                                height: 25
                                width: componentInfosTableView.width / 3 // interfacesModel.columnCount
                                color: BComStyles.darkGrey
                                BComTextStyle3 {
                                    id: componentInfostextItem
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

                    // Delegate - text items
                    Component {
                        id: textDelegate
                        Rectangle {
                            color: "transparent"
                            implicitWidth: componentInfosTableView.width / 3
                            width: componentInfosTableView.width / 3
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
            /*
        TableView {
            id : componentInfosTableView
            property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
            anchors.left: parent.left
            anchors.leftMargin: BComStyles.rightMargin
            anchors.right: componentListRect.right
            anchors.top: componentListRect.bottom
            anchors.topMargin: BComStyles.rightMargin
            sortIndicatorVisible : true
            model: componentInfosTableViewModel
            currentRow: componentInfosTableViewModel.rowCount ? 0 : -1
            rowDelegate : rowDelegateItem
            headerDelegate: headerDelegateItem
            backgroundVisible : false // fix white area at resize
            height: 250
            Component.onCompleted: {
                completed = true
                if (modulesCombobox.completed) {
                    updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
                }
            }

            // Style
            style: TableViewStyle {
                frame: Rectangle {
                    border{
                        color: BComStyles.darkGrey
                    }
                    color: BComStyles.black
                }
            }

            // Columns Defintion
            TableViewColumn {
                role: "name"
                title: "name"
                delegate: textDelegate
                Component.onCompleted: {
                    width = componentInfosTableView.width/2;
                }
                onWidthChanged: {
                    // manage minimum width
                    if (width < 200) {
                        width = 200;
                    }
                }
            }
            TableViewColumn {
                role: "description"
                title: "description"
                delegate: textDelegate
                Component.onCompleted: {
                    width = componentInfosTableView.width/2;
                }
                onWidthChanged: {
                    // manage minimum width
                    if (width < 200) {
                        width = 200;
                    }
                }
            }

            // Delegate - text items
            Component {
                id: textDelegate
                Rectangle {
                    color: "transparent"
                    BComTextStyle3
                    {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.leftMargin: BComStyles.verticalSpacing
                        text: styleData.value
                        elide: Text.ElideRight
                        color: "white"
                    }
                }
            }

            // Delegate - row height
            Component {
                id: rowDelegateItem
                Rectangle
                {
                    height: 50
                    color: "black"
                }
            }

            // Delegate - header
            Component {
                id: headerDelegateItem
                Rectangle {
                    height: textItem.implicitHeight * 1.5
                    width: textItem.implicitWidth
                    color: BComStyles.darkGrey
                    BComTextStyle3 {
                        id: textItem
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.leftMargin: 12
                        text: styleData.value
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

                    Image {
                        id: name
                        source: {
                            if (componentInfosTableView.sortIndicatorOrder === Qt.AscendingOrder) {
                                "images/chevrondown.png"
                            }
                            else {
                                "images/chevronup.png"
                            }
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        visible: {
                            styleData.column===componentInfosTableView.sortIndicatorColumn ? true: false
                        }
                    }
                }
            }

            ListModel {
                id: componentInfosTableViewModel
            }

        }*/

            //        Rectangle {
            //            id: selectedComponentListRect
            //            anchors.top:componentsLabel.bottom
            //            anchors.topMargin: BComStyles.rightMargin
            //            anchors.left: componentListRect.right
            //            anchors.leftMargin: BComStyles.rightMargin
            //            anchors.right: parent.right
            //            anchors.rightMargin: BComStyles.rightMargin
            //            height: 300
            //            width: 550
            //            //height:selectedComponentListStatus.height
            //            color : BComStyles.darkGrey

            //            // components List
            //            Component {
            //                id: selectedComponentListDelegate
            //                Item {
            //                    id : componentItemRect
            //                    width: selectedComponentList.width-selectedComponentListScrollBar.width;
            //                    height: 30
            //                    BComTextStyle3 {
            //                        id: componentItemText
            //                        text: name
            //                        color: BComStyles.white
            //                        anchors.left : parent.left
            //                        anchors.verticalCenter: parent.verticalCenter
            //                        anchors.leftMargin: 5
            //                        font.weight: Font.Light
            //                    }
            //                    MouseArea {
            //                        anchors.fill: parent
            //                        onClicked: {
            //                            selectedComponentList.currentIndex = index
            //                        }
            //                    }
            //                }
            //            }

            //            ListView {
            //                id: selectedComponentList
            //                model :appComponentModel
            //                delegate: selectedComponentListDelegate
            //                anchors.left: parent.left
            //                anchors.top:parent.top
            //                anchors.right: parent.right
            //                anchors.bottom:parent.bottom
            //                spacing:2
            //                clip: true
            //                highlight:
            //                    Rectangle {
            //                    color: BComStyles.lightGrey
            //                }
            //                focus : true

            //                onCurrentIndexChanged: {
            //                    console.log("selectedComponentList::onCurrentIndexChanged - index : " + currentIndex + " ; component : " + currentItem.name)
            //                    if (paramsTableView.completed && modulesCombobox.completed) {
            //                        updateComponentParams(appComponentModel.uuid(appComponentModel.index(selectedComponentList.currentIndex,0)))
            //                    }
            //                }
            //            }

            //            Scrollbar {
            //                id : selectedComponentListScrollBar
            //                flickable: selectedComponentList
            //            }
            //        }

            Rectangle {
                id: selectedComponentTableRect
                anchors {
                    left: componentListRect.right
                    leftMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top: componentsLabel.bottom
                    topMargin: BComStyles.rightMargin
                }
                height: 300
                //width: 550
                color : "transparent"
                border.width: 1
                border.color: BComStyles.grey

                ////////////////////
                // Selected components
                ////////////////////

                TableView {
                    id : selectedComponentTableView
                    property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
                    property var currentUUID: 0
                    anchors.fill: parent
                    anchors.leftMargin: 1
                    anchors.topMargin: 1
                    topMargin: selectedComponentcolumnsHeader.implicitHeight
                    focus: true
                    model: appComponentModel
                    delegate: selectedComponentTextDelegate
                    ScrollBar.horizontal: ScrollBar{}
                    ScrollBar.vertical: ScrollBar{}
                    ScrollIndicator.horizontal: ScrollIndicator {}
                    ScrollIndicator.vertical: ScrollIndicator {}
                    clip: true

                    Component.onCompleted: {
                    }

                    Row {
                        id: selectedComponentcolumnsHeader
                        y: selectedComponentTableView.contentY
                        //z: 2
                        Repeater {
                            model: selectedComponentTableView.columns > 0 ? selectedComponentTableView.columns : 1
                            Rectangle {
                                height: 25
                                width: selectedComponentTableView.width / 3 // interfacesModel.columnCount
                                color: BComStyles.darkGrey
                                BComTextStyle3 {
                                    id: selectedComponenttextItem
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.leftMargin: 12
                                    text: appComponentModel.headerData(modelData, Qt.Horizontal)
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
                        id: selectedComponentTextDelegate
                        Rectangle {
                            id: selectedComponentDelegateRect
                            color: "transparent"
                            implicitWidth: selectedComponentTableView.width / 3
                            width: selectedComponentTableView.width / 3
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
                                    if (mouse.button & Qt.LeftButton) {
                                        console.log( "Clicked" + rowText.text + appComponentModel.uuid(appComponentModel.index(row,0)))
                                        updateComponentParams(appComponentModel.uuid(appComponentModel.index(row,0)))
                                        //modulesStack.currentIndex = 1
                                    }
                                }
                            }
                        }
                    }
                }

                // Delegate - text items
                //                Component {
                //                    id: removeComponentDelegate
                //                    Rectangle {
                //                        color: "transparent"

                //                        BComButton {
                //                            Image {source:"images/trashpicto.png"
                //                                anchors.centerIn: parent
                //                                scale:  0.45}
                //                            id:removeComponentButton
                //                            anchors.centerIn: parent
                //                            buttonColor : "black"
                //    //                        bCenterText: true
                //                            width: 35
                //                            onClicked:  {
                //                                user.unpickComponent(styleData.value,appComponentModel.index(selectedComponentTableView.currentIndex,0));
                //                            }

                //                            Component.onCompleted: {
                //                                removeComponentButton.enabled = true;
                //                            }
                //                            tooltip: "delete module from list"
                //                        }
                //                    }
                //                }

            }

            // Separator
            Rectangle {
                id: separatorRect
                anchors.left: selectedComponentTableRect.right
                anchors.leftMargin: BComStyles.HorizontalComponentMargin
                anchors.top: selectedComponentTableRect.bottom
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

            StackLayout {
                id: paramsStack
                anchors {
                    left: componentListRect.right
                    leftMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top: parametersLabel.bottom
                    topMargin: BComStyles.rightMargin
                    bottom: parent.bottom
                    bottomMargin: BComStyles.rightMargin
                }

                Rectangle {
                    id: paramsTableViewBorderRect
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color : "transparent"
                    border.width: 1
                    border.color: BComStyles.grey

                    TableView {
                        id : paramsTableView
                        property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
                        property var currentName: 0
                        anchors.fill: parent
                        anchors.leftMargin: 1
                        anchors.topMargin: 1
                        topMargin: paramscolumnsHeader.implicitHeight
                        focus: true
                        model: parametersModel
                        delegate: paramsTextDelegate
                        ScrollBar.horizontal: ScrollBar{}
                        ScrollBar.vertical: ScrollBar{}
                        ScrollIndicator.horizontal: ScrollIndicator {}
                        ScrollIndicator.vertical: ScrollIndicator {}
                        clip: true

                        Component.onCompleted: {
                            completed = true
                            if (modulesCombobox.completed) {
                                updateComponentParams(selectedComponentTableView.currentUUID)
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
                                implicitWidth: paramsTableView.width / 3
                                width: paramsTableView.width / 3
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
                                        if (mouse.button & Qt.LeftButton) {
                                            console.log( "Clicked" + rowText.text + parametersModel.uuid(parametersModel.index(row,0)))
                                            paramsTableView.currentName = parametersModel.uuid(parametersModel.index(row,0))
                                            paramsStack.currentIndex = 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Frame {
                    id: paramFrame
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop | Qt.AlignBottom
                    Layout.topMargin: BComStyles.verticalSpacing

                    BComButton {
                        id:closeFrameButton
                        anchors.right: parent.right
                        height: 40
                        enabled:true
                        width:90
                        buttonColor : "blue"
                        text:"Close"
                        onClicked: {
                            paramsStack.currentIndex = 0
                        }
                        tooltip: "Close"
                    }
                    Text {
                        text: paramsTableView.currentName
                        color: BComStyles.white
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
        if (paramsTableView.completed && modulesCombobox.completed) {
            updateComponentParams(selectedComponentTableView.currentUUID)
        }
        if (componentInfosTableView.completed  && modulesCombobox.completed) {
            updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
        }
    }
}
