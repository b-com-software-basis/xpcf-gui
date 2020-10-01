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


    QQuickView viewer;
    CustomTableModel componentModel;
    CustomTableModel appComponentModel;
    QStringListModel  parameterValuesModel;
    //QStringListModel modulesModel;
    CustomTableModel modulesModel;
    CustomTableModel interfacesModel;
    CustomTableModel allInterfacesModel;
    CustomTableModel componentParamsModel;
    QMLProxy proxy(componentModel,modulesModel,interfacesModel,appComponentModel,allInterfacesModel,parameterValuesModel);
    //qmlRegisterUncreatableType<Element>("org.bcom.xpcf.gui",1,0,"Element","Element is for reading only");
    qmlRegisterInterface<Element>("Element");
    viewer.rootContext()->setContextProperty("user", &proxy);
    viewer.rootContext()->setContextProperty("componentModel", &componentModel);
    viewer.rootContext()->setContextProperty("appComponentModel", &appComponentModel);
    viewer.rootContext()->setContextProperty("modulesModel", &modulesModel);
    viewer.rootContext()->setContextProperty("interfacesModel", &interfacesModel);
    viewer.rootContext()->setContextProperty("allInterfacesModel", &allInterfacesModel);
    viewer.rootContext()->setContextProperty("parameterValuesModel", &parameterValuesModel);

    // App Title
    QString appTitle = "xpcf Configuration Editor";
    viewer.rootContext()->setContextProperty("appTitle", QVariant::fromValue(appTitle));

    // version
    QString version = MYVERSIONSTRING;
    viewer.rootContext()->setContextProperty("version", QVariant::fromValue(version));

    viewer.setSource(QUrl("qrc:///qml/main.qml"));
    proxy.setViewer(&viewer);
   /* ImageOverlayProvider *imageProvider = new ImageOverlayProvider(QQmlImageProviderBase::Image);
    viewer.engine()->addImageProvider("imageOverlayProvider",imageProvider);*/

    QObject::connect(viewer.engine(), SIGNAL(quit()), &viewer, SLOT(close()));

    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setMinimumSize(QSize(1440,800));
    viewer.show();
    viewer.setTitle(appTitle);

    return app.exec();
}
