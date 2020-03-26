set(PLUGIN_SRCS

    superxdashplugin.cpp
    appslist.cpp
    systemfavourites.cpp

    ### DEBUG
    ../package/contents/ui/tools.js
    ../package/contents/ui/main.qml
    ../package/contents/ui/CompactRepresentation.qml
    ../package/contents/ui/IconItem.qml
    ../package/contents/ui/Dash.qml
    ../package/contents/ui/PaginatedGrid.qml
    ../package/contents/ui/AppGridContainer.qml
    ../package/contents/ui/Heading.qml
    ###
)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash)

add_library(superxdashplugin SHARED ${PLUGIN_SRCS})

install(TARGETS superxdashplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash/)
target_link_libraries(superxdashplugin
    Qt5::Quick
    KF5::KIOCore
)

