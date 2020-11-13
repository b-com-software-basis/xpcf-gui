import QtQuick 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

//import QtQuick.Controls.Styles 1.4
import "BComStyles.js" as BComStyles
import SortFilterProxyModel 0.1

Rectangle {
    id: homeRootWidget
    objectName: "modulesRootWidget"
    color: BComStyles.darkGrey

    property bool completed: false
    property bool displayHelp : false
    property bool closeHelp : false

    Component.onCompleted: {
        completed = true
    }

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


            FileDialog {
                id: fileDialog
                title: "Please choose a folder to load XPCF modules from"
                folder: shortcuts.home
                selectFolder: true
                sidebarVisible: true
                onAccepted: {
                    console.log("You chose: " + fileDialog.fileUrl)
                    user.loadModules(fileDialog.fileUrl,true)
                }
                onRejected: {
                    console.log("Canceled")
                }
            }

            BComButton2 {
                id:loadModulesButton
                buttonColor: "grey"
                enabled:true
                anchors {
                    left: parent.left
                    leftMargin: BComStyles.rightMargin
                    top: dropWidget.bottom
                    topMargin: BComStyles.rightMargin
                }
                height: 40
                width:300
                text:"Load modules from folder"
                onClicked: {
                    fileDialog.visible = true
                }
                tooltip: "Load modules from folder"
            }
        }
    }

    Help {
        id:help
        visible:false
        bHelp1Visible : true
        bHelp2Visible : true
        text1 : "Drop an XPCF module to introspect it"
        text2 : "Open a folder containing XPCF modules (recursive)"
        text1XPart : dropWidget.x + 30
        text1YPart : widgetRect.y + dropWidget.y + 10
        text2XPart : loadModulesButton.x + 30
        text2YPart : widgetRect.y + loadModulesButton.y

        bHelpCustom1Visible : true
        textCustom1: "display\nhome"
        textCustom1XPart: parent.width-920
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

    onDisplayHelpChanged: {
        help.visible = displayHelp
        help.helpVisible = displayHelp
    }
}
