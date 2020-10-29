import QtQuick 2.3
import QtQuick.Controls 1.4
import "BComStyles.js" as BComStyles

Rectangle {
    id: root
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height:40
    color:"transparent"

    BComButton2 {
        id:snippetButton
        enabled: true
        buttonColor: "grey"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 2
        width : 150
        text:"Code snippet"
        onClicked: {
            user.generateSnippet()
        }
        tooltip: "Code snippet"
    }

    BComButton2 {
        id:saveButton
        enabled:true
        buttonColor : "grey"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: snippetButton.left
        anchors.rightMargin: 2
        width:100
        text:"Save"
        onClicked: {
            user.save()
        }
        tooltip: "Save configuration"
    }
    BComButton2 {
        id:loadButton
        enabled:true
        buttonColor : "grey"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: saveButton.left
        anchors.rightMargin: 2
        width:100
        text:"Load"
        onClicked: {
            user.load()
        }
        tooltip: "Load existing configuration"
    }
    BComButton2 {
        id:newButton
        enabled:true
        buttonColor : "grey"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: loadButton.left
        anchors.rightMargin: 2
        width:100
        text:"New"
        onClicked: {
            user.newConfiguration()
        }
        tooltip: "Create new configuration"
    }
}
