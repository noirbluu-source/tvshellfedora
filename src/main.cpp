#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include "input/RemoteKeyFilter.hpp"
#include "models/AppLauncherModel.hpp"

int main(int argc, char *argv[]) {
    // Force Wayland backend and Mesa hardware pipeline optimizations
    qputenv("QT_QPA_PLATFORM", "wayland");
    qputenv("QSG_RENDER_LOOP", "threaded");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    AppLauncherModel launcherModel;
    engine.rootContext()->setContextProperty("launcherModel", &launcherModel);

    RemoteKeyFilter keyFilter;
    app.installEventFilter(&keyFilter);

    const QUrl url(u"qrc:/qt/qml/TVShell/qml/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url, &keyFilter](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
        if (obj) {
            QObject::connect(&keyFilter, SIGNAL(backTriggered()), obj, SLOT(handleGlobalBack()));
            QObject::connect(&keyFilter, SIGNAL(menuTriggered()), obj, SLOT(handleGlobalMenu()));
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
