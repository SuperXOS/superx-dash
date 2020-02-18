set(PLUGIN_SRCS

    superxdashplugin.cpp
    appslist.cpp
)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash)

add_library(superxdashplugin SHARED ${PLUGIN_SRCS})

install(TARGETS superxdashplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash/)
target_link_libraries(superxdashplugin
    Qt5::Quick
    KF5::KIOCore
)

