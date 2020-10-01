import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "BComStyles.js" as BComStyles
import SortFilterProxyModel 0.1

Rectangle {
    id: modulesRootWidget
    objectName: "modulesRootWidget"
    color: BComStyles.darkGrey

    // Ciphered image for overlay
    property alias pictureOverlaySource : picture.source

    function addModule(name,path,uuid) {
       // moduleTableViewModel.append({name: name, path: path, uuid: uuid})
    }

    function removeModule(uuid) {
        // search index of current image
      /*  for (var i= 0 ; i <moduleTableViewModel.count; i++ )
        {
            if (moduleTableViewModel.get(i).name === uuid)
            {
                console.log("remove " + uuid +  "; index : " + i );
                moduleTableViewModel.remove(i);
                break;
            }
        }*/
    }

    function updateModules()
    {
       // moduleTableViewModel.clear();
        user.getModules();
    }

    function updateHelpText4()
    {

            help.text4 = "Help text 4"
            help.text4XPart = widgetRect.x + borderRect.x + modulesTableView.x
            help.text4YPart = widgetRect.y + borderRect.y + modulesTableView.y + 25

    }

    BComMenuBar {
        id: menuBar
        productTitle: "*" + appTitle + "*"
        currentTitle: "/ home"
        helpEnabled: true
        paramEnabled: true
        closeEnabled: true
        interfacesEnabled: true
        componentsEnabled: true
        configuratorEnabled: true
        modulesEnabled: false
    }

    ////////////////////
    // Overlay
    ////////////////////
    Rectangle {
        id:overlayRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: BComStyles.rightMargin
        anchors.rightMargin: BComStyles.rightMargin
        anchors.top:menuBar.bottom
        anchors.topMargin: BComStyles.rightMargin
        anchors.bottom: parent.bottom
        color:"black"
        visible : false

        // Close button
        Rectangle {
            id: closeButtonRect
            anchors.left: parent.left
            anchors.leftMargin: BComStyles.rightMargin
            anchors.right: parent.right
            anchors.top:parent.top
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
                    modulesRootWidget.pictureOverlaySource = "image://imageOverlayProvider/"
                    overlayRect.visible = false
                    widgetRect.visible = true

                    menuBar.componentsEnabled=true;
                    menuBar.paramEnabled=true;
                }

                Component.onCompleted: {
                    closebuttonimage.enabled = true;
                }
                tooltip: "close view"
            }
        }

        Rectangle {
            id: contentRect
            anchors.left: parent.left
            anchors.leftMargin: BComStyles.rightMargin
            anchors.right: parent.right
            anchors.rightMargin: BComStyles.rightMargin
            anchors.top:closeButtonRect.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: BComStyles.rightMargin
            color:"transparent"

            // manage image in a rectangle - allow to scale and place correctly
            Rectangle {
                id: pictureRect
                anchors.centerIn: parent
                color : "transparent"
                width : picture.width*picture.scale
                height : picture.height*picture.scale

                Image {
                    id: picture
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    cache: false // fix remove file in the ImageOverlayProvider::requestImage
                    scale : {
                        Math.min (contentRect.width/sourceSize.width,
                                  contentRect.height/ sourceSize.height)
                    }
                    antialiasing: true
                }
            }
        }

        onVisibleChanged: {
            if (visible) {
                menuBar.componentsEnabled=false;
                menuBar.paramEnabled=false;
            }
        }
    }

    ////////////////////
    // drop and module list
    ////////////////////
    Rectangle {
        id:widgetRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: BComStyles.rightMargin
        anchors.rightMargin: BComStyles.rightMargin
        anchors.top:menuBar.bottom
        anchors.topMargin:5
        anchors.bottom: parent.bottom
        color:"black"


        ////////////////////
        // drop for modules
        ////////////////////

        BComDropComponent {
            id : dropWidget
            text : "> drop an XPCF module file to introspect here"
            anchors.left: parent.left
            anchors.leftMargin: BComStyles.rightMargin
            anchors.right: parent.right
            anchors.rightMargin: BComStyles.rightMargin
            anchors.top: parent.top
            anchors.topMargin: BComStyles.rightMargin
            imagepicto : "images/folder_red.png"
            height:60
        }

        Rectangle {
            id: borderRect
            anchors.left: dropWidget.left
            anchors.right: dropWidget.right
            anchors.top:dropWidget.bottom
            anchors.bottom:parent.bottom
            anchors.bottomMargin: BComStyles.rightMargin

            color : BComStyles.black
            border.width: 1
            border.color: BComStyles.darkGrey

            ////////////////////
            // modules
            ////////////////////

            TableView {
                id : modulesTableView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: BComStyles.verticalSpacing
                anchors.bottom: parent.bottom
                sortIndicatorVisible : true
                model: modulesModel
                currentRow: modulesModel.rowCount ? 0 : -1
                rowDelegate : rowDelegateItem
                headerDelegate: headerDelegateItem
                backgroundVisible : false // fix white area at resize
                focus: true

                Component.onCompleted: {
                    updateModules();
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
                    role: 'name'
                    title: "name"
                    delegate: textDelegate
                    Component.onCompleted: {
                        width = modulesTableView.width/3;
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
                    title: "path"
                    delegate: textDelegate
                    Component.onCompleted: {
                        width = modulesTableView.width/3;
                    }
                    onWidthChanged: {
                        // manage minimum width
                        if (width < 100) {
                            width = 100;
                        }
                    }
                }
                TableViewColumn {
                    role: "uuid"
                    title: "UUID"
                    delegate: textDelegate
                    Component.onCompleted: {
                        width = modulesTableView.width/3;
                    }
                    onWidthChanged: {
                        // manage minimum width
                        if (width < 100) {
                            width = 100;
                        }
                    }
                }

                TableViewColumn {
                    role: "name"
                    title: ""
                    delegate: removeModuleDelegate
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
                // Sort
//                model: SortFilterProxyModel {
//                        id: proxyModel
//                        source: modulesModel.count > 0 ? modulesModel : null
//                   //     sortOrder: modulesModel.sortIndicatorOrder
//                        sortCaseSensitivity: Qt.CaseInsensitive
//                        sortRole: {
//                            // manage sort of last column (remove 'image') with data of first column
//                            var sortIndicatorColumn = modulesTableView.sortIndicatorColumn;
//                            if (modulesModel.sortIndicatorColumn === modulesModel.columnCount-1) {
//                                sortIndicatorColumn = 0;
//                            }
//                            modulesModel.count > 0 ? modulesModel.getColumn(sortIndicatorColumn).role : ""
//                        }
//                }

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
                            text: styleData.value.toLocaleString(Qt.locale(),("yyyy-MM-dd"))
                            elide: Text.ElideRight
                            color: "white"
                        }
                    }
                }

                // Delegate - text items
                Component {
                    id: removeModuleDelegate
                    Rectangle {
                        color: "transparent"

                        BComButton {
                            Image {source:"images/trashpicto.png"
                                   anchors.centerIn: parent
                                   scale:  0.45}
                            id:removeModuleButton
                            anchors.centerIn: parent
                            buttonColor : "black"
                            bPictoBefore: false
                            bCenterText: true
                            width: 35
                            onClicked:  {
                                user.removeModule(modulesModel.index(modulesTableView.currentIndex,0));
                            }

                            Component.onCompleted: {
                                removeModuleButton.enabled = true;
                            }
                            tooltip: "delete module from list"
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
                                if (modulesTableView.sortIndicatorOrder === Qt.AscendingOrder) {
                                    "images/chevrondown.png"
                                }
                                else {
                                    "images/chevronup.png"
                                }
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            visible: {
                                styleData.column===modulesTableView.sortIndicatorColumn ? true: false
                            }
                        }
                    }
                }
            }

            // modulesTableView model
//            ListModel {
//                //id: moduleTableViewModel
//                id: modulesModel
//                onCountChanged: {
//                    console.log("inserted - index : " + currentIndex + " ; component : " + currentItem.name)

//                }
//onDataChanged: {
//    console.log("inserted - index : " + currentIndex + " ; component : " + currentItem.name)
//}
//                onRowsInserted:
//                {
//                    console.log("inserted - index : " + currentIndex + " ; component : " + currentItem.name)
//                }
//            }
        }
    }

    Help {
        id:help
        visible:false;
        bHelp1Visible : true
        bHelp3Visible : true
        text1 : "Drop an XPCF module to introspect it"
        text3 : "Display module list by name"
        text1XPart : dropWidget.x + 30
        text1YPart : widgetRect.y + dropWidget.y + 10
        text3XPart : dropWidget.x + 30
        text3YPart : widgetRect.y + dropWidget.y + dropWidget.height + 45

        bHelpCustom1Visible : true
        textCustom1: "display\nmodule\ncomponents"
        textCustom1XPart: parent.width-765
        textCustom1YPart: menuBar.height -20

        bHelpCustom3Visible : true
        textCustom3: "define\ndefault\nparameters"
        textCustom3XPart: parent.width - 255
        textCustom3YPart: menuBar.height - 20
    }

    Component.onCompleted: {
        modulesTableView.visible = rootWidget.displayModules;
        updateHelpText4();
    }
}
