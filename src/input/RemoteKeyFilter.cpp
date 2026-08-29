#include "RemoteKeyFilter.hpp"

RemoteKeyFilter::RemoteKeyFilter(QObject *parent)
    : QObject(parent) {}

bool RemoteKeyFilter::eventFilter(QObject *watched, QEvent *event) {
    if (event->type() == QEvent::KeyPress) {
        auto *keyEvent = static_cast<QKeyEvent *>(event);
        switch (keyEvent->key()) {
            case Qt::Key_Back:
            case Qt::Key_Escape:
            case Qt::Key_MediaPrevious:
                emit backTriggered();
                return true;
            case Qt::Key_Menu:
            case Qt::Key_Alt:
                emit menuTriggered();
                return true;
            default:
                break;
        }
    }
    return QObject::eventFilter(watched, event);
}
