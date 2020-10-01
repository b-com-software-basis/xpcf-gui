/**
 * @copyright Copyright (c) 2020 B-com http://www.b-com.com/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author Loïc Touraine
 *
 * @file
 * @brief description of file
 * @date 2020-09-12
 */

#ifndef QMLPROXY_H
#define QMLPROXY_H

#include <QObject>
#include <QUrl>
#include <QStringListModel>
#include <QQuickView>
#include <QQuickItem>
#include "CustomTableModel.h"

#include <boost/log/core.hpp>
#include <boost/log/trivial.hpp>

#include "xpcf/xpcf.h"

class QMLProxy : public QObject
{
    Q_OBJECT

public:
    QMLProxy(CustomTableModel & componentModel, CustomTableModel & modulesModel,
             CustomTableModel & interfacesModel,CustomTableModel & appComponentModel,
             CustomTableModel & allInterfacesModel, QStringListModel & parameterValues);
    ~QMLProxy();

    void setViewer(QQuickView * viewer) {m_viewer = viewer; }

    // Modules
    Q_INVOKABLE bool addModule(const QUrl & moduleUrl);
    Q_INVOKABLE void removeModule(const QModelIndex & idx);
    Q_INVOKABLE void getModules();

    // Components
    Q_INVOKABLE void getComponentInfos(const QString & uuid);
    Q_INVOKABLE void getComponentParams(const QString & uuid);
    Q_INVOKABLE void getParameterInfos(const QString & uuid,const QString & paramName);
    Q_INVOKABLE bool getComponents(const QString & uuid);
    Q_INVOKABLE bool getComponents(const QModelIndex &modelIndex);
    Q_INVOKABLE bool getComponentsForInterface(const QModelIndex &modelIndex);

    Q_INVOKABLE void newConfiguration();
    Q_INVOKABLE bool pickComponent(const QString & moduleUUID, const QString & componentUUID);
    Q_INVOKABLE bool unpickComponent(const QString & moduleUUID, const QModelIndex & idx);

    Q_INVOKABLE QUrl getXpcfRegistryDefaultPath();
    Q_INVOKABLE QUrl getDevRoot();

    Q_INVOKABLE bool load();
    Q_INVOKABLE bool save();
    Q_INVOKABLE bool generateSnippet();
private:
    // Error
    void handleError(std::string contextName, org::bcom::xpcf::Exception & errorCode);
    bool populateInterfaces(SPtr<org::bcom::xpcf::ModuleMetadata> moduleInfos);
    bool getComponentsForInterface(const QString & uuid);
    void removeComponents(SPtr<org::bcom::xpcf::ModuleMetadata> moduleInfos);

private:
    // User and service management
    // qml viewer
    QQuickView * m_viewer;

    // Contact model
    CustomTableModel & m_componentModel;
    CustomTableModel & m_appComponentModel;

    CustomTableModel & m_modulesModel;

    CustomTableModel & m_interfacesModel;
    CustomTableModel & m_allInterfacesModel;
    QStringListModel & m_parameterValues;
    QString m_defaultDuration;
    QString m_defaultNbViews;
    std::multimap<QString,SPtr<org::bcom::xpcf::ComponentMetadata>> m_interfacesComponentMap;
    std::map<QString,SRef<org::bcom::xpcf::IComponentIntrospect>> m_componentsMap;
    std::map<QString,SPtr<org::bcom::xpcf::ModuleMetadata>> m_moduleMap;
    std::map<QString,SPtr<org::bcom::xpcf::ModuleMetadata>> m_configuratorModuleMap;

    // Error
    std::map<QString,QString> m_proxyErrorContextMap;
    //ProxyErrorCode m_errorCode;

    boost::log::sources::severity_logger< boost::log::trivial::severity_level > m_logger;
};

#endif // QMLPROXY_H
