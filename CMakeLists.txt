cmake_minimum_required(VERSION 3.10)

set(SUPERX_DASH_VERSION 0.1.0)
project(superx-dash VERSION ${SUPERX_DASH_VERSION})

set(REQUIRED_QT_VERSION 5.10.0)
set(REQUIRED_KF5_VERSION 5.60)

find_package(ECM ${REQUIRED_KF5_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})

find_package(KF5 REQUIRED Plasma)
find_package(Qt5 REQUIRED Quick)

add_subdirectory(src)
