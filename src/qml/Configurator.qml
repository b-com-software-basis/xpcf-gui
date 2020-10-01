import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import "BComStyles.js" as BComStyles
import SortFilterProxyModel 0.1

Rectangle {
    id: configuratorRootWidget
    objectName: "configuratorRootWidget"
    color: BComStyles.darkGrey

    function addComponentInfos(uuid,name) {
        // int conversion (for sort on integer)
        componentInfosTableViewModel.append({uuid: uuid, name: name})
    }

    function getComponents(moduleName) {
        user.getComponents(moduleName)
    }

    function addComponentParams(name,type,values) {
        // int conversion (for sort on integer)
        paramsTableViewModel.append({name: name, type: type, values:values})
    }

    function updateComponentParams(uuid) {
        paramsTableViewModel.clear();
        user.getComponentParams(uuid)
    }

    function updateUnshareAllPicturesBtnState() {
        unshareAllPicturesBtn.enabled = componentInfosTableViewModel.count > 0
    }

    BComMenuBar {
        id: menuBar
        productTitle: "*" + appTitle + "*"
        currentTitle: "/ configurator"
        helpEnabled: true
        paramEnabled: true
        closeEnabled: true
        interfacesEnabled: true
        componentsEnabled: true
        configuratorEnabled: false
        modulesEnabled: true
    }

    BComTextBlock {
        id:modulesComboboxLabel
        enabled:true
        bPictoBefore: false
        anchors.top: menuBar.bottom
        anchors.topMargin: BComStyles.rightMargin
        anchors.left: parent.left
        bCenterText : false
        color:BComStyles.darkGrey
        text:"Select module:"
        textFontSize: 30
        imageWidth:40
        imageHeight:40
    }

    ComboBox {
        id: modulesCombobox
        property bool completed: false
        textRole: "name"
        anchors.verticalCenter: modulesComboboxLabel.verticalCenter
        anchors.left: modulesComboboxLabel.right
        anchors.leftMargin: 300
        visible:true
        editable: true
        width: 250
        height:30
        model: modulesModel
        style: ComboBoxStyle {
            background: Rectangle {
                id: rectwkeybox
                border.width: 2
                border.color: BComStyles.darkGrey
                color: BComStyles.white

                Image {
                    source: "Parameters_images/keycomboboxselectorpicto.png"
                    anchors.right: parent.right
                    anchors.rightMargin: -5}

            }

            label: BComTextStyle3 {

                horizontalAlignment: parent.AlignHCenter
                anchors.leftMargin: 10
                font.weight: Font.Light
                color: BComStyles.white
                text: modulesCombobox.currentText
            }
        }
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
    }

    // component list
    Rectangle {
        id: contentRect
        anchors.left: parent.left
        anchors.leftMargin: BComStyles.rightMargin
        anchors.right: parent.right
        anchors.rightMargin: BComStyles.rightMargin
        anchors.top:modulesComboboxLabel.bottom
        anchors.topMargin: BComStyles.rightMargin
        anchors.bottom: parent.bottom
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

        ConfiguratorToolBar {
            id: configuratorToolBar
            anchors.top: parent.top
            anchors.topMargin: BComStyles.rightMargin
            anchors.right: buttonBarRect.left
            anchors.rightMargin: BComStyles.rightMargin
            visible: true
        }

        BComButton {
            id:pickButton
            enabled:true
            bPictoBefore: false
            anchors.bottom: componentListRect.top
            anchors.bottomMargin: 10
            anchors.left: componentListRect.right
            anchors.leftMargin: -40
            width:130
            buttonColor : "blue"
            text:"-- pick ->"
            onClicked: {
                user.pickComponent(modulesModel.uuid(modulesModel.index(modulesCombobox.currentIndex,0)),componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
            }
            tooltip: "pick a component"
        }

        // buttons refresh/close
        Rectangle {
            id: buttonBarRect
            //            anchors.left: parent.left
            //            anchors.leftMargin: BComStyles.rightMargin
            anchors.right: parent.right
            anchors.rightMargin: BComStyles.rightMargin
            anchors.top:parent.top
            width: refreshButton.width
            color:"transparent"
            height : 60

            BComButton {
                Image {source:"images/refreshbuttonimage.png"
                    anchors.centerIn: parent}
                id:refreshButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.right : parent.right
                width:35
                height:35
                buttonColor : "black"
                bPictoBefore: false
                bCenterText: true

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
                        componentInfosTableViewModel.clear();
                        componentInfosTableViewModel.append({name: componentModel.element(currentIndex).name, description: componentModel.element(currentIndex).description} )
                    }
                }
            }

            Scrollbar {
                id : componentListScrollBar
                flickable: componentList
            }
        }

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

        }

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
            anchors.top:componentsLabel.bottom
            anchors.topMargin: BComStyles.rightMargin
            anchors.left: componentListRect.right
            anchors.leftMargin: BComStyles.rightMargin
            anchors.right: parent.right
            anchors.rightMargin: BComStyles.rightMargin
            height: 300
            width: 550
            color : BComStyles.black
            border.width: 1
            border.color: BComStyles.darkGrey

            ////////////////////
            // Selected components
            ////////////////////

            TableView {
                id : selectedComponentTableView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: BComStyles.verticalSpacing
                anchors.bottom: parent.bottom
                sortIndicatorVisible : true
                model: appComponentModel
                currentRow: appComponentModel.rowCount ? 0 : -1
                rowDelegate : selectedComponentRowDelegateItem
                headerDelegate: selectedComponentHeaderDelegateItem
                backgroundVisible : false // fix white area at resize
                focus: true

                Component.onCompleted: {
                }

                // Style
                /*style: TableViewStyle {
                    frame: Rectangle {
                        border.color: BComStyles.darkGrey
                        color: BComStyles.black
                    }
                }*/

                // Columns Defintion
                TableViewColumn {
                    role: "description"
                    title: "module UUID"
                    delegate: selectedComponentTextDelegate
                    Component.onCompleted: {
                        width = selectedComponentTableView.width/3;
                    }
                    onWidthChanged: {
                        // manage minimum width
                        if (width < 100) {
                            width = 100;
                        }
                    }
                }

                TableViewColumn {
                    role: 'name'
                    title: "name"
                    delegate: selectedComponentTextDelegate
                    Component.onCompleted: {
                        width = selectedComponentTableView.width/3;
                    }
                    onWidthChanged:
                    {   // manage minimum width
                        if (width < 150) {
                            width = 150;
                        }
                    }
                }

                TableViewColumn {
                    role: "description"
                    title: ""
                    delegate: removeComponentDelegate
                    Component.onCompleted: {
                        width = 0;
                    }
                    onWidthChanged: {
                        // manage minimum width
                        if (width < 50) {
                            width = 50;
                        }
                    }
                }

                // Delegate - text items
                Component {
                    id: selectedComponentTextDelegate
                    Rectangle {
                        color: "transparent"
                        BComTextStyle3
                        {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.leftMargin: BComStyles.verticalSpacing
                            text: styleData.value.toLocaleString(Qt.locale(),("yyyy-MM-dd"))
                            elide: Text.ElideRight
                            color: "white"
                        }
                    }
                }

                // Delegate - text items
                Component {
                    id: removeComponentDelegate
                    Rectangle {
                        color: "transparent"

                        BComButton {
                            Image {source:"images/trashpicto.png"
                                anchors.centerIn: parent
                                scale:  0.45}
                            id:removeComponentButton
                            anchors.centerIn: parent
                            buttonColor : "black"
                            bPictoBefore: false
                            bCenterText: true
                            width: 35
                            onClicked:  {
                                user.unpickComponent(styleData.value,appComponentModel.index(selectedComponentTableView.currentIndex,0));
                            }

                            Component.onCompleted: {
                                removeComponentButton.enabled = true;
                            }
                            tooltip: "delete module from list"
                        }
                    }
                }

                // Delegate - row height
                Component {
                    id: selectedComponentRowDelegateItem
                    Rectangle
                    {
                        height: 50
                        color: "black"
                    }
                }

                // Delegate - header
                Component {
                    id: selectedComponentHeaderDelegateItem
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
                                if (selectedComponentTableView.sortIndicatorOrder === Qt.AscendingOrder) {
                                    "images/chevrondown.png"
                                }
                                else {
                                    "images/chevronup.png"
                                }
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            visible: {
                                styleData.column===selectedComponentTableView.sortIndicatorColumn ? true: false
                            }
                        }
                    }
                }
            }
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
            bPictoBefore: false
            anchors.top: separatorRect.bottom
            anchors.topMargin: BComStyles.rightMargin
            anchors.left: componentListRect.right
            anchors.leftMargin: BComStyles.rightMargin
            bCenterText : false
            color:BComStyles.darkGrey
            text:"Component parameters :"
            textFontSize: 20
            imageWidth:40
            imageHeight:40
        }

        TableView {
            id : paramsTableView
            property bool completed: false // added this property bool in order to sort only when compoent if completely loaded
            anchors.left: componentListRect.right
            anchors.leftMargin: BComStyles.rightMargin
            anchors.right: parent.right
            anchors.rightMargin: BComStyles.rightMargin
            anchors.top: parametersLabel.bottom
            anchors.topMargin: BComStyles.rightMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: BComStyles.rightMargin
            sortIndicatorVisible : true
            currentRow: rowCount ? 0 : -1
            rowDelegate : paramsRowDelegateItem
            headerDelegate: paramsHeaderDelegateItem
            backgroundVisible : false // fix white area at resize

            Component.onCompleted: {
                completed = true
                if (modulesCombobox.completed) {
                    updateComponentParams(appComponentModel.uuid(appComponentModel.index(selectedComponentList.currentIndex,0)))
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
                delegate: paramsTextDelegate
                Component.onCompleted: {
                    width = paramsTableView.width/3;
                }
                onWidthChanged:
                {   // manage minimum width
                    if (width < 150) {
                        width = 150;
                    }
                }
            }
            TableViewColumn {
                role: "type"
                title: "type"
                delegate: paramsTextDelegate
                Component.onCompleted: {
                    width = paramsTableView.width/3;
                }
                onWidthChanged: {
                    // manage minimum width
                    if (width < 80) {
                        width = 80;
                    }
                }
            }
            TableViewColumn {
                role: "values"
                title: "values"
                delegate: paramsTextDelegate
                Component.onCompleted: {
                    width = paramsTableView.width/3;
                }
                onWidthChanged: {
                    // manage minimum width
                    if (width < 80) {
                        width = 80;
                    }
                }
            }

            // Sort
            model: SortFilterProxyModel {
                id: paramsProxyModel
                source: paramsTableViewModel.count > 0 ? paramsTableViewModel : null
                sortOrder: paramsTableView.sortIndicatorOrder
                sortCaseSensitivity: Qt.CaseInsensitive
                sortRole: {
                    // manage sort of last column (remove 'image') with data of first column
                    var sortIndicatorColumn = paramsTableView.sortIndicatorColumn;
                    if (paramsTableView.sortIndicatorColumn === paramsTableView.columnCount-1) {
                        sortIndicatorColumn = 0;
                    }
                    paramsTableViewModel.count > 0 ? paramsTableView.getColumn(sortIndicatorColumn).role : ""
                }
            }

            // Delegate - text items
            Component {
                id: paramsTextDelegate
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
                id: paramsRowDelegateItem
                Rectangle
                {
                    height: 50
                    color: "black"
                }
            }

            // Delegate - header
            Component {
                id: paramsHeaderDelegateItem
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
                            if (paramsTableView.sortIndicatorOrder === Qt.AscendingOrder) {
                                "images/chevrondown.png"
                            }
                            else {
                                "images/chevronup.png"
                            }
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        visible: {
                            styleData.column===paramsTableView.sortIndicatorColumn ? true: false
                        }
                    }
                }
            }
            ListModel {
                id: paramsTableViewModel
                onCountChanged: {
                    saveButton.enabled = paramsTableViewModel.count > 0
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
            updateComponentParams(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
        }
        if (componentInfosTableView.completed  && modulesCombobox.completed) {
            updateComponentInfos(componentModel.uuid(componentModel.index(componentList.currentIndex,0)))
        }
    }
}
