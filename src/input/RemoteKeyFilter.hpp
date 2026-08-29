#pragma once

#include <QObject>
#include <QEvent>
#include <QKeyEvent>

class RemoteKeyFilter : public QObject {
    Q_OBJECT
public:
    explicit RemoteKeyFilter(QObject *parent = nullptr);

signals:
    void backTriggered();
    void menuTriggered();

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;
};
