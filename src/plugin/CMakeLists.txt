set(PLUGIN_SRCS

    superxdashplugin.cpp
    appslist.cpp
    systemfavourites.cpp

    ### DEBUG
    ../package/contents/ui/main.qml
    ../package/contents/ui/IconItem.qml
    ../package/contents/ui/Dash.qml
    ###
)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash)

add_library(superxdashplugin SHARED ${PLUGIN_SRCS})

install(TARGETS superxdashplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash/)
target_link_libraries(superxdashplugin
    Qt5::Quick
    KF5::KIOCore
)

