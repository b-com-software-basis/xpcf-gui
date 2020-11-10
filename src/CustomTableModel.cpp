#include "customtablemodel.h"

CustomTableModel::CustomTableModel(QObject *parent):
    #ifdef USELISTMODEL
    QAbstractListModel(parent)
  #else
    QAbstractTableModel(parent)
  #endif
{
    //Element e("UUID","Name","Description");
    //addData(e);
}

int CustomTableModel::columnCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    if (parent.isValid())
        return 0;
    //return Element::dataCount();
    return 3;
}

int CustomTableModel::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    return m_elementList.size();
}

Qt::ItemFlags CustomTableModel::flags(const QModelIndex &index) const
{
#ifdef USELISTMODEL
    return QAbstractListModel::flags(index) | Qt::ItemIsEditable;
#else
    return QAbstractTableModel::flags(index) | Qt::ItemIsEditable;
#endif
}

Element * CustomTableModel::element(const QModelIndex &index) const
{
    if (!index.isValid())
        return new Element();
    if (index.row() >= m_elementList.size() || index.row() < 0)
        return new Element();


    return new Element(m_elementList.at(index.row()));
}

Q_INVOKABLE Element* CustomTableModel::element(int listIndex) const
{
    QModelIndex idx = this->index(listIndex,0);
    return element(idx);
}

QVariant CustomTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if (index.row() >= m_elementList.size() || index.row() < 0)
        return QVariant();

    const Element& elt = m_elementList.at(index.row());
    switch (role) {
    case UUIDRole:
        return elt.m_uuid;
    case NameRole:
        return elt.m_name;
    case DescriptionRole:
        return elt.m_description;
    case TableDataRole:
    {
        switch (index.column()) {
        case 0:
            return elt.m_uuid;
        case 1:
            return elt.m_name;
        case 2:
            return elt.m_description;
        default:
            break;;
        }
        break;
    }
    case HeadingRole:
    {
        if( index.row()==0){
            return true;
        }else{
            return false;
        }
    }
    default:
        break;
    }

    return QVariant();
}

QString CustomTableModel::uuid(const QModelIndex &index)
{
    return data(index,TableDataRole).value<QString>();
}

bool CustomTableModel::setData(const QModelIndex &index, const QVariant &value,
                               int role){
    if (!index.isValid() || role != Qt::EditRole ||
            index.row() < 0 || index.row() >= m_elementList.count())
        return false;
    Element &elt = m_elementList[index.row()];
    switch (index.column()) {
    case 0: {
        elt.m_uuid = value.toString();
        break;
    }
    case 1: {
        elt.m_name = value.toString();
        break;
    }
    case 2: {
        elt.m_description = value.toString();
        break;
    }
    default: Q_ASSERT(false);
    }
    emit dataChanged(index, index);
    return true;
}

QVariant CustomTableModel::headerData(int section,
                                      Qt::Orientation orientation,
                                      int role) const {
    if (role != Qt::DisplayRole)
        return QVariant();

    if (orientation == Qt::Horizontal) {
        switch (section) {
        case 0:
            return tr("UUID");
        case 1:
            return tr("Name");
        case 2:
            return tr("Description");
        default:
            return QVariant();
        }
    }
    return section + 1;
}

bool CustomTableModel::insertRows(int row, int count, const QModelIndex &){
    beginInsertRows(QModelIndex(), row, row + count - 1);
    for (auto i = 0; i < count; ++i)
        m_elementList.insert(row, Element());
    endInsertRows();
    return true;
}

bool CustomTableModel::removeRows(int row, int count, const QModelIndex &){
    beginRemoveRows(QModelIndex(), row, row + count - 1);
    for (auto i = 0; i < count; ++i)
        m_elementList.removeAt(row);
    endRemoveRows();
    return true;
}

void CustomTableModel::addData(const Element &elt){
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    this->m_elementList.append(elt);
    endInsertRows();
#ifdef USELISTMODEL
    QModelIndex idx = this->index( m_elementList.size() - 1);
#else
    QModelIndex idx = this->index( m_elementList.size() - 1,0);
#endif
    emit dataChanged(idx,idx);
}

void CustomTableModel::clear()
{
    beginResetModel();
    m_elementList.clear();
    endResetModel();
}
