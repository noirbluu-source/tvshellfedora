#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QVector>

struct AppItem {
    QString id;
    QString title;
    QString subtitle;
    QString icon;
    QString command;
    QString category;
    bool enabled;
};

class AppLauncherModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum AppRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        SubtitleRole,
        IconRole,
        CommandRole,
        CategoryRole,
        EnabledRole
    };

    explicit AppLauncherModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Extensible helper methods
    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE int count() const;

private:
    void loadInitialApplications();
    QVector<AppItem> m_apps;
};
