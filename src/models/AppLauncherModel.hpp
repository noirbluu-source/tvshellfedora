#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QVector>

struct AppItem {
    QString id;
    QString title;
    QString icon;
    QString tag;
};

class AppLauncherModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum AppRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        IconRole,
        TagRole
    };

    explicit AppLauncherModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void launchApp(int index);

private:
    QVector<AppItem> m_apps;
};
