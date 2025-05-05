#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QGeoCoordinate>

#include "entitymodel.h"
#include "ownshipmodel.h"
#include "fuelmodel.h"


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



    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/ui/AircraftMFD.qml"));


    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                         &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
        engine.load(url);


    engine.rootContext()->setContextProperty("entityModel", &entityModel);
    engine.rootContext()->setContextProperty("ownshipModel", &ownshipModel);
    engine.rootContext()->setContextProperty("fuelModel", &fuelModel);

    engine.load("qrc:/ui/AircraftMFD.qml");
    engine.load("qrc:/ui/ControlWindow.qml");

    return app.exec();
}
