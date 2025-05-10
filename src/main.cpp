#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QGeoCoordinate>
#include <QLoggingCategory>

#include "entitymodel.h"
#include "ownshipmodel.h"
#include "enginemodel.h"
#include "fueltankmodel.h"
#include "weaponstationmodel.h"


int main(int argc, char *argv[])
{
    qSetMessagePattern("[%{time h:mm:ss.zzz} %{type}] %{message}");
    QLoggingCategory::setFilterRules("qt.qml.debug=true");

    QGuiApplication app(argc, argv);

    double timerRateMS = 20;


    OwnshipModel ownshipModel(QGeoCoordinate(48.7232, 11.5515), // Manching Airport
                              45.0,
                              400.0,
                              timerRateMS,
                              &app);


    FuelTankModel fuelTankModel(&app);

    fuelTankModel.add("Front Fuselage",
                      400,
                      350);

    fuelTankModel.add("Rear Fuselage",
                      400,
                      300);

    fuelTankModel.add("Port Wing",
                      300,
                      250);

    fuelTankModel.add("Starboard Wing",
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

    EngineModel engineModel(&app);

    engineModel.add("Port Engine", 50);
    engineModel.add("Starboard Engine", 45);


    WeaponStationModel weaponStationModel(&app);

    weaponStationModel.add("Port Wing Tip", "AIM-9X", "Air-to-Air");
    weaponStationModel.add("Starboard Wing Tip", "AIM-9X", "Air-to-Air");

    weaponStationModel.add("Port Fuselage Front", "AIM-120", "Air-to-Air");
    weaponStationModel.add("Port Fuselage Rear", "AIM-120", "Air-to-Air");
    weaponStationModel.add("Starboard Fuselage Front", "AIM-120", "Air-to-Air");
    weaponStationModel.add("Starboard Fuselage Rear", "AIM-120", "Air-to-Air");

    weaponStationModel.add("Port Under Wing", "GBU-12", "Air-to-Ground");
    weaponStationModel.add("Starboard Under Wing", "GBU-12", "Air-to-Ground");


    QQmlApplicationEngine engine;


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("entityModel",  &entityModel);
    engine.rootContext()->setContextProperty("ownshipModel", &ownshipModel);
    engine.rootContext()->setContextProperty("fuelTankModel", &fuelTankModel);
    engine.rootContext()->setContextProperty("engineModel", &engineModel);
    engine.rootContext()->setContextProperty("weaponStationModel", &weaponStationModel);



    engine.loadFromModule("AircraftMFD", "Cockpit");
    engine.loadFromModule("AircraftMFD", "ControlWindow");

    return app.exec();
}
