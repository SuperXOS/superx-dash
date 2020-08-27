set(PLUGIN_SRCS

    appslist.cpp
    superxdashplugin.cpp
    systemfavourites.cpp
    utils.cpp

    ### DEBUG
    ../package/contents/ui/AppGridContainer.qml
    ../package/contents/ui/CompactRepresentation.qml
    ../package/contents/ui/Dash.qml
    ../package/contents/ui/Heading.qml
    ../package/contents/ui/IconItem.qml
    ../package/contents/ui/PaginatedGrid.qml
    ../package/contents/ui/SystemFavoritesContainer.qml
    ../package/contents/ui/main.qml
    ../package/contents/ui/TopContainer.qml

    ../package/contents/ui/tools.js

    ###
)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash)

add_library(superxdashplugin SHARED ${PLUGIN_SRCS})

install(TARGETS superxdashplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/superxos/dash/)
target_link_libraries(superxdashplugin
    Qt5::Quick
    KF5::KIOCore
    KF5::WindowSystem
    KF5::Runner
)

