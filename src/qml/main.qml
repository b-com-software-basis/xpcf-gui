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

            onDisplayHelpChanged:{
                if (displayHelp == true) {
                    home.closeHelp = false
                    modules.closeHelp = false
                    components.closeHelp = false
                    interfaces.closeHelp = false
                    configurator.closeHelp = false
                    parameters.closeHelp = false
                }

                home.displayHelp = displayHelp
                modules.displayHelp = displayHelp
                components.displayHelp = displayHelp
                interfaces.displayHelp = displayHelp
                configurator.displayHelp = displayHelp
                parameters.displayHelp = displayHelp
            }

            productTitle: "*" + rootWindow.title + "*"
            currentTitle: "/ home"
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: menuBar.currentIndex
            Home {
                id: home
                onCloseHelpChanged: {
                    if (home.closeHelp == true) {
                        menuBar.displayHelp = false
                    }
                }
            }
            Modules {
                id: modules
                onCloseHelpChanged: {
                    if (modules.closeHelp == true) {
                        menuBar.displayHelp = false
                    }
                }
            }
            Components {
                id: components
                onCloseHelpChanged: {
                    if (components.closeHelp == true) {
                        menuBar.displayHelp = false
                    }
                }
            }
            Interfaces {
                id: interfaces
                onCloseHelpChanged: {
                    if (interfaces.closeHelp == true) {
                        menuBar.displayHelp = false
                    }
                }
            }

            Configurator {
                id: configurator
                onCloseHelpChanged: {
                    if (configurator.closeHelp == true) {
                        menuBar.displayHelp = false
                    }
                }
            }
            Parameters {
                id: parameters
                onCloseHelpChanged: {
                    if (parameters.closeHelp == true) {
                        menuBar.displayHelp = false
                    }
                }}
        }
    }
}
