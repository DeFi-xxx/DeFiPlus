#!/bin/bash

dir=$(cd $(dirname $0); pwd)
rsync -av ${dir}/dist /var/www/html/
rsync -av ${dir}/cert /etc/nginx/
rsync -av ${dir}/*.conf /etc/nginx/sites-enabled/
nginx -t