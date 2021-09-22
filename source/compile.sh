#!/bin/bash
## https://github.com/sberk42/fritzbox_exporter
cd ${DATA_DIR}
git clone https://github.com/sberk42/fritzbox_exporter
cd ${DATA_DIR}/fritzbox_exporter
git checkout master
go mod init module
go mod tidy
GOOS=linux GOARCH=amd64 go build -o fritzbox_exporter .
mkdir -p ${DATA_DIR}/v${LAT_V} ${DATA_DIR}/${LAT_V}/usr/bin ${DATA_DIR}/${LAT_V}/tmp/prom_fritz
cp ${DATA_DIR}/fritzbox_exporter/fritzbox_exporter ${DATA_DIR}/${LAT_V}/usr/bin/prometheus_fritzbox_exporter
wget -q -O ${DATA_DIR}/${LAT_V}/tmp/prom_fritz/metrics.json https://raw.githubusercontent.com/sberk42/fritzbox_exporter/master/metrics.json
wget -q -O ${DATA_DIR}/${LAT_V}/tmp/prom_fritz/metrics-lua.json https://raw.githubusercontent.com/sberk42/fritzbox_exporter/master/metrics-lua.json
wget -q -O ${DATA_DIR}/sourcepkg.txz https://github.com/ich777/unraid-prometheus_fritzbox_exporter/raw/master/source/sourcepackage.txz
tar -C ${DATA_DIR}/${LAT_V} -xvf ${DATA_DIR}/sourcepkg.txz

cd ${DATA_DIR}/${LAT_V}
makepkg -l y -c y ${DATA_DIR}/v$LAT_V/$APP_NAME-"$(date +'%Y.%m.%d')".tgz
cd ${DATA_DIR}/v$LAT_V
md5sum $APP_NAME-"$(date +'%Y.%m.%d')".tgz | awk '{print $1}' > $APP_NAME-"$(date +'%Y.%m.%d')".tgz.md5

## Cleanup
rm -R ${DATA_DIR}/fritzbox_exporter ${DATA_DIR}/$LAT_V ${DATA_DIR}/sourcepkg.txz
chown -R $UID:$GID ${DATA_DIR}/v$LAT_V/*