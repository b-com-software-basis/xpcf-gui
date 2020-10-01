/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL21$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia. For licensing terms and
** conditions see http://qt.digia.com/licensing. For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights. These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.3
import QtQuick.Controls 1.4
import "BComStyles.js" as BComStyles

Button {
    id: root

    property alias text : bgr.text
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

    BComTextBlock {
        id: bgr
        anchors.top: parent.top
        anchors.bottom: indicatorRect.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: BComStyles.black
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
