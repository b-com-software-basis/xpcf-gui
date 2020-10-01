import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3
import "BComStyles.js" as BComStyles

Text {
    id: root
    color:BComStyles.white
    onEnabledChanged: {
        if (!enabled) {
            color=BComStyles.lightGrey
        }
        else {
            color=BComStyles.white
        }
    }
}
