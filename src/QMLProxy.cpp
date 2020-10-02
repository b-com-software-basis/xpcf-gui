#include "QMLProxy.h"
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QFileInfo>
#include <QDateTime>
#include "LoadSaveWidget.h"
#include <iostream>
#include <QQmlContext>

#include "DataPaths.h"

#include "xpcf/xpcf.h"
#include "xpcf/api/IModuleManager.h"
#include <boost/filesystem.hpp>
#include <boost/log/core.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/sinks/text_file_backend.hpp>
#include <boost/log/utility/setup/file.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/support/date_time.hpp>

#include <utility>

#define BOOST_ALL_DYN_LINK 1
namespace logging = boost::log;
namespace src = boost::log::sources;
namespace sinks = boost::log::sinks;
namespace keywords = boost::log::keywords;

namespace xpcf = org::bcom::xpcf;

using namespace std;

#if defined ( WIN32 )
#ifndef __func__
#define __func__ __FUNCTION__
#endif
#endif

QMLProxy::QMLProxy(QQmlApplicationEngine * engine, CustomTableModel & componentModel,CustomTableModel & modulesModel,
                   CustomTableModel & interfacesModel, CustomTableModel & appComponentModel,
                   CustomTableModel & allInterfacesModel, CustomTableModel & parametersModel, QStringListModel & parameterValues): m_engine(engine),
    m_componentModel(componentModel),m_modulesModel(modulesModel), m_interfacesModel(interfacesModel),
    m_appComponentModel(appComponentModel),m_allInterfacesModel(allInterfacesModel),m_parametersModel(parametersModel),m_parameterValues(parameterValues)
{
    m_logger.add_attribute("ClassName", boost::log::attributes::constant<std::string>("QMLProxy"));

    QString prefixClass = "QMLProxy::";
    m_proxyErrorContextMap[prefixClass + "getModules"] = "Modules search error;;GetModules failed";
    m_proxyErrorContextMap[prefixClass + "getComponentInfos"] = "Contact Error;;Error when retrieve pictures by contact";
}

QMLProxy::~QMLProxy()
{
}

bool QMLProxy::populateInterfaces(SPtr<xpcf::ModuleMetadata> moduleInfos)
{
    SRef<xpcf::IModuleManager> xpcfModuleManager = xpcf::getModuleManagerInstance();
    for (auto componentInfo : moduleInfos->getComponentsMetadata()) {
        QString componentUUID = to_string(componentInfo->getUUID()).c_str();
        try {
            SRef<xpcf::IComponentIntrospect> componentRef;

            if (m_componentsMap.find(componentUUID) == m_componentsMap.end()) {
                componentRef = xpcfModuleManager->createComponent(moduleInfos,componentInfo->getUUID());
                m_componentsMap[componentUUID] = componentRef;
            }
            else {
                componentRef = m_componentsMap[componentUUID];
            }
            for (auto interfaceUUID : componentRef->getInterfaces()) {
                xpcf::InterfaceMetadata ifMdata = componentRef->getMetadata(interfaceUUID);
                QString ifUUID = to_string(ifMdata.getUUID()).c_str();
                if (m_interfacesComponentMap.find(ifUUID) == m_interfacesComponentMap.end()) {
                    Element e = makeElement<xpcf::InterfaceMetadata>(ifMdata);
                    m_allInterfacesModel.addData(e);
                }
                m_interfacesComponentMap.insert(std::make_pair(ifUUID,componentInfo));// ifUUID = uuidStr;
            }
        }
        catch (xpcf::Exception &e) {
            handleError(__func__,e);
            std::cout<<"Error creating component '"<<componentInfo->name()<<"'"<<std::endl;
            std::cout<<"            -> exception caught = '"<<e.what()<<"'"<<std::endl;
            return false;
        }
    }
    return true;
}

void QMLProxy::registerModuleInformations(SPtr<org::bcom::xpcf::ModuleMetadata> moduleInfos)
{
    QString uuid = to_string(moduleInfos->getUUID()).c_str();
    if (m_moduleMap.find(uuid) == m_moduleMap.end()) {
        m_moduleMap[uuid] = moduleInfos;
        Element e = makeElement<xpcf::ModuleMetadata>(*moduleInfos);
        e.m_description = moduleInfos->getPath();
        m_modulesModel.addData(e);
        populateInterfaces(moduleInfos);
    }
}

bool QMLProxy::loadModules(const QUrl & folderUrl, bool bRecurse)
{
    QString localFolderPath = folderUrl.toLocalFile();
    SRef<xpcf::IComponentManager> xpcfComponentManager = xpcf::getComponentManagerInstance();
    xpcfComponentManager->loadModules(localFolderPath.toStdString().c_str(), bRecurse);
    for (auto moduleInfos : xpcfComponentManager->getModulesMetadata()) {
        registerModuleInformations(moduleInfos);
    }
    return true;
}

bool QMLProxy::addModule(const QUrl & moduleUrl)
{
    QString localFilePath = moduleUrl.toLocalFile();
    QFileInfo moduleInf(localFilePath);
    QString name, path, uuid;
    name = moduleInf.baseName();
    path = moduleInf.path();
    SRef<xpcf::IModuleManager> xpcfModuleManager = xpcf::getModuleManagerInstance();
    try {
        SPtr<xpcf::ModuleMetadata> moduleInfos = xpcfModuleManager->introspectModule(localFilePath.toStdString().c_str());
        if (moduleInfos) {
            std::cout<<"Module name = '"<<name.toStdString()<<"'"<<std::endl;
            std::cout<<"            -> UUID = '"<<moduleInfos->getUUID()<<"'"<<std::endl;
            std::cout<<"            -> path = '"<<moduleInfos->getPath()<<"'"<<std::endl;
            std::cout<<"            -> fullpath = '"<<moduleInfos->getFullPath()<<"'"<<std::endl;
            registerModuleInformations(moduleInfos);
        }
    }
    catch (xpcf::Exception &e) {
        handleError(__func__,e);
        std::cout<<"Error loading module '"<<name.toStdString()<<"'"<<std::endl;
        std::cout<<"            -> exception caught = '"<<e.what()<<"'"<<std::endl;
    }
    return true;
}

void QMLProxy::removeComponents(SPtr<org::bcom::xpcf::ModuleMetadata> moduleInfos)
{
    for (SPtr<xpcf::ComponentMetadata> componentInfo : moduleInfos->getComponentsMetadata()) {
        QString componentUUID = to_string(componentInfo->getUUID()).c_str();
        SRef<org::bcom::xpcf::IComponentIntrospect> componentRef =  m_componentsMap[componentUUID];
        m_componentsMap.erase(componentUUID);
        for (auto interfaceUUID : componentRef->getInterfaces()) {
            xpcf::InterfaceMetadata ifMdata = componentRef->getMetadata(interfaceUUID);
            //remove component from m_interfacesComponentMap
            QString interfaceUUIDstr = to_string(interfaceUUID).c_str();
            auto range = m_interfacesComponentMap.equal_range(interfaceUUIDstr);
            for ( auto i = range.first ; i!= range.second ; ++i ) {
                if (i->second->getUUID() == componentInfo->getUUID()) {
                    m_interfacesComponentMap.erase(i);
                    break;
                }
            }
        }
    }
    m_componentModel.clear();
    m_interfacesModel.clear();
}

void QMLProxy::removeModule(const QModelIndex & idx)
{
    QString moduleUUID = m_modulesModel.uuid(idx);
    if (m_moduleMap.find(moduleUUID) != m_moduleMap.end()) {
        removeComponents(m_moduleMap[moduleUUID]);
        m_moduleMap.erase(moduleUUID);
    }
    m_modulesModel.removeRow(idx.row());

}

bool QMLProxy::getComponents(const QModelIndex &modelIndex)
{
    QString uuid = m_modulesModel.uuid(modelIndex);
    return getComponents(uuid);
}

bool QMLProxy::getComponentsForInterface(const QModelIndex &modelIndex)
{
    QString uuid = m_allInterfacesModel.uuid(modelIndex);
    return getComponentsForInterface(uuid);
}

bool QMLProxy::getComponentsForInterface(const QString & uuid)
{
    if (m_interfacesComponentMap.find(uuid) == m_interfacesComponentMap.end()) {
        return false;
    }
    m_componentModel.clear();
    auto range = m_interfacesComponentMap.equal_range(uuid);
    for ( auto i = range.first ; i!= range.second ; ++i ) {
        SPtr<xpcf::ComponentMetadata> componentInfo = i->second;
        QString uuidStr = to_string(componentInfo->getUUID()).c_str();
        try {
            Element e = makeElement<xpcf::ComponentMetadata>(*componentInfo);
            m_componentModel.addData(e);
        }
        catch (xpcf::Exception &e) {
            handleError(__func__,e);
            std::cout<<"Error creating component '"<<componentInfo->name()<<"'"<<std::endl;
            std::cout<<"            -> exception caught = '"<<e.what()<<"'"<<std::endl;
        }
    }
    return true;
}


bool QMLProxy::getComponents(const QString & uuid)
{
    if (m_moduleMap.find(uuid) == m_moduleMap.end()) {
        return false;
    }
    SPtr<xpcf::ModuleMetadata> moduleInfos = m_moduleMap[uuid];
    m_componentModel.clear();
    for (auto componentInfo : moduleInfos->getComponentsMetadata()) {
        QString uuidStr = to_string(componentInfo->getUUID()).c_str();
        try {
            Element e = makeElement<xpcf::ComponentMetadata>(*componentInfo);
            m_componentModel.addData(e);
        }
        catch (xpcf::Exception &e) {
            handleError(__func__,e);
            std::cout<<"Error creating component '"<<componentInfo->name()<<"'"<<std::endl;
            std::cout<<"            -> exception caught = '"<<e.what()<<"'"<<std::endl;
        }
    }
    return true;
}

void QMLProxy::newConfiguration()
{
    m_appComponentModel.clear();
    m_configuratorModuleMap.clear();
}

bool QMLProxy::pickComponent(const QString & moduleUUID, const QString & componentUUID)
{
    SPtr<xpcf::ModuleMetadata> moduleInfos = m_moduleMap[moduleUUID];
    if (m_configuratorModuleMap.find(moduleUUID) == m_configuratorModuleMap.end()) {
        m_configuratorModuleMap[moduleUUID] = xpcf::utils::make_shared<xpcf::ModuleMetadata>(moduleInfos->name(),moduleInfos->getUUID(),moduleInfos->description(),moduleInfos->getPath());
    }
    SPtr<xpcf::ComponentMetadata> componentInfo = moduleInfos->getComponentMetadata(xpcf::toUUID(componentUUID.toStdString()));
    m_configuratorModuleMap[moduleUUID]->addComponent(componentInfo);
    Element e = makeElement<xpcf::ComponentMetadata>(*componentInfo);
    e.m_description = moduleUUID;
    m_appComponentModel.addData(e);
    return true;
}

bool QMLProxy::unpickComponent(const QString & moduleUUID, const QModelIndex & idx)
{// ???? why the following line modifies the m_moduleMap[moduleUUID] SPtr ???
    SPtr<xpcf::ModuleMetadata> moduleInfos = m_moduleMap[moduleUUID];
    if (m_configuratorModuleMap.find(moduleUUID) != m_configuratorModuleMap.end()) {
        QString componentUUID = m_appComponentModel.uuid(idx);
        m_configuratorModuleMap[moduleUUID]->removeComponent(xpcf::toUUID(componentUUID.toStdString()));
        if (m_configuratorModuleMap[moduleUUID]->getComponents().size() == 0) {
            m_configuratorModuleMap.erase(moduleUUID);
        }
    }
    m_appComponentModel.removeRow(idx.row());
    return true;
}

void QMLProxy::getComponentInfos(const QString & uuid)
{
    if (m_componentsMap.find(uuid) == m_componentsMap.end()) {
        return;
    }
    m_interfacesModel.clear();
    SRef<xpcf::IComponentIntrospect> componentRef = m_componentsMap[uuid];
    for (auto interfaceUUID : componentRef->getInterfaces()) {
        xpcf::InterfaceMetadata ifMdata = componentRef->getMetadata(interfaceUUID);
        Element e = makeElement<xpcf::InterfaceMetadata>(ifMdata);
        m_interfacesModel.addData(e);
    }
}

static std::map<xpcf::IProperty::PropertyType,std::string> propertyType2strMap = {
    { xpcf::IProperty::PropertyType::IProperty_NONE, "None" },

    { xpcf::IProperty::PropertyType::IProperty_INTEGER, "32 bits integer" },

    { xpcf::IProperty::PropertyType::IProperty_UINTEGER,  "32 bits unsigned integer" },

    { xpcf::IProperty::PropertyType::IProperty_LONG,  "64 bits integer" },

    { xpcf::IProperty::PropertyType::IProperty_ULONG,  "64 bits unsigned integer" },

    { xpcf::IProperty::PropertyType::IProperty_CHARSTR,  "character string (const char *)" },

    { xpcf::IProperty::PropertyType::IProperty_UNICODESTR,  "unicode char string (const wchar_t*)" },

    { xpcf::IProperty::PropertyType::IProperty_FLOAT,  "32 bits float" },

    { xpcf::IProperty::PropertyType::IProperty_DOUBLE,  "64 bits double" },

    { xpcf::IProperty::PropertyType::IProperty_STRUCTURE,  "Structure node" },
};

void displayParameter(SRef<xpcf::IProperty> p)
{
    std::cout<<"Property name ="<<p->getName()<<std::endl;
    for (uint32_t i=0 ; i < p->size() ; i++ ) {
        switch (p->getType()) {
        case xpcf::IProperty::IProperty_NONE :
            break;
        case xpcf::IProperty::IProperty_INTEGER :
            std::cout<<"=> Int property = "<<p->getIntegerValue(i)<<std::endl;
            break;
        case xpcf::IProperty::IProperty_UINTEGER :
            std::cout<<"=> Uint property = "<<p->getUnsignedIntegerValue(i)<<std::endl;
            break;
        case xpcf::IProperty::IProperty_LONG :
            std::cout<<"=> Long property = "<<p->getLongValue(i)<<std::endl;
            break;
        case xpcf::IProperty::IProperty_ULONG :
            std::cout<<"=> ULong property = "<<p->getUnsignedLongValue(i)<<std::endl;
            break;
        case xpcf::IProperty::IProperty_CHARSTR :
            std::cout<<"=> String property = "<<p->getStringValue(i)<<std::endl;
            break;
        case xpcf::IProperty::IProperty_UNICODESTR :
            break;
        case xpcf::IProperty::IProperty_FLOAT :
            std::cout<<"=> Float property = "<<p->getFloatingValue(i)<<std::endl;
            break;
        case xpcf::IProperty::IProperty_DOUBLE :
            std::cout<<"=> Double property = "<<p->getDoubleValue(i)<<std::endl;
            break;
        case xpcf::IProperty::IProperty_STRUCTURE :
        {
            SRef<xpcf::IPropertyMap> propertyMap = p->getStructureValue(i);
            std::cout<<"Accessing class values for C0 from IProperty/IPropertyMap interfaces"<<std::endl;
            for (auto property : propertyMap->getProperties()) {
                displayParameter(property);
            }
            break;
        }
        default:
            break;
        }
    }
}

void QMLProxy::getComponentParams(const QString & uuid)
{
    if (m_componentsMap.find(uuid) == m_componentsMap.end()) {
        return;
    }

    m_parametersModel.clear();
    SRef<xpcf::IComponentIntrospect> componentRef = m_componentsMap[uuid];
    if (componentRef->implements<xpcf::IConfigurable>()) {
        SRef<xpcf::IConfigurable> rIConfigurable = componentRef->bindTo<xpcf::IConfigurable>();
        map<xpcf::uuids::uuid,SRef<xpcf::IPropertyMap>> paramsMap;
        if (rIConfigurable->hasProperties()) {
            for (auto property : rIConfigurable->getProperties()) {
                if (rIConfigurable->getProperties().size() == 0) {
                    std::cout<<"ERROR : no movenext "<<std::endl;
                    break;
                }
                else {
                    QString name(property->getName());
                    QString type(propertyType2strMap[property->getType()].c_str());
                    Element e(name,type,"");
                    m_parametersModel.addData(e);
                }
            }
        }
    }
}

void QMLProxy::getParameterInfos(const QString & uuid,const QString & paramName)
{
    if (m_componentsMap.find(uuid) == m_componentsMap.end()) {
        return;
    }
    QQuickItem* componentsRootWidget = m_engine->rootContext()->findChild<QQuickItem*>("componentsRootWidget");
    if (componentsRootWidget != 0) {
        SRef<xpcf::IComponentIntrospect> componentRef = m_componentsMap[uuid];
        if (componentRef->implements<xpcf::IConfigurable>()) {
            SRef<xpcf::IConfigurable> rIConfigurable = componentRef->bindTo<xpcf::IConfigurable>();
            map<xpcf::uuids::uuid,SRef<xpcf::IPropertyMap>> paramsMap;
            if (rIConfigurable->hasProperties()) {
                for (auto property : rIConfigurable->getProperties()) {
                    if (rIConfigurable->getProperties().size() == 0) {
                        std::cout<<"ERROR : no movenext "<<std::endl;
                        break;
                    }
                    else {
                        QString name(property->getName());
                        if (name == paramName) {
                            QStringList values;
                            auto currentProperty = rIConfigurable->getProperty(property->getName());
                            for (unsigned long cpt = 0 ; cpt < currentProperty->size() ; cpt ++) {
                                QString value;
                                switch (currentProperty->getType()) {
                                case xpcf::IProperty::PropertyType::IProperty_DOUBLE: value = QString::number(currentProperty->getDoubleValue(cpt));
                                    break;
                                default:
                                    break;

                                }
                                values.append(value);
                            }
                            m_parameterValues.setStringList(values);
                            emit m_parameterValues.layoutChanged();
                        }
                        //displayParameter(property);
                    }
                }
            }
        }
    }
}

void QMLProxy::getModules()
{
    for (auto & m : m_moduleMap) {
        QQuickItem* modulesRootWidget = m_engine->rootContext()->findChild<QQuickItem*>("modulesRootWidget");
        if (modulesRootWidget != 0) {
            Element e;
            e.m_name = m.second->name();
            e.m_uuid = m.first;
            e.m_description = m.second->getPath();
            QMetaObject::invokeMethod(modulesRootWidget, "addModule",Q_ARG(QVariant, e.m_name),
                                      Q_ARG(QVariant, e.m_description),
                                      Q_ARG(QVariant, e.m_uuid));
        }
    }
}

QUrl QMLProxy::getXpcfRegistryDefaultPath()
{
    DataPaths paths;
    return QUrl::fromLocalFile(paths.root());
}

QUrl QMLProxy::getDevRoot()
{
    DataPaths paths;
    return QUrl::fromLocalFile(paths.root());
}

bool QMLProxy::save()
{
    SaveWidget saveWidget;
    QString filepath = saveWidget.save();
    if( filepath.isNull() ) {
        return false;
    }
    SRef<xpcf::IModuleManager> xpcfModuleManager = xpcf::getModuleManagerInstance();
    for (auto elt : m_configuratorModuleMap) {
        xpcfModuleManager->saveModuleInformations(filepath.toStdString().c_str(),elt.second);
    }
    return true;
}

bool QMLProxy::generateSnippet()
{
    std::cout<<"int main(void)"<<std::endl;
    std::cout<<"{"<<std::endl;
    std::cout<<"    "<<"SRef<xpcf::IComponentManager> xpcfComponentManager = xpcf::getComponentManagerInstance();"<<std::endl;
    std::cout<<"    "<<"xpcfComponentManager->load();"<<std::endl;
    for (auto elt : m_configuratorModuleMap) {
        for (auto componentInfo:elt.second->getComponentsMetadata()) {
            std::cout<<"    "<<"SRef<IComponentIntrospect> "<<componentInfo->name()<<" = xpcfComponentManager->createComponent(\""<<to_string(componentInfo->getUUID()).c_str()<<"\");"<<std::endl;
        }
    }
    std::cout<<"    "<<"return 0;"<<std::endl;
    std::cout<<"}"<<std::endl;

    return true;
}

bool QMLProxy::load()
{
    SaveWidget saveWidget;
    SRef<xpcf::IComponentManager> xpcfComponentManager = xpcf::getComponentManagerInstance();
    xpcfComponentManager->clear();
    bool res = saveWidget.load(xpcfComponentManager);
    if (!res) {
        return res;
    }
    newConfiguration();
    for (auto moduleInfos : xpcfComponentManager->getModulesMetadata()) {
        QString uuidStr = to_string(moduleInfos->getUUID()).c_str();
        m_configuratorModuleMap[uuidStr]=moduleInfos;
        for (auto componentInfo : moduleInfos->getComponentsMetadata()) {
            Element e = makeElement<xpcf::ComponentMetadata>(*componentInfo);
            e.m_description = to_string(moduleInfos->getUUID()).c_str();
            m_appComponentModel.addData(e);
        }
        QUrl moduleUrl = QUrl::fromLocalFile( moduleInfos->getFullPath());
        addModule(moduleUrl);
        getComponents(uuidStr);
    }
    return res;
}

static std::map<xpcf::XPCFErrorCode,std::string> errorType2TitleMap = {
    { xpcf::XPCFErrorCode::_FAIL ,"Failed"},
    { xpcf::XPCFErrorCode::_SUCCESS ,"Success"},
    { xpcf::XPCFErrorCode::_ERROR_MODULE_UNKNOWN ,"Unknown module"},
    { xpcf::XPCFErrorCode::_ERROR_COMPONENT_UNKNOWN ,"Unknown component"},
    { xpcf::XPCFErrorCode::_ERROR_INTERFACE_UNKNOWN ,"Unknown interface"},
    { xpcf::XPCFErrorCode::_ERROR_MODULE_MISSINGXPCF_ENTRY ,"Not an XPCF Module"},
};

void QMLProxy::handleError(std::string contextName, xpcf::Exception & ex)
{
    //m_errorCode = errorCode;

    QQuickItem* rootWidget = m_engine->rootContext()->findChild<QQuickItem*>("rootWindow");
    std::string title = "Error";
    if (errorType2TitleMap.find(ex.getErrorCode()) != errorType2TitleMap.end()) {
        title = errorType2TitleMap.at(ex.getErrorCode());
    }
    QMetaObject::invokeMethod(rootWidget, "displayPopup", Q_ARG(QVariant, static_cast<QString>(title.c_str())),
                              Q_ARG(QVariant, static_cast<QString>(ex.what())),
                              Q_ARG(QVariant, (bool)false),Q_ARG(QVariant, (bool)false));
}
