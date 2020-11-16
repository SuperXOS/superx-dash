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

#include "superxdashplugin.h"

#include <QDebug>
#include <QQmlEngine>

#include "appslist.h"
#include "systemfavourites.h"
#include "utils.h"

AppsList *appslist = nullptr;
SystemFavourites *systemFavourites = nullptr;
Utils *utils = nullptr;

static QObject *appsListSingletonProvider(QQmlEngine *e, QJSEngine *j) {
  Q_UNUSED(j)

  if (appslist == nullptr) {
    appslist = new AppsList(e);
  }

  return appslist;
}

static QObject *systemFavouritesSingletonProvider(QQmlEngine *e, QJSEngine *j) {
  Q_UNUSED(j)

  if (systemFavourites == nullptr) {
    systemFavourites = new SystemFavourites(e);
  }

  return systemFavourites;
}

static QObject *utilsSingletonProvider(QQmlEngine *e, QJSEngine *j) {
  Q_UNUSED(j)

  if (utils == nullptr) {
    utils = new Utils(e);
  }

  return utils;
}

void SuperXDashPlugin::registerTypes(const char *uri) {
  Q_ASSERT(QLatin1String(uri) == QLatin1String("com.superxos.dash"));

  qmlRegisterSingletonType<AppsList>(uri, 1, 0, "AppsList",
                                     appsListSingletonProvider);
  qmlRegisterSingletonType<SystemFavourites>(uri, 1, 0, "SystemFavourites",
                                             systemFavouritesSingletonProvider);
  qmlRegisterSingletonType<Utils>(uri, 1, 0, "Utils", utilsSingletonProvider);
}
