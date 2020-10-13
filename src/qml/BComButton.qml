import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

Button {
    id: rootButton
    property alias tooltip : buttonTooltip.text
    property string buttonColor
    property color defaultBgColor: BComStyles.grey
    property color disabledBgColor: BComStyles.grey
    property color hoverBgColor: BComStyles.medBlue
    property color clickedBgColor: BComStyles.darkBlue
    property color textColor: BComStyles.white
    property color textColorSelected: BComStyles.blue
    property bool bStateButton : false
    checked : false
    enabled : false
    width: implicitWidth
    bottomPadding: 1

    opacity: pressed ? 72 : 100
    onHoveredChanged: {
        if (!rootButton.enabled)
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
        if (!rootButton.pressed) {
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
        rootButton.enabled ? indicatorRect.color = defaultBgColor : indicatorRect.color = clickedBgColor
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

    contentItem :
        Text {
        text: rootButton.text
        font.family :  bcom.name
        font.pixelSize: 18
        font.weight:Font.Light
        font.letterSpacing: 0.1
        color:BComStyles.white
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background:
        Item {
        id: bgr
        anchors.fill: rootButton
        implicitHeight: 40
        Rectangle {
        id: mainRect
        anchors.top: bgr.top
        anchors.bottom: indicatorRect.top
        border.width: 4
        border.color: BComStyles.green
        color: BComStyles.black
        }
        Rectangle {
            id: indicatorRect
            anchors.left: bgr.left
            anchors.right: bgr.right
            anchors.bottom: bgr.bottom
            height: 2
            //opacity: enabled ? 1 : 0.3
            color: BComStyles.black
        }
    }

    ToolTip {
        id: buttonTooltip
        visible: text.length != 0 && hovered
        delay: Qt.styleHints.mousePressAndHoldInterval
    }
}
