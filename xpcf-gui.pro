TARGET = xpcf-gui

FRAMEWORK = $${TARGET}
VERSION=2.4.0
DEFINES += MYVERSION=$${VERSION}
DEFINES += MYVERSIONSTRING=\\\"$${VERSION}\\\"

QT += qml quick widgets xml quickcontrols2
CONFIG += c++1z
CONFIG += shared

DEPENDENCIESCONFIG = sharedlib recurse
#NOTE : CONFIG as staticlib or sharedlib, DEPENDENCIESCONFIG as staticlib or sharedlib and PROJECTDEPLOYDIR MUST BE DEFINED BEFORE templatelibbundle.pri inclusion
include (builddefs/qmake/templateappconfig.pri)


# config debug/release
CONFIG(debug,debug|release) {
    DEFINES += XPCFGUI_DEBUG=1
    OUTPUTDIR = debug
    BOOST_SUFFIX = gd-
}
CONFIG(release,debug|release) {
    OUTPUTDIR = release
    BOOST_SUFFIX =
}

QMAKE_CXXFLAGS += -DBOOST_ALL_DYN_LINK

HEADERS += \
    src/DataPaths.h \
    src/QMLProxy.h \
    src/sortfilterproxymodel.h \
    src/ComboboxModel.h \
    src/CustomTableModel.h \
    src/LoadSaveWidget.h


SOURCES += src/main.cpp \
    src/DataPaths.cpp \
    src/QMLProxy.cpp \
    src/sortfilterproxymodel.cpp \
    src/ComboboxModel.cpp \
    src/CustomTableModel.cpp \
    src/LoadSaveWidget.cpp

RESOURCES += src/qml.qrc

# Default rules for deployment.
include(deployment.pri)

unix {
DYNLIBEXT = so
INCLUDEPATH += /opt/local/include
LIBS +=  -L/usr/local/lib -L/opt/local/lib
}

macx {
CONFIG += MacOSX
QMAKE_MAC_SDK= macosx
QMAKE_CXXFLAGS += -mmacosx-version-min=10.6
QMAKE_LFLAGS += -mmacosx-version-min=10.6
DYNLIBEXT = dylib
TARGET_CUSTOM_EXT = .app
DEPLOY_COMMAND = macdeployqt
DEPLOY_TARGET = $$shell_path($${OUT_PWD}/$${TARGET}$${TARGET_CUSTOM_EXT})
DEPLOY_BINTARGETPATH = $$shell_path($${OUT_PWD}/$${TARGET}$${TARGET_CUSTOM_EXT}/Contents/MacOS)
DEPLOY_OPTIONS = -qmldir=src/qml -dmg
}

win32 {
DYNLIBEXT = dll
QMAKE_CXXFLAGS += -DBOOST_USE_WINAPI_VERSION=0x0601
TARGET_CUSTOM_EXT = .exe
DEPLOY_COMMAND = windeployqt
DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/$${OUTPUTDIR}/$${TARGET}$${TARGET_CUSTOM_EXT}))
DEPLOY_BINTARGETPATH = $$shell_path($${OUT_PWD}/$${OUTPUTDIR})
DEPLOY_OPTIONS = --qmldir $$shell_quote($$shell_path($$PWD/src/qml))
QMAKE_TARGET_COMPANY="b-com"
QMAKE_TARGET_COPYRIGHT="Copyright (c) 2016 b-com"
LIBS += -L$(BCOMDEVROOT)/thirdparties/ApacheThrift/lib/x64/$${OUTPUTDIR} -lthriftmd
LIBS += -L$(BCOMDEVROOT)/thirdparties/OpenSSL-Win64/lib -lssleay32 -llibeay32
#TODO : put same lib name on windows
LIBS += -L$(BCOMDEVROOT)/bcomBuild/pixguardian-client/lib/$${OUTPUTDIR} -lpixguardian-client
INCLUDEPATH += $(BCOMDEVROOT)/thirdparties/boost_1_60_0
LIBS += -L$(BCOMDEVROOT)/thirdparties/boost_1_60_0/lib64-msvc-12.0
}

QMAKE_LFLAGS_SONAME  = -Wl,-install_name,@executable_path/

# Deployment - Copy submodules dependencies
win32 {
}
# Deployment - Automatically Detect and Copy Dependencies to Build Folder

macx {
#_____IMPORTANT_____ DO NOT USE QT5.5 TO DEPLOY this application on MAC OS X : macdeployqt has some important regressions

#NOTE : dylibbundler MUST BE called before macdeployqt when libraries are not installed in Frameworks :
#otherwise, macdeployqt can sometimes interpret some libraries as frameworks
#NOTE 2 : macdeployqt already does the stuff, following line is kept for later documentation purpose about dylibbundler
    #QMAKE_POST_LINK += dylibbundler -od -b -x $$shell_path($${OUT_PWD}/$${TARGET}$${TARGET_CUSTOM_EXT}/Contents/MacOS/$${TARGET}) -d $$shell_path($${OUT_PWD}/$${TARGET}$${TARGET_CUSTOM_EXT}/Contents/libs/)

#NOTE : macdeployqt must be called manually : as it can fails when a plugin doesn´t exist, it must continue its execution to deploy other stuff.
#When run from QT Creator, it is stopped before other deployment are terminated.
#The command line is : macdeployqt /path/to/build-pictureCipherGUI-Desktop_Qt_5_4_0_clang_64bit-Debug/pictureCipherGUI.app -qmldir=src/qml -dmg
#QMAKE_POST_LINK += $${DEPLOY_COMMAND} $${DEPLOY_TARGET} $${DEPLOY_OPTIONS}
}



