#!/bin/bash

# create-user.sh
#
# Copyright 2020 Justin Paul
# justin@jpaul.me
# https://jpaul.me
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function helpmenu {
   # Display Help
	echo "JPaul's Minio User Creator"
	echo
	echo "Syntax: ./createuser [-h|d|a|u|k|s]"
	echo "options:"
	echo "h     Print this Help."
	echo "d     Dry-Run, Generate keys, but don't apply to Minio."
	echo "a     Which Minio Client Alias should be used (required)."
	echo "u     Access key (or username) to use instead of generating one."
	echo "k     Access Key Length 8-128 are valid options."
	echo "s     Secret Key Length 8-128 are valid options."
	echo
}

#d efaults 
MC_ALIAS=NULL
NEW_ACCESS_KEY=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 20 | head -n 1)
NEW_SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 40 | head -n 1)
DRY_RUN=FALSE

# process CLI flags
while [ ! $# -eq 0 ]
do
	case "$1" in
		--help | -h)
			helpmenu
			exit
			;;
		--dry-run | -d)
			DRY_RUN=TRUE
			;;
		--alias | -a)
			MC_ALIAS=$2
			;;
		--user | -u)
		    	NEW_ACCESS_KEY=$2
			;;
		--access-key-length | -k)
			NEW_ACCESS_KEY=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w $2 | head -n 1)
			;;
		--secret-key-length | -s)
			NEW_SECRET_KEY=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w $2 | head -n 1)
			;;
	esac
	shift
done



# write credentials to file
echo "Generating conf file for new user"
echo $NEW_ACCESS_KEY
cat >  user-${NEW_ACCESS_KEY}.conf <<EOL
MINIO_ACCESS_KEY=${NEW_ACCESS_KEY}
MINIO_SECRET_KEY=${NEW_SECRET_KEY}
EOL

if [ $MC_ALIAS == 'NULL' ]
then
	helpmenu
	exit 0
fi


if [ $DRY_RUN == 'FALSE' ]
then
	mc admin user add $MC_ALIAS $NEW_ACCESS_KEY $NEW_SECRET_KEY
	mc admin group add $MC_ALIAS rwusers $NEW_ACCESS_KEY
	mc admin policy set $MC_ALIAS readwrite group=rwusers
	echo "User creation Complete"
else
	echo "Dry Run Complete"
fi
