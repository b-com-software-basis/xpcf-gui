import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

Button {
    id: rootButton
    property alias tooltip : buttonTooltip.text
    property string buttonColor
    property color defaultBgColor: BComStyles.darkGrey
    property color disabledBgColor: BComStyles.grey
    property color hoverBgColor: BComStyles.grey
    property color clickedBgColor: BComStyles.lightGrey
    property color textColor: BComStyles.white
    property bool bStateButton : false
    checked : false
    enabled : false
    width: implicitWidth
    bottomPadding: 1

    opacity: pressed ? 72 : 100
    onHoveredChanged: {
        if (!rootButton.enabled)
            mainRect.color = disabledBgColor
        else
        {
            if (hovered) {
                mainRect.color = hoverBgColor
            }
            else {
                if (bStateButton) {
                    mainRect.color = clickedBgColor
                }
                else {
                    mainRect.color = defaultBgColor
                }
            }
        }
    }

    onPressedChanged: {
        if (!rootButton.pressed) {
            if (hovered) {
                mainRect.color = hoverBgColor
            }
            else {
                if (bStateButton) {
                    mainRect.color = clickedBgColor
                }
                else {
                    mainRect.color = defaultBgColor
                }
            }
        }
        else
        {
            mainRect.color = clickedBgColor
        }
    }

    onButtonColorChanged: {
        switch (buttonColor) {
            case "black" :
                hoverBgColor= BComStyles.grey
                clickedBgColor= BComStyles.lightGrey
                defaultBgColor= BComStyles.black
                break;
            case "grey" :
                hoverBgColor= BComStyles.grey
                clickedBgColor= BComStyles.lightGrey
                defaultBgColor= BComStyles.darkGrey
                break;
            default:
                break;
        }
    }

    onEnabledChanged: {
        rootButton.enabled ? mainRect.color = defaultBgColor : mainRect.color = clickedBgColor
    }

    onBStateButtonChanged: {
        root.bStateButton ? mainRect.color = clickedBgColor : mainRect.color =  defaultBgColor
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
            anchors.left: bgr.left
            anchors.right: bgr.right
            anchors.bottom: bgr.bottom
            color: BComStyles.grey
        }
    }

    ToolTip {
        id: buttonTooltip
        visible: text.length != 0 && hovered
        delay: Qt.styleHints.mousePressAndHoldInterval
    }
}
