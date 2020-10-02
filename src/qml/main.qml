import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 1440
    height: 800
    color: BComStyles.darkGrey
    title: "xpcf Configuration Editor"
    FontLoader { id: bcombold; source: "fonts/Bcom-SemiBold.otf" }
    FontLoader { id: bcom; source: "fonts/Bcom-Light.otf" }
    ColumnLayout {
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter

    BComMenuBar {
        id: menuBar
        productTitle: "*" + rootWindow.title + "*"
        currentTitle: "/ home"
    }

    StackLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: menuBar.currentIndex
        Home {}
        Modules {}
        Components {}
        Interfaces {}
        Configurator {}
    }
    }
}
