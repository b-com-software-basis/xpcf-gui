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

    ////////////////////
    // drop and module list
    ////////////////////
    Rectangle {
        id:widgetRect
        anchors {
            left: parent.left
            right: parent.right
            top:parent.top
            bottom: parent.bottom
        }
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
                console.log("You chose: " + fileDialog.fileUrls)
            }
            onRejected: {
                console.log("Canceled")
            }
        }

        BComButton {
            id:loadModulesButton
            enabled:true
            height: 40
            width:110
            buttonColor : "blue"
            text:"Load modules from folder"
            onClicked: {
                fileDialog.visible = true
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
}
