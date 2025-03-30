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
        QML_FILES ui/AircraftMFD.qml
        QML_FILES ui/NavPage.qml
        QML_FILES ui/RadarPage.qml
        QML_FILES ui/TemplatePage.qml
        QML_FILES ui/map.qml

    RESOURCES
        ui/img/engines.png
        ui/img/hydraulics.png
        ui/img/nav.png
        ui/img/sensor.png
        ui/img/stores.png
        QML_FILES ui/StorePage.qml
        QML_FILES ui/SensorPage.qml
        QML_FILES ui/HydPage.qml
        QML_FILES ui/EnginePage.qml
        QML_FILES ui/MapDisplay.qml

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
