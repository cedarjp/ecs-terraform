#!/bin/sh

python manage.py collectstatic --noinput
uwsgi --ini uwsgi_conf.ini
