import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles
import SortFilterProxyModel 0.1

Rectangle {
    id: modulesRootWidget
    objectName: "modulesRootWidget"
    //   border.width: 5
    //  border.color: BComStyles.blue

    color: BComStyles.darkGrey

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

                ////////////////////
                // modules
                ////////////////////
                StackLayout {
                    id: modulesStack
                    anchors.fill: parent
                    TableView {
                        id : modulesTableView

                        property var currentUUID: 0
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop | Qt.AlignBottom
                        Layout.topMargin: BComStyles.verticalSpacing
                        /*anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: BComStyles.verticalSpacing
                        anchors.bottom: parent.bottom*/

                        //sortIndicatorVisible : true
                        model: modulesModel
                        // currentRow: modulesModel.rowCount ? 0 : -1
                        // rowDelegate : rowDelegateItem
                        // headerDelegate: headerDelegateItem

                        focus: true
                        delegate: textDelegate

                        Component.onCompleted: {
                            updateModules();
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
                    Frame {
                        id: moduleFrame
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
                                modulesStack.currentIndex = 0
                            }
                            tooltip: "select and display modules"
                        }
                        Text {
                            text: modulesTableView.currentUUID
                            color: BComStyles.white
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
        //modulesTableView.visible = rootWidget.displayModules;
        updateHelpText4();
    }
}
