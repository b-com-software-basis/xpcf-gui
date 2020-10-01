import QtQuick 2.3
import QtQuick.Controls 1.4
import "BComStyles.js" as BComStyles

Rectangle {
    id: root
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    color:"transparent"
    height:40
    BComButton {
        id:snippetButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 2
        width:100
        buttonColor : "green"
        text:"Code snippet"
        bCenterText: true
        onClicked: {
            user.generateSnippet()
        }
        tooltip: "Code snippet"
    }
    BComButton {
        id:saveButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: snippetButton.left
        anchors.rightMargin: 2
        width:100
        buttonColor : "green"
        text:"Save"
        bCenterText: true
        onClicked: {
            user.save()
        }
        tooltip: "Save configuration"
    }
    BComButton {
        id:loadButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: saveButton.left
        anchors.rightMargin: 2
        width:100
        buttonColor : "blue"
        text:"Load"
        bCenterText: true
        onClicked: {
            user.load()
        }
        tooltip: "Load existing configuration"
    }
    BComButton {
        id:newButton
        enabled:true
        bPictoBefore: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: loadButton.left
        anchors.rightMargin: 2
        width:100
        buttonColor : "purple"
        text:"New"
        bCenterText: true
        onClicked: {
            user.newConfiguration()
        }
        tooltip: "Create new configuration"
    }
}
