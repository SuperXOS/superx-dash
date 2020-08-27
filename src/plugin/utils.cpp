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

#include "utils.h"

#include <QDBusConnection>
#include <QDBusReply>
#include <QDebug>
#include <KWindowSystem/KWindowSystem>

Utils::Utils(QObject *parent) : QObject(parent) {}

void Utils::showDesktop(bool show) {
  if (show) {
    minimizedWindows.clear();

    for (const auto wid : KWindowSystem::windows()) {
      KWindowInfo windowInfo(wid, {KWindowSystem::NET::Property::WMState});

      if (!windowInfo.isMinimized()) {
        KWindowSystem::minimizeWindow(windowInfo.win());
        minimizedWindows.append(windowInfo);
      }
    }
  } else {
    for (const auto windowInfo : minimizedWindows) {
      KWindowSystem::unminimizeWindow(windowInfo.win());
    }
  }
}
