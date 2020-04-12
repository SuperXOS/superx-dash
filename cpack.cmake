set(CPACK_GENERATOR "DEB")
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
set(CPACK_DEBIAN_PACKAGE_DEPENDS "qml-module-qtquick-shapes")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Camilo Higuita")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "MAUI Application")
set(CPACK_PACKAGE_VENDOR "Camilo Higuita")
set(CPACK_PACKAGE_CONTACT "Camilo Higuita <>")
#set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/ReadMe.txt")
#set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake ${CMake_VERSION_MAJOR}.${CMake_VERSION_MINOR}")
set(CPACK_SOURCE_STRIP_FILES "")

include(CPack)

 
