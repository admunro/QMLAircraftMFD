cmake_minimum_required(VERSION 3.16)

project(AircraftMFD VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)

find_package(Qt6 REQUIRED COMPONENTS Quick Positioning Widgets)

# Make sure all required components were found
if(NOT Qt6_FOUND OR NOT Qt6Quick_FOUND OR NOT Qt6Positioning_FOUND)
    message(FATAL_ERROR "Could not find one or more required Qt components")
endif()

qt_standard_project_setup(REQUIRES 6.5)

# Add the include directory for headers
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)


qt_add_executable(appAircraftMFD
    src/main.cpp
    src/entitymodel.cpp
    src/entitymodel.h
    src/ownshipmodel.cpp
    src/ownshipmodel.h
)

qt_add_qml_module(appAircraftMFD
    URI AircraftMFD
    VERSION 1.0

    SOURCES
        src/entitymodel.h
        src/entitymodel.cpp
        src/ownshipmodel.h
        src/ownshipmodel.cpp
        src/entityutils.h
        src/entityutils.cpp
        src/fueltankmodel.h
        src/fueltankmodel.cpp
        src/enginemodel.h
        src/enginemodel.cpp
        src/weaponstationmodel.h
        src/weaponstationmodel.cpp

    QML_FILES
        ui/CustomButton.qml
        ui/Cockpit.qml
        ui/ControlWindow.qml
        ui/AircraftMFD.qml
        ui/NavPage.qml
        ui/RadarPage.qml
        ui/TemplatePage.qml

        ui/StorePage.qml
        ui/SensorPage.qml
        ui/FuelPage.qml
        ui/EnginePage.qml
        ui/MapDisplay.qml
        ui/EntityControl.qml
        ui/OwnshipControl.qml
        ui/fuelWidgets/FuelTankDisplay.qml
        ui/storesWidgets/WeaponStationDisplay.qml


    RESOURCES
        ui/img/engines.png
        ui/img/hydraulics.png
        ui/img/nav.png
        ui/img/sensor.png
        ui/img/stores.png
        ui/img/fighter-plane-basic.png
        ui/img/fighter-plane.png
        ui/storesWidgets/bomb.png
        ui/storesWidgets/sr_missile.png
        ui/storesWidgets/mr_missile.png

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
    PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Positioning
)

include(GNUInstallDirs)
install(TARGETS appAircraftMFD
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
