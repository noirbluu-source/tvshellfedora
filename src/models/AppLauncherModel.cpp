#include "AppLauncherModel.hpp"
#include <QDebug>

AppLauncherModel::AppLauncherModel(QObject *parent)
    : QAbstractListModel(parent) {
    m_apps = {
        {"media_player", "NEO MEDIA CENTER", "qrc:/assets/icons/media.png", "CORE"},
        {"retro_arcade", "RETRO ARCADE 2000", "qrc:/assets/icons/arcade.png", "EMU"},
        {"cyber_deck", "TERMINAL CYBERDECK", "qrc:/assets/icons/terminal.png", "SYS"},
        {"net_stream", "CYBERSTREAM TV", "qrc:/assets/icons/stream.png", "LIVE"},
        {"sys_diagnostics", "DRM / GPU METRICS", "qrc:/assets/icons/metrics.png", "DIAG"},
        {"settings", "HARDWARE CONFIG", "qrc:/assets/icons/settings.png", "PREF"}
    };
}

int AppLauncherModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return static_cast<int>(m_apps.size());
}

QVariant AppLauncherModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_apps.size())
        return QVariant();

    const auto &item = m_apps[index.row()];
    switch (role) {
        case IdRole: return item.id;
        case TitleRole: return item.title;
        case IconRole: return item.icon;
        case TagRole: return item.tag;
        default: return QVariant();
    }
}

QHash<int, QByteArray> AppLauncherModel::roleNames() const {
    return {
        {IdRole, "appId"},
        {TitleRole, "title"},
        {IconRole, "iconSource"},
        {TagRole, "tag"}
    };
}

void AppLauncherModel::launchApp(int index) {
    if (index < 0 || index >= m_apps.size()) return;
    qInfo() << "Executing system launch for:" << m_apps[index].id;
    // System exec / Wayland sub-surface launching will hook in here
}
