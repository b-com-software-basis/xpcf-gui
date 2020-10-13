import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "BComStyles.js" as BComStyles

ApplicationWindow {
    id: rootWindow
    visible: true
    minimumWidth: 1440
    minimumHeight: 800
    color: BComStyles.darkGrey
    title: "xpcf Configuration Editor"
    FontLoader { id: bcombold; source: "fonts/Bcom-SemiBold.otf" }
    FontLoader { id: bcom; source: "fonts/Bcom-Light.otf" }
    ColumnLayout {
        anchors.fill: parent
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter
        spacing: 0  // SLETODO!!

        BComMenuBar {
            id: menuBar
            productTitle: "*" + rootWindow.title + "*"
            currentTitle: "/ home"
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: menuBar.currentIndex
            Home {
                displayHelp: menuBar.displayHelp
            }
            Modules {}
            Components {}
            Interfaces {}
            Configurator {}
        }
    }
}
