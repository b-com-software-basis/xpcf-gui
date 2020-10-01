#include "LoadSaveWidget.h"
#include <QFileDialog>
#include <QStandardPaths>
#include "xpcf/xpcf.h"
#include "xpcf/api/IModuleManager.h"

namespace xpcf = org::bcom::xpcf;

QString SaveWidget::save()
{
    QString filenameStr = QFileDialog::getSaveFileName(
                this,
                tr("Save"),
                QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation).first()+ "/.xpcf/",
                tr("XML files (*.xml)") );
    return filenameStr;
}

bool SaveWidget::load(SRef<xpcf::IComponentManager> xpcfComponentManager)
{
    QString filenameStr = QFileDialog::getOpenFileName(
                this,
                tr("Open"),
                QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation).first()+ "/.xpcf/",
                tr("XML files (*.xml)") );
    if( !filenameStr.isNull() )
    {
        xpcfComponentManager->load(filenameStr.toStdString().c_str());
        return true;
    }
    return false;
}
