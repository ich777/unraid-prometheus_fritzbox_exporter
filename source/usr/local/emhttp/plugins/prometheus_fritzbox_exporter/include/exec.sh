#!/bin/bash

function get_fritzbox_username(){
echo -n "$(cat /boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg | grep "fritz_username=" | cut -d '=' -f2-)"
}

function get_fritzbox_password(){
echo -n "$(cat /boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg | grep "fritz_password=" | cut -d '=' -f2-)"
}

function get_fritzbox_additional(){
echo -n "$(cat /boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg | grep "fritz_additional=" | cut -d '=' -f2-)"
}

function get_exporter_address(){
echo -n "$(cat /boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg | grep "exporter_address=" | cut -d '=' -f2-)"
}

function get_exporter_metrics(){
echo -n "$(cat /boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg | grep "exporter_metrics_file=" | cut -d '=' -f2-)"
}

function get_exporter_luametrics(){
echo -n "$(cat /boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg | grep "exporter_luametrics_file=" | cut -d '=' -f2-)"
}

function change_fritz_settings(){
sed -i "/fritz_username=/c\fritz_username=${1}" "/boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg"
sed -i "/fritz_password=/c\fritz_password=${2}" "/boot/config/plugins/prometheus_fritzbox_exporter/settings.cfg"
kill $(pidof prometheus_fritzbox_exporter)
echo -n "$(echo "/usr/bin/prometheus_fritzbox_exporter -username=$1 -password=$2 -listen-address=$3 -metrics-file=/boot/config/plugins/prometheus_fritzbox_exporter/$4 -lua-metrics-file=/boot/config/plugins/prometheus_fritzbox_exporter/$5 $6" | at now)"
}

function get_status(){
if [ ! -z "$(pidof prometheus_fritzbox_exporter)" ]; then
  echo -e "running"
else
  echo "stopped"
fi
}

function start(){
echo -n "$(echo "/usr/bin/prometheus_fritzbox_exporter -username=$1 -password=$2 -listen-address=$3 -metrics-file=/boot/config/plugins/prometheus_fritzbox_exporter/$4 -lua-metrics-file=/boot/config/plugins/prometheus_fritzbox_exporter/$5 $6" | at now)"
}

function stop_exporter(){
echo -n "$(kill $(pidof prometheus_fritzbox_exporter))"
}

$@
