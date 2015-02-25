#!/usr/bin/env bash
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# we're not using the latest version
exec ./vendor/logsearch-filters-common/bin/install_deps.sh 1.4.0

if [ ! -d $SCRIPT_DIR/../vendor/addon-common ]; then
  echo "Installing vendor/addon-common ..."

  mkdir -p $SCRIPT_DIR/../vendor/addon-common
  curl -L https://github.com/logsearch/logsearch-filters-common/archive/29eb050c37fafd6c0f3392baa786c5da14a46e7b.zip | tar -xzf- --strip-components 1 -C $SCRIPT_DIR/../vendor/addon-common

fi

# Install common dependancies
LOGSTASH_VERSION=1.4.0

# The logsearch-workspace already contains logstash, so use that
if [ -e /usr/local/logstash-$LOGSTASH_VERSION ] ; then
  echo "Detected that running in Logsearch Workspace.  Linking to logstash at /usr/local/logstash-$LOGSTASH_VERSION" 
  if [ ! -e vendor/logstash ] ; then
     ln -s /usr/local/logstash-$LOGSTASH_VERSION vendor/logstash
  fi
fi

if [ ! -f /var/vcap/packages/logstash/logstash/vendor/geoip/GeoLiteCity.dat ]; then
  LOGSTASH_PATH=$(readlink -f $SCRIPT_DIR/../vendor/logstash)
  echo "Symlinking /var/vcap/packages/logstash/logstash to $LOGSTASH_PATH so that GeoLiteCity.dat can be found ..."
  echo "This shouldn't be needed after Logstash 1.5"
  sudo mkdir -p /var/vcap/packages/logstash
  sudo ln -s $LOGSTASH_PATH /var/vcap/packages/logstash/logstash
fi
