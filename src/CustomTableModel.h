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

#ifndef CUSTOMTABLEMODEL_H
#define CUSTOMTABLEMODEL_H

#ifdef USELISTMODEL
#include <QAbstractListModel>
#else
#include <QAbstractTableModel>
#endif
#include "xpcf/api/ComponentMetadata.h"

class Element : public QObject {
Q_OBJECT
Q_PROPERTY (QString name MEMBER m_name)
Q_PROPERTY (QString uuid MEMBER m_uuid)
Q_PROPERTY (QString description MEMBER m_description)

public:
    Element() = default;
    Element(const Element & el):Element(el.m_uuid,el.m_name,el.m_description) {}
    Element(const QString & uuid, const QString & name, const QString & description) {
        m_name = name;
        m_uuid = uuid;
        m_description = description;
    }
    QString m_uuid;
    QString m_name;
    QString m_description;
    void operator=(const Element & el){
        m_name = el.m_name;
        m_uuid = el.m_uuid;
        m_description = el.m_description;
    }

    static int dataCount() { return s_dataCount; }

private:
    static constexpr int s_dataCount = 3;

};

template <typename T>
Element makeElement(const T & t) {
    static_assert (org::bcom::xpcf::utils::is_base_of<org::bcom::xpcf::InterfaceMetadata, T>::value,
                   "Interface type passed to createComponent is not a derived class of IComponentIntrospect !!");
    QString uuid = to_string(t.getUUID()).c_str();
    QString name = t.name();
    QString  description = t.description();
    Element e(uuid,name,description);
    return e;
}

#ifdef USELISTMODEL
class CustomTableModel : public QAbstractListModel
#else
class CustomTableModel : public QAbstractTableModel
#endif
{
Q_OBJECT
Q_ENUMS(CustomTableModelRoles)

public:
    enum CustomTableModelRoles{
        TableDataRole = Qt::UserRole + 1,
        HeadingRole,
        UUIDRole,
        NameRole,
        DescriptionRole
    };

    QHash<int, QByteArray> roleNames() const override {
        QHash<int, QByteArray> roles;
         roles[TableDataRole] = "tabledata";
         roles[HeadingRole] = "heading";
         roles[UUIDRole] = "uuid";
         roles[NameRole] = "name";
         roles[DescriptionRole] = "description";
     return roles;
    }

    CustomTableModel(QObject* parent = Q_NULLPTR);
    Q_INVOKABLE void clear();
    int columnCount(const QModelIndex &parent) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    Q_INVOKABLE QString uuid(const QModelIndex &index);
    Q_INVOKABLE Element* element(const QModelIndex &index) const;
    Q_INVOKABLE Element* element(int listIndex) const;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QVariant headerData(int section, Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    void addData(const Element& element);

private:
    QList<Element> m_elementList;
};

#endif // CUSTOMTABLEMODEL_H
