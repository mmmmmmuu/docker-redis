#!/bin/sh

set -e

IP="${2:-$IP}"

if [ -z "$IP" ]; then # If IP is unset then discover it
    IP=$(hostname -I)
fi

echo " -- IP Before trim: '$IP'"
IP=$(echo ${IP}) # trim whitespaces
echo " -- IP Before split: '$IP'"
IP=${IP%% *} # use the first ip
export IP=${IP:-$IP}
echo " -- IP After trim: '$IP'"

mkdir -p /var/redis/log
chown redis:redis /var/redis/log

supervisor_conf=/supervisord.conf

echo "
[supervisord]
nodaemon=true" > $supervisor_conf

for p in 7000 7001
do
  conf_path=/redis-$p.conf
  data_dir=/data/redis-$p

  mkdir -p $data_dir
  chown redis:redis $data_dir

  echo "
[program:redis-$p]
command=redis-server $conf_path
autorestart=unexpected
user=redis
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0" >> $supervisor_conf
done

echo 'supervisor_conf ok!'

if [ -z ${maxmemory} ]
then
  maxmemory=1gb
fi

sed -i 's/${maxmemory}/'${maxmemory}'/g'  /redis-7000.conf
sed -i 's/${maxmemory}/'${maxmemory}'/g'  /redis-7001.conf
sed -i 's/$IP/'$IP'/g'  /redis-7001.conf

for p in 8000 8001 8002
do
    sleep 3 && echo $p' starting' && sed -i 's/$IP/'$IP'/g'  /data/sentinel-$p.conf && redis-sentinel /data/sentinel-$p.conf >> /dev/stdout &
done

supervisord -c $supervisor_conf
