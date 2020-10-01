import QtQuick 2.3
import QtQuick.Controls 1.4
import "BComStyles.js" as BComStyles

Rectangle {
    id: root
    property bool bPictoBefore : true
    property bool bCenterText : false
    property bool labelVerticalCentered : true
    property bool pictoVerticalCentered : true
    property string textColor : "white"
    color: BComStyles.grey
    property alias source : imgPicto.source
    property alias imageWidth : imgPicto.width
    property alias imageHeight : imgPicto.height
    property alias text : textLabel.text
    property alias textFontSize : textLabel.font.pixelSize
    property alias textFontFamily : textLabel.font.family
    property alias textFontWeight : textLabel.font.weight
    property alias textWrapMode : textLabel.wrapMode
    property alias textWidth : textLabel.width
    property alias textHorizontalAlignment : textLabel.horizontalAlignment
    property alias textVerticalAlignment : textLabel.verticalAlignment



    Rectangle {
        id: blockRect
        anchors.left:parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        height: (imgPicto.height > textLabel.height ? imgPicto.height : textLabel.height)
        width: imgPicto.width + 25 + textLabel.width
        color:"transparent"
        Image {
            id: imgPicto
            width:18
            height:18
            visible:true
            source:""
        }
        BComTextStyle3 {
            id: textLabel
            anchors.left : imgPicto.right
            anchors.leftMargin : BComStyles.leftTextMargin
            color: textColor
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    onBPictoBeforeChanged: {
        if (bPictoBefore) {
            if (imgPicto.status !== Image.Null) {
                imgPicto.anchors.left = blockRect.left
                imgPicto.anchors.leftMargin = 0
                textLabel.anchors.left = imgPicto.right
                textLabel.anchors.leftMargin = BComStyles.leftTextMargin
             }
            else {
                textLabel.anchors.left = blockRect.left
                textLabel.anchors.leftMargin = 0
           }
        }
        else {
            textLabel.anchors.left = blockRect.left
            textLabel.anchors.leftMargin = 0
            if (imgPicto.status !== Image.Null) {
                imgPicto.anchors.left = textLabel.right
                imgPicto.anchors.leftMargin = 25
            }
        }
    }
    onBCenterTextChanged: {
        if (bCenterText) {
            blockRect.anchors.left = undefined
            blockRect.anchors.leftMargin = undefined
            blockRect.anchors.horizontalCenter = root.horizontalCenter
        }
        else {
            blockRect.anchors.horizontalCenter = undefined
            blockRect.anchors.left = root.left
            blockRect.anchors.leftMargin = BComStyles.leftTextMargin
        }
    }
    onLabelVerticalCenteredChanged: {
        if (!labelVerticalCentered) {
            blockRect.anchors.verticalCenter = undefined
            blockRect.anchors.top = root.top
            blockRect.anchors.topMargin = BComStyles.topTextMargin
        }
        else {
            blockRect.anchors.top = undefined
            blockRect.anchors.topMargin = undefined
            blockRect.anchors.verticalCenter = root.verticalCenter
        }
    }
    onPictoVerticalCenteredChanged: {
        if (pictoVerticalCentered) {
            imgPicto.anchors.verticalCenter = blockRect.verticalCenter
        }
        else {
            imgPicto.anchors.verticalCenter = undefined
        }
    }

    Component.onCompleted: {
        if (imgPicto.status === Image.Null) {
            blockRect.width = textLabel.paintedWidth
        }
    }
}
