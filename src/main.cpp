#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QGeoCoordinate>

#include "entitymodel.h"
#include "ownshipmodel.h"
#include "fuelmodel.h"
#include "enginesmodel.h"



int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    double timerRateMS = 20;


    OwnshipModel ownshipModel(QGeoCoordinate(48.7232, 11.5515), // Manching Airport
                              45.0,
                              400.0,
                              timerRateMS,
                              &app);


    FuelModel fuelModel(&app);

    fuelModel.addFuelTank("Front Fuselage",
                          400,
                          350);

    fuelModel.addFuelTank("Rear Fuselage",
                          400,
                          300);

    fuelModel.addFuelTank("Port Wing",
                          300,
                          250);

    fuelModel.addFuelTank("Starboard Wing",
                          300,
                          200);




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

    EnginesModel enginesModel(&app);

    enginesModel.addEngine("Port Engine", 50);
    enginesModel.addEngine("Starboard Engine", 45);


    QQmlApplicationEngine engine;


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("entityModel",  &entityModel);
    engine.rootContext()->setContextProperty("ownshipModel", &ownshipModel);
    engine.rootContext()->setContextProperty("fuelModel",    &fuelModel);
    engine.rootContext()->setContextProperty("enginesModel", &enginesModel);


    engine.loadFromModule("AircraftMFD", "Cockpit");
    engine.loadFromModule("AircraftMFD", "ControlWindow");

    return app.exec();
}
