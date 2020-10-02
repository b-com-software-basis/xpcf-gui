import QtQuick 2.12
import QtQuick.Controls 2.5
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
