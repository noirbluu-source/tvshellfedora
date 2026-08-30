cmake_minimum_required(VERSION 3.22)
project(tvshell LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Quick Qml)

qt_standard_project_setup()

qt_add_executable(tvshell
    src/main.cpp
    src/input/RemoteKeyFilter.hpp
    src/input/RemoteKeyFilter.cpp
    src/models/AppLauncherModel.hpp
    src/models/AppLauncherModel.cpp
)

set_source_files_properties(qml/Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(tvshell
    URI "TVShell"
    VERSION 1.0
    RESOURCE_PREFIX "/"
    QML_FILES
        qml/Main.qml
        qml/Theme.qml
        qml/navigation/FocusManager.qml
        qml/components/ZoneFocusScope.qml
        qml/components/AppShelfCard.qml
        qml/components/RotaryDialRail.qml
        qml/components/IndustrialTopBar.qml
        qml/components/TactileButton.qml
        qml/components/GlassDockBar.qml
)

target_link_libraries(tvshell PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
)
