#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "input/RemoteKeyFilter.hpp"
#include "models/AppLauncherModel.hpp"

int main(int argc, char *argv[]) {
    qputenv("QT_QPA_PLATFORM", "wayland");
    qputenv("QSG_RENDER_LOOP", "threaded");

    QGuiApplication app(argc, argv);
    app.setApplicationName("tvshell");
    app.setOrganizationName("TVShell");

    QQmlApplicationEngine engine;

    AppLauncherModel appLauncherModel;
    engine.rootContext()->setContextProperty("appLauncherModel", &appLauncherModel);

    RemoteKeyFilter keyFilter;
    app.installEventFilter(&keyFilter);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [&keyFilter](QObject *obj, const QUrl &) {
            if (obj) {
                QObject::connect(&keyFilter, SIGNAL(backRequested()), obj, SLOT(handleBack()));
                QObject::connect(&keyFilter, SIGNAL(menuRequested()), obj, SLOT(handleMenu()));
            }
        },
        Qt::QueuedConnection
    );

    // Modern Qt 6 QML module loading API
    engine.loadFromModule("TVShell", "Main");

    return app.exec();
}
