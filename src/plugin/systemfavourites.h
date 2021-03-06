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

#ifndef PLUGIN_SYSTEMFAVOURITES_H
#define PLUGIN_SYSTEMFAVOURITES_H

#include <QDBusInterface>
#include <QObject>

class SystemFavourites : public QObject {
 Q_OBJECT

 public:
  SystemFavourites(QObject *parent = nullptr);

private:
    QDBusInterface *ksmDBusInterface;

 public slots:
  void onShutdownClicked();
  void onLogoutClicked();
  void onRebootClicked();
};

#endif


