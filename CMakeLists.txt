cmake_minimum_required(VERSION 3.1)

project(AircraftMFD LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)

find_package(Qt5 COMPONENTS Core Quick Location REQUIRED)

add_executable(${PROJECT_NAME} "src/main.cpp"
               "qml.qrc"
               "src/entitymodel.cpp"
               "src/entityutils.cpp"
               "src/ownshipmodel.cpp"
               "src/fuelmodel.cpp")



target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick Qt5::Location)

# Add the include directory for headers
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
