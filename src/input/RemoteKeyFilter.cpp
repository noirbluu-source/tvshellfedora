#include "RemoteKeyFilter.hpp"

RemoteKeyFilter::RemoteKeyFilter(QObject *parent)
    : QObject(parent) {}

bool RemoteKeyFilter::eventFilter(QObject *watched, QEvent *event) {
    if (event->type() == QEvent::KeyPress) {
        auto *keyEvent = static_cast<QKeyEvent *>(event);
        switch (keyEvent->key()) {
            case Qt::Key_Escape:
            case Qt::Key_Back:
                emit backRequested();
                return true;
            case Qt::Key_M:
            case Qt::Key_Menu:
                emit menuRequested();
                return true;
            default:
                break;
        }
    }
    return QObject::eventFilter(watched, event);
}
