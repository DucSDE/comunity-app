#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <QObject>
#include <QIcon>

#include "Backend/core/ComponentCreatorEngine.h"
#include "Backend/AuthHandler/authhandler.h"

int main(int argc, char *argv[])
{
    if (qEnvironmentVariableIsEmpty("QTGLESSTREAM_DISPLAY")) {
        qputenv("QT_QPA_EGLFS_PHYSICAL_WIDTH", QByteArray("213"));
        qputenv("QT_QPA_EGLFS_PHYSICAL_HEIGHT", QByteArray("120"));
    #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
        QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    #endif
    }
    QQuickWindow::setSceneGraphBackend("software");
    qputenv("MAIN_QML", "../Comunity/UI/main.qml");
    qputenv("DEPLOY_QML", "../Comunity/UI/splashScreen.qml");
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/UI/assets/images/hcl_logo.png"));

    QString API_KEY = QString(qgetenv("API_KEY"));
    qDebug() << API_KEY;

    ComponentCreatorEngine engine;
    engine.addImportPath("D:/Qt/6.3.1/mingw_64/qml/Component");

//    QQmlApplicationEngine engine;

    AuthHandler authHandler;
    authHandler.setAPIKey(API_KEY);

    QQmlContext *rootContext = engine.rootContext();
    rootContext->setContextProperty("QmlEngine", &engine);
    rootContext->setContextProperty("_authHandler", &authHandler);

    const QUrl url(qgetenv("MAIN_QML"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
