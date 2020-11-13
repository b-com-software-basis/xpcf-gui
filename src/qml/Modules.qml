import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.qmlmodels 1.0
import "BComStyles.js" as BComStyles
import SortFilterProxyModel 0.1

Rectangle {
    id: modulesRootWidget
    objectName: "modulesRootWidget"
    color: BComStyles.darkGrey

    property bool completed: false
    property bool displayHelp : false
    property bool closeHelp : false

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

    ColumnLayout {
        anchors.fill: parent
        Layout.fillWidth: true
        spacing: 0

        Rectangle {
            id: titleRect
            color:BComStyles.darkGrey
            height: 48
        }

        ////////////////////
        // drop and module list
        ////////////////////
        Rectangle {
            id:widgetRect
            Layout.fillWidth: true
            Layout.fillHeight: true
            color:"black"

            BComDropComponent {
                id : dropWidget
                text : "> drop an XPCF module file to introspect here"
                anchors {
                    left: parent.left
                    leftMargin: BComStyles.rightMargin
                    right: parent.right
                    rightMargin: BComStyles.rightMargin
                    top: parent.top
                    topMargin: BComStyles.rightMargin
                }
                imagepicto : "images/folder_red.png"
                height:60
            }

            Rectangle {
                id: borderRect
                anchors {
                    left: dropWidget.left
                    right: dropWidget.right
                    top:dropWidget.bottom
                    bottom:parent.bottom
                    bottomMargin: BComStyles.rightMargin
                }
                color : BComStyles.black
                border.width: 1
                border.color: BComStyles.darkGrey

                Rectangle {
                    id: tableviewBorderRect
                    anchors.fill: parent
                    anchors.topMargin: BComStyles.verticalSpacing
                    color : "transparent"
                    border.width: 1
                    border.color: BComStyles.grey

                    ////////////////////
                    // modules
                    ////////////////////
                    TableView {
                        id : modulesTableView
                        property var currentUUID: 0
                        anchors.fill: parent
                        anchors.leftMargin: 1
                        anchors.topMargin: 1
                        topMargin: columnsHeader.implicitHeight
                        model: modulesModel
                        focus: true
                        delegate: textDelegate

                        Row {
                            id: columnsHeader
                            y: modulesTableView.contentY
                            //z: 2
                            Repeater {
                                model: modulesTableView.columns > 0 ? modulesTableView.columns : 1
                                Rectangle {
                                    height: 25
                                    width: modulesTableView.width / 3 // modulesModel.columnCount
                                    color: BComStyles.darkGrey
                                    BComTextStyle3 {
                                        id: textItem
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        anchors.leftMargin: 12
                                        text: modulesModel.headerData(modelData, Qt.Horizontal)
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
                            updateModules();
                        }
                        // Delegate - text items
                        Component {
                            id: textDelegate
                            Rectangle {
                                color: "transparent"
                                implicitWidth: modulesTableView.width / 3
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
            }
        }
    }



    Help {
        id:help
        visible:false;
        bHelp1Visible : true
        bHelp2Visible : true
        text1 : "Drop an XPCF module to introspect it"
        text2 : "Display module list by name"
        text1XPart : dropWidget.x + 30
        text1YPart : widgetRect.y + dropWidget.y + 10
        text2XPart : text1XPart
        text2YPart : widgetRect.y + borderRect.y + 45

        bHelpCustom1Visible : true
        textCustom1: "display\nmodule\ncomponents"
        textCustom1XPart: parent.width-730
        textCustom1YPart: -15

        bHelpCustom2Visible : true
        textCustom2: "define\ndefault\nparameters"
        textCustom2XPart: parent.width - 220
        textCustom2YPart: -15

        onHelpVisibleChanged: {
            if (help.helpVisible == false) {
                closeHelp = true
            }
        }
    }

    Component.onCompleted: {
        completed = true
        //modulesTableView.visible = rootWidget.displayModules;
        updateHelpText4();
    }

    onDisplayHelpChanged: {
        help.visible = displayHelp
        help.helpVisible = displayHelp
    }
}
