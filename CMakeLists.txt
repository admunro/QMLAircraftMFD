cmake_minimum_required(VERSION 3.16)

project(AircraftMFD VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appAircraftMFD
    main.cpp
)

qt_add_qml_module(appAircraftMFD
    URI AircraftMFD
    VERSION 1.0

    QML_FILES
        Main.qml
        ui/AircraftMFD.qml
        ui/NavPage.qml
        ui/RadarPage.qml
        ui/TemplatePage.qml
        ui/map.qml
        ui/StorePage.qml
        ui/SensorPage.qml
        ui/FuelPage.qml
        ui/EnginePage.qml
        ui/MapDisplay.qml
        ui/fuelWidgets/FuelTankDisplay.qml

        scripts/PositionCalculator.js


    RESOURCES
        ui/img/engines.png
        ui/img/hydraulics.png
        ui/img/nav.png
        ui/img/sensor.png
        ui/img/stores.png
        ui/img/fighter-plane-basic.png
        ui/img/fighter-plane.png
        ui/img/plane.png


)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appAircraftMFD PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appAircraftMFD
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appAircraftMFD
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appAircraftMFD
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
