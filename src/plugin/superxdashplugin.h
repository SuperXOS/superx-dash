// clang-format off
/********************************************************************************
 *    superx-dash is a part of SuperX Open Source Project                       *
 *                                                                              *
 *    Copyright (C) 2020 Libresoft Technology Pvt. Ltd.                         *
 *    Author: Anupam Basak <anupam.basak27@gmail.com>                           *
 *                                                                              *
 *    This program is free software: you can redistribute it and/or modify      *
 *    it under the terms of the GNU General Public License as published by      *
 *    the Free Software Foundation, either version 3 of the License, or         *
 *    (at your option) any later version.                                       *
 *                                                                              *
 *    This program is distributed in the hope that it will be useful,           *
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 *    GNU General Public License for more details.                              *
 *                                                                              *
 *    You should have received a copy of the GNU General Public License         *
 *    along with this program.  If not, see <https://www.gnu.org/licenses/>.    *
 *                                                                              *
 ********************************************************************************/
// clang-format on

#ifndef PLUGIN_SUPERXDASHPLUGIN
#define PLUGIN_SUPERXDASHPLUGIN

#include <QQmlExtensionPlugin>

class SuperXDashPlugin : public QQmlExtensionPlugin {
  // TODO HACK DELETEME :
  // Initlally plugin was not loading and was showing an error : plugin metadata
  // could not be extracted from libsuperxdashplugin.so Was testing by manually
  // placing generated metadata.json into the plugin dir and providing the FILE
  // in Q_PLUGIN_METADATA and it worked. Then removed the metadata.json file
  // that was manually placed and since then it works. Doesnt show the error any
  // more
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
  void registerTypes(const char *uri) override;
};

#endif
