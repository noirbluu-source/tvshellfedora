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

    // Instantiate and expose the application model
    AppLauncherModel appLauncherModel;
    engine.rootContext()->setContextProperty("appLauncherModel", &appLauncherModel);

    RemoteKeyFilter keyFilter;
    app.installEventFilter(&keyFilter);

    const QUrl url(u"qrc:/qt/qml/TVShell/qml/Main.qml"_qs);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url, &keyFilter](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) {
                QCoreApplication::exit(-1);
                return;
            }
            if (obj) {
                QObject::connect(&keyFilter, SIGNAL(backRequested()), obj, SLOT(handleBack()));
                QObject::connect(&keyFilter, SIGNAL(menuRequested()), obj, SLOT(handleMenu()));
            }
        },
        Qt::QueuedConnection
    );

    engine.load(url);

    return app.exec();
}
