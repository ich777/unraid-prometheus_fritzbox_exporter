#!/bin/bash
PLUGIN_NAME="prometheus_fritzbox_exporter"
BASE_DIR="/usr/local/emhttp/plugins"
TMP_DIR="/tmp/${PLUGIN_NAME}_"$(echo $RANDOM)""
VERSION="$(date +'%Y.%m.%d')"

mkdir -p $TMP_DIR/$VERSION
cd $TMP_DIR/$VERSION
cp --parents -R $BASE_DIR/$PLUGIN_NAME/ $TMP_DIR/$VERSION/
chmod -R 755 $TMP_DIR/$VERSION/
rm $TMP_DIR/$VERSION/$BASE_DIR/$PLUGIN_NAME/README.md
makepkg -l y -c y $TMP_DIR/sourcepackage.txz
md5sum $TMP_DIR/sourcepackage.txz | awk '{print $1}' > $TMP_DIR/sourcepackage.txz.md5
rm -R $TMP_DIR/$VERSION/
chmod 755 $TMP_DIR/*