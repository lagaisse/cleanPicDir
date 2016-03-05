#!/bin/sh

# Copyright 2016 Kevin Lagaisse
# 
# Licensed under the Creative Commons BY-NC-SA 4.0 licence (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://creativecommons.org/licenses/by-nc-sa/4.0/
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This script does some cleaning in my pictures directories synced on windows
# So, it removes Thumbs.db et Desktop.ini


version() {
    echo "$0" # TODO 3
}

usage() {
    programName=$(basename "$0")
    echo "" 1>&2
    echo "Usage    : ${programName} DLPATH [forceroot]" 1>&2
    echo "" 1>&2
    echo "Startup:" 1>&2
    echo "    DLPATH   : root directory where you want to execute the script" 1>&2
    echo "    forceroot: (true or false) indicate if the script should allow the run by root, because of the use of the rm cmd" 1>&2
    echo "               false by default" 1>&2
    exit 1
}

scriptpath=$(dirname "$0")
datenow=$(date +%Y-%m-%d:%H:%M:%S)

dlpathperror() {
    echo "Error : dlPath is not a path" 1>&2
    usage
}

forbidrootrun() {
    if test "$(id -u)" = "0" 
    then
       echo "This script shouldn't be run as root" 1>&2
       usage
    fi
}

paramnberror() {
    echo "Error : program needs at least 1 parameter" 1>&2
    usage
}


findFiles() {
    local path="$1"
    find "${path}" -type f -name "Desktop.ini" -o -name "desktop.ini" -o -name "Thumbs.db" -o -name "thumbs.db"
}

if test $# -lt 1
then
    paramnberror
fi

dlPath=$(echo "$1"|tr -s '/')
dlPath=$(echo "${dlPath%/}")
echo "$dlPath"

if test ! -d "$dlPath"
then
    dlpathperror
fi


if test $# -eq 2
then
    if test $2 != "true"
    then
        forbidrootrun
    fi
else
    forbidrootrun
fi

echo "searching and deleting"
#renommer les fichiers en enlevant le début du nom du fichier qui serait en "[toto] nom du fichier"


findFiles "${dlPath}" | while read filepath
do

    echo [$datenow] RMing "${filepath}"
    rm -f "${filepath}"
done

echo "done"
exit 0
