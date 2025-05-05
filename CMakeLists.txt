cmake_minimum_required(VERSION 3.1)

project(AircraftMFD LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)

find_package(Qt5 COMPONENTS Core Quick Location REQUIRED)

add_executable(${PROJECT_NAME} "main.cpp" "qml.qrc")
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick Qt5::Location)

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
        src/fuelmodel.h
        src/fuelmodel.cpp

    QML_FILES
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


    RESOURCES
        ui/img/engines.png
        ui/img/hydraulics.png
        ui/img/nav.png
        ui/img/sensor.png
        ui/img/stores.png
        ui/img/fighter-plane-basic.png
        ui/img/fighter-plane.png



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
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
