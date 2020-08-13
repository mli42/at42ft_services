FROM alpine:3.12.0

MAINTAINER mli <mli@student.42.fr>

WORKDIR /tmp/

RUN apk update && apk upgrade && apk add --no-cache vim supervisor wget curl && \
	apk add telegraf --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing
