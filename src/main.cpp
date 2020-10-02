#include <QQmlApplicationEngine>
#include <QApplication>
#include <QtCore/QStandardPaths>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickView>

#include "QMLProxy.h"
#include "sortfilterproxymodel.h"
#include "DataPaths.h"
#include "CustomTableModel.h"

#include <boost/log/core.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/sinks/text_file_backend.hpp>
#include <boost/log/utility/setup/file.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/support/date_time.hpp>

namespace logging = boost::log;
namespace src = boost::log::sources;
namespace sinks = boost::log::sinks;
namespace keywords = boost::log::keywords;


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    DataPaths paths;
    // tableview sort
    qmlRegisterType<SortFilterProxyModel>("SortFilterProxyModel", 0, 1, "SortFilterProxyModel");

    // Settings properties - for save settings (HKEY_CURRENT_USER\Software\b-com\Picture Cipher)
    app.setOrganizationName("b-com");
    app.setOrganizationDomain("b-com.com");
    app.setApplicationName("Picture Cipher");

    // Boost log
    logging::add_file_log
            (
                keywords::file_name = paths.bcomRoot().toStdString() + "log/xpcf-gui_%N.log",                                        /*< file name pattern >*/
                keywords::rotation_size = 10 * 1024 * 1024,                                   /*< rotate files every 10 MiB... >*/
                keywords::time_based_rotation = sinks::file::rotation_at_time_point(0, 0, 0), /*< ...or at midnight >*/
                keywords::format =
            (
                logging::expressions::stream
                << logging::expressions::format_date_time< boost::posix_time::ptime >("TimeStamp", "%Y-%m-%d %H:%M:%S:%f") << " | "
                << logging::trivial::severity << " | "
                << logging::expressions::attr<std::string>("ClassName") << " | "
                << logging::expressions::message
                ),
                keywords::auto_flush = true
            );

    logging::core::get()->set_filter( logging::trivial::severity >= logging::trivial::info );
    logging::add_common_attributes();

    QQmlApplicationEngine engine;
//    QQuickView viewer;
    CustomTableModel componentModel;
    CustomTableModel appComponentModel;
    QStringListModel  parameterValuesModel;
    //QStringListModel modulesModel;
    CustomTableModel modulesModel;
    CustomTableModel interfacesModel;
    CustomTableModel allInterfacesModel;
    CustomTableModel componentParamsModel;
    CustomTableModel parametersModel;
    QMLProxy proxy(&engine,componentModel,modulesModel,interfacesModel,appComponentModel,allInterfacesModel,parametersModel,parameterValuesModel);
    //qmlRegisterUncreatableType<Element>("org.bcom.xpcf.gui",1,0,"Element","Element is for reading only");
    qmlRegisterInterface<Element>("Element");
    engine.rootContext()->setContextProperty("user", &proxy);
    engine.rootContext()->setContextProperty("componentModel", &componentModel);
    engine.rootContext()->setContextProperty("appComponentModel", &appComponentModel);
    engine.rootContext()->setContextProperty("modulesModel", &modulesModel);
    engine.rootContext()->setContextProperty("interfacesModel", &interfacesModel);
    engine.rootContext()->setContextProperty("allInterfacesModel", &allInterfacesModel);
    engine.rootContext()->setContextProperty("parametersModel", &parametersModel);
    engine.rootContext()->setContextProperty("parameterValuesModel", &parameterValuesModel);

    // version
    QString version = MYVERSIONSTRING;
    engine.rootContext()->setContextProperty("version", QVariant::fromValue(version));

    engine.load(QUrl("qrc:///qml/main.qml"));
//    proxy.setViewer(&viewer);
   /* ImageOverlayProvider *imageProvider = new ImageOverlayProvider(QQmlImageProviderBase::Image);
    viewer.engine()->addImageProvider("imageOverlayProvider",imageProvider);*/



    return app.exec();
}
