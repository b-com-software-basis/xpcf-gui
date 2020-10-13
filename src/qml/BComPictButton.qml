import QtQuick 2.12
import QtQuick.Controls 2.5
import "BComStyles.js" as BComStyles

Button {
    id: root

    property alias buttonText : bgr.text
    property alias tooltip : buttonTooltip.text
    property alias imagepicto : bgr.source
    property alias bCenterText : bgr.bCenterText
    property alias bPictoBefore : bgr.bPictoBefore
    property string buttonColor
    property color defaultBgColor: BComStyles.grey
    property color disabledBgColor: BComStyles.grey
    property color hoverBgColor: BComStyles.medBlue
    property color clickedBgColor: BComStyles.darkBlue
    property color textColor: BComStyles.white
    property color textColorSelected: BComStyles.blue
    property alias textFontSize : bgr.textFontSize
    property alias textFontFamily : bgr.textFontFamily
    property bool bStateButton : false


    checked : false
    enabled : false

    opacity: pressed ? 72 : 100
    onHoveredChanged: {
        if (!root.enabled)
            indicatorRect.color = disabledBgColor
        else
        {
            if (hovered) {
                indicatorRect.color = hoverBgColor
            }
            else {
                if (bStateButton) {
                    indicatorRect.color = clickedBgColor
                }
                else {
                    indicatorRect.color = defaultBgColor
                }
            }
        }
    }

    onPressedChanged: {
        if (!root.pressed) {
            if (hovered) {
                indicatorRect.color = hoverBgColor
            }
            else {
                if (bStateButton) {
                    indicatorRect.color = clickedBgColor
                }
                else {
                    indicatorRect.color = defaultBgColor
                }
            }
        }
        else
        {
            indicatorRect.color = clickedBgColor
        }
    }

    onEnabledChanged: {
        root.enabled ? indicatorRect.color = defaultBgColor : indicatorRect.color = clickedBgColor
    }

    onButtonColorChanged: {
        switch (buttonColor) {
            case "blue":
                hoverBgColor= BComStyles.darkBlue
                clickedBgColor= BComStyles.medBlue
                defaultBgColor= BComStyles.black
                break;
            case "green":
                hoverBgColor= BComStyles.darkGreen
                clickedBgColor= BComStyles.green
                defaultBgColor= BComStyles.black
                break;
            case "red":
                hoverBgColor= BComStyles.darkRed
                clickedBgColor= BComStyles.red
                defaultBgColor= BComStyles.black
                break;
            case "yellow":
                hoverBgColor= BComStyles.darkYellow
                clickedBgColor= BComStyles.yellow
                defaultBgColor= BComStyles.black
                break;
            case "purple":
                hoverBgColor= BComStyles.darkPurple
                clickedBgColor= BComStyles.purple
                defaultBgColor= BComStyles.black
                break;
            case "black" :
                hoverBgColor= BComStyles.grey
                clickedBgColor= BComStyles.darkGrey
                defaultBgColor= BComStyles.black
                break;
            case "grey" :
                hoverBgColor= BComStyles.grey
                clickedBgColor= BComStyles.darkGrey
                defaultBgColor= BComStyles.black
                break;
            default:
                break;
        }
    }

    onBStateButtonChanged: {
        root.bStateButton ? indicatorRect.color = clickedBgColor : indicatorRect.color =  defaultBgColor
    }

    contentItem: Rectangle {
        id: mainRect
        anchors.fill: parent
        BComPictTextBlock {
            id: bgr
            anchors.top: parent.top
            anchors.bottom: indicatorRect.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: "black"
            opacity: root.pressed ? 72 : 100
        }
        Rectangle {
            id: indicatorRect
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height:2
            color: BComStyles.black
        }
    }

    ToolTip {
        id: buttonTooltip
        visible: down
    }
}
