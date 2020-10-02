import QtQuick 2.12
import QtQuick.Controls 2.5
import "BComStyles.js" as BComStyles

Rectangle {
    id: root
    property bool bCenterText : false
    property bool labelVerticalCentered : true
    property bool pictoVerticalCentered : true
    property string textColor : "white"
    color: BComStyles.grey
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
        anchors {
            left:parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }
        height: textLabel.height
        width: textLabel.width
        color:"transparent"
        BComTextStyle3 {
            id: textLabel
            anchors {
                left : parent.left
                leftMargin : BComStyles.leftTextMargin
                verticalCenter: parent.verticalCenter
            }
            color: textColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
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
}
