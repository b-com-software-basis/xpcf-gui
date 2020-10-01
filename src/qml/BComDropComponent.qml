import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3
import Qt.labs.folderlistmodel 2.1

import "BComStyles.js" as BComStyles

Rectangle {
    id: root
    property alias text : titleText.text
    property alias imagepicto : titleText.source
    property alias bPictoBefore : titleText.bPictoBefore
    enabled : true
    color:"transparent"

    property string imagePath : ""

    BComTextBlock {
        id:titleText
        enabled:true
        anchors.fill: parent;
        bCenterText : true
        color:BComStyles.darkGrey
        text:""
        textFontSize: 30
        imageWidth:40
        imageHeight:40
    }


    DropArea {
        id: dropArea;
        anchors.fill: parent;
        property string filepath:""
        onEntered: {
            titleText.color = BComStyles.blue;
            drag.accept (Qt.CopyAction);
            if(drag.urls[0]) {
                filepath=(drag.urls[0]);
            }
            console.log("onEntered ");
        }
        onDropped: {
            titleText.color = BComStyles.darkGrey;
            console.log ("onDropped " + filepath);
            user.addModule(filepath)
            modulesTableView.update()
        }
        onExited: {
            titleText.color = BComStyles.darkGrey;
            console.log ("onExited ");
        }
    }
}
