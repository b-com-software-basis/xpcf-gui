/**
 * @copyright Copyright (c) 2020 B-com http://www.b-com.com/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author Loïc Touraine
 *
 * @file
 * @brief description of file
 * @date 2020-09-12
 */

#ifndef DATAPATHS_H
#define DATAPATHS_H

#include <QString>

class DataPaths {

public:
    DataPaths();
    DataPaths(const DataPaths & r);
    ~DataPaths();
    const QString root();
    const QString bcomRoot();
    const QString tmp();

private:
    QString m_userRootPath;
    QString m_bcomRootPath;
};

#endif // DATAPATHS_H
