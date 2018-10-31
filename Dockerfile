FROM python:2-alpine

RUN apk add --update --no-cache \
            gcc \
            make \
            libc-dev \
            linux-headers

ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE=lms.settings

RUN mkdir /app/
WORKDIR /app/
COPY . /app/
RUN pip install -r requirements.txt

RUN mkdir -p /app/static

VOLUME /app/nginx

CMD ["sh", "/app/start_uwsgi.sh"]