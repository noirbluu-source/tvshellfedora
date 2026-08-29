#include "AppLauncherModel.hpp"

AppLauncherModel::AppLauncherModel(QObject *parent)
    : QAbstractListModel(parent) {
    loadInitialApplications();
}

void AppLauncherModel::loadInitialApplications() {
    beginResetModel();
    m_apps = {
        {
            "youtube",
            "YouTube",
            "Watch videos, live streams, and clips",
            "qrc:/assets/icons/youtube.png",
            "chromium --app=https://www.youtube.com/tv",
            "Media",
            true
        },
        {
            "vlc",
            "VLC Media Player",
            "Local video & audio player",
            "qrc:/assets/icons/vlc.png",
            "vlc",
            "Media",
            true
        },
        {
            "file_browser",
            "File Browser",
            "Explore local and USB storage",
            "qrc:/assets/icons/files.png",
            "nemo",
            "System",
            true
        },
        {
            "settings",
            "System Settings",
            "Display, network, audio, and device configuration",
            "qrc:/assets/icons/settings.png",
            "tvshell-settings",
            "System",
            true
        },
        {
            "app_store",
            "App Store",
            "Discover and install Flatpak TV applications",
            "qrc:/assets/icons/store.png",
            "flatpak",
            "Utilities",
            true
        }
    };
    endResetModel();
}

int AppLauncherModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) {
        return 0;
    }
    return static_cast<int>(m_apps.size());
}

QVariant AppLauncherModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_apps.size()) {
        return QVariant();
    }

    const auto &app = m_apps.at(index.row());

    switch (role) {
        case IdRole: return app.id;
        case TitleRole: return app.title;
        case SubtitleRole: return app.subtitle;
        case IconRole: return app.icon;
        case CommandRole: return app.command;
        case CategoryRole: return app.category;
        case EnabledRole: return app.enabled;
        default: return QVariant();
    }
}

QHash<int, QByteArray> AppLauncherModel::roleNames() const {
    return {
        {IdRole, "appId"},
        {TitleRole, "title"},
        {SubtitleRole, "subtitle"},
        {IconRole, "icon"},
        {CommandRole, "command"},
        {CategoryRole, "category"},
        {EnabledRole, "enabled"}
    };
}

QVariantMap AppLauncherModel::get(int row) const {
    if (row < 0 || row >= m_apps.size()) {
        return QVariantMap();
    }

    const auto &app = m_apps.at(row);
    return {
        {"appId", app.id},
        {"title", app.title},
        {"subtitle", app.subtitle},
        {"icon", app.icon},
        {"command", app.command},
        {"category", app.category},
        {"enabled", app.enabled}
    };
}

int AppLauncherModel::count() const {
    return static_cast<int>(m_apps.size());
}
