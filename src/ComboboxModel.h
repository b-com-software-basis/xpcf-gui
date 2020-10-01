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

#ifndef COMBOBOXMODEL_H
#define COMBOBOXMODEL_H


#include <QAbstractListModel>
#include <QStringList>


class ComboBoxModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ComboboxRoles {
        TextRole = Qt::UserRole + 1,
        UUIDRole
    };
    ComboBoxModel(QObject *parent = 0);
    ~ComboBoxModel(){}

    QHash<int, QByteArray> roleNames() const {
        QHash<int, QByteArray> roles;
        roles[TextRole] = "text";
        roles[UUIDRole] = "role";
        return roles;
    }

    const QStringList comboList();
    void setComboList(const QStringList &comboList);

    int count();
    void setCount(int cnt);

    Q_INVOKABLE void addElement(const QString &element);
    Q_INVOKABLE void removeElement(int index);

signals:

    void comboListChanged();
    void countChanged();

public slots:


private:

    QStringList m_comboList;
    int         m_count;
};

#endif // COMBOBOXMODEL_H
