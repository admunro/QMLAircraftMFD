#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>


#include "entitymodel.h"


int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    double timerRateMS = 20;

    EntityModel entityModel(&app, timerRateMS);


    entityModel.addEntity("1",
                          "Bandit1",
                          48.7122,
                          11.2179,
                          "Mig 29",
                          400.0,
                          0.0);


    entityModel.addEntity("2",
                          "Bandit2",
                          48.3547,
                          11.7885,
                          "Su 35",
                          250.0,
                          270.0);


    entityModel.addEntity("3",
                          "Bandit3",
                          49.4542,
                          11.0796,
                          "Su 57",
                          300.0,
                          180.0);



    QQmlApplicationEngine engine;


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("entityModel", &entityModel);


    engine.loadFromModule("AircraftMFD", "Cockpit");
    engine.loadFromModule("AircraftMFD", "ControlWindow");

    return app.exec();
}
