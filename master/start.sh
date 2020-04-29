#!/bin/bash
set -e

/wait

if [ ! -e /var/run/cdh.init ]; then
    touch /var/run/cdh.init
    echo "-- Initialize container on first run --"

    /opt/cloudera/cm/schema/scm_prepare_database.sh -h cluster-db mysql scm scm "$MYSQL_ROOT_PASSWORD"
fi

echo "-- Start service --"
export CLOUDERA_ROOT=/opt/cloudera
export CMF_DEFAULTS=/etc/default/cloudera-scm-server

exec sudo --preserve-env=JAVA_HOME,CLOUDERA_ROOT,CMF_DEFAULTS -u cloudera-scm /bin/sh -c "/opt/cloudera/cm/bin/cm-server-pre && /opt/cloudera/cm/bin/cm-server"
