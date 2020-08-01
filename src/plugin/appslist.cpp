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

#include "appslist.h"

#include <KConfig>
#include <KIO/ListJob>
#include <QUrl>
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QProcess>
#include <KService>
#include <KIOWidgets/KRun>
#include <QVariantList>
#include <QVariantMap>
#include <QAction>

AppsList::AppsList(QObject *parent) : QObject(parent) {
  KConfig *config = new KConfig(QStringLiteral("com.superxos"));
  KConfigGroup *cfgGroup = new KConfigGroup(config, "Dash");

  runnerManager = new Plasma::RunnerManager(*cfgGroup, this);
}

void AppsList::search(QString query, int limit) {
  runnerManager->reset();
  runnerManager->setupMatchSession();
  runnerManager->launchQuery(query);
  connect(runnerManager, &Plasma::RunnerManager::matchesChanged,
          [=](QList<Plasma::QueryMatch> matches) {
            QVariantList searchResultList;
            int count = 0;

            for (auto match : matches) {
              QVariantMap searchedItem;

              searchedItemsMap.insert(count, match);

              searchedItem.insert("name", QVariant::fromValue(match.text()));
              searchedItem.insert("icon",
                                  QVariant::fromValue(match.iconName()));
              searchedItem.insert("url", match.data());
              searchedItem.insert("isApplication",
                                  match.runner()->name() == "Applications");
              searchedItem.insert("index", count);

              searchResultList << searchedItem;

              if (count == limit) {
                break;
              }

              count++;
            }

            emit searchResult(searchResultList);

            runnerManager->matchSessionComplete();
          });
}

void AppsList::runSearchedItem(int index) {
  runnerManager->run(searchedItemsMap[index]);
}

// void AppsList::appsList(QString url) {
//  KIO::ListJob *listJob = KIO::listRecursive(QUrl(url),
//  KIO::HideProgressInfo);

//  connect(listJob, &KIO::ListJob::entries,
//          [this](KIO::Job *job, const KIO::UDSEntryList &list) {
//            Q_UNUSED(job)
//            QJsonArray apps;

//            for (KIO::UDSEntry app : list) {
//              QJsonObject obj = {
//                  {"name", app.stringValue(app.UDS_NAME)},
//                  {"icon", app.stringValue(app.UDS_ICON_NAME)},
//                  {"url", app.stringValue(app.UDS_LOCAL_PATH)},
//                  {"mimeType", app.stringValue(app.UDS_MIME_TYPE)}};

//              apps.append(obj);
//            }

//            emit appsListResult(apps);
//          });
//}

void AppsList::openApp(QString path) {
  qDebug() << path;

  KService service(path);
  KRun::runApplication(service, {}, nullptr);
}
