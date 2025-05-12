#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QGeoCoordinate>

#include "entitymodel.h"
#include "ownshipmodel.h"
#include "enginemodel.h"
#include "fueltankmodel.h"
#include "weaponstationmodel.h"


int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    double timerRateMS = 20;


    OwnshipModel ownshipModel(48.7232,  // Manching Airport
                              11.5515, 
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
    weaponStationModel.add("Starboard Fuselage Front", "AIM-120", "Air-to-Air");
    weaponStationModel.add("Port Fuselage Rear", "AIM-120", "Air-to-Air");
    weaponStationModel.add("Starboard Fuselage Rear", "AIM-120", "Air-to-Air");

    weaponStationModel.add("Port Under Wing", "GBU-12", "Air-to-Ground");
    weaponStationModel.add("Starboard Under Wing", "GBU-12", "Air-to-Ground");


    QQmlApplicationEngine engine;

    qmlRegisterType<EntityModel>("AircraftMFD", 1, 0, "EntityModel");
    qmlRegisterType<OwnshipModel>("AircraftMFD", 1, 0, "OwnshipModel");
    qmlRegisterType<FuelTankModel>("AircraftMFD", 1, 0, "FuelTankModel");
    qmlRegisterType<EngineModel>("AircraftMFD", 1, 0, "EngineModel");
    qmlRegisterType<WeaponStationModel>("AircraftMFD", 1, 0, "WeaponStationModel");


    // Set context properties before loading QML
    engine.rootContext()->setContextProperty("entityModel", &entityModel);
    engine.rootContext()->setContextProperty("ownshipModel", &ownshipModel);
    engine.rootContext()->setContextProperty("fuelTankModel", &fuelTankModel);
    engine.rootContext()->setContextProperty("engineModel", &engineModel);
    engine.rootContext()->setContextProperty("weaponStationModel", &weaponStationModel);

    
    // Load the main window
    engine.load(QUrl(QStringLiteral("qrc:/ui/Cockpit.qml")));
    engine.load(QUrl(QStringLiteral("qrc:/ui/ControlWindow.qml")));

    // Check for errors
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
