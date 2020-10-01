#include "DataPaths.h"
#include <QDir>
#include <QUrl>


const QString USER_ROOT_PATH = "/.xpcf/";
const QString BCOM_ROOT_PATH = "/.bcom/";
const QString TMP_PATH = "tmp/";

DataPaths::DataPaths()
{
    m_userRootPath = QDir::homePath() + USER_ROOT_PATH;
    m_bcomRootPath = QDir::homePath() + BCOM_ROOT_PATH;
}

DataPaths::DataPaths(const DataPaths & r)
{
    m_userRootPath = r.m_userRootPath;
    m_bcomRootPath = r.m_bcomRootPath;
}

DataPaths::~DataPaths()
{

}

const QString DataPaths::root()
{
    return m_userRootPath;
}

const QString DataPaths::bcomRoot()
{
    return m_bcomRootPath;
}

const QString DataPaths::tmp()
{
    return root() + TMP_PATH;
}
