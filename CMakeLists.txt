cmake_minimum_required(VERSION 3.22)
project(TVShell LANGUAGES CXX)

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

qt_add_qml_module(tvshell
    URI "TVShell"
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/style/StyleTokens.qml
        qml/components/FocusCard.qml
        qml/components/NeonBadge.qml
)

target_link_libraries(tvshell PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
)
