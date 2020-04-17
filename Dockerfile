FROM golang:1.14-alpine as builder

COPY . /build/

WORKDIR /build/

RUN apk add --no-cache git build-base

RUN go mod download \
  && go build ./cmd/grumble/ \
  && go test -v ./...

FROM alpine:edge

COPY --from=builder /build/grumble /usr/bin/grumble

ENV DATADIR /data

RUN mkdir /data

WORKDIR /data

VOLUME /data

EXPOSE 64738/tcp
EXPOSE 64738/udp

ENTRYPOINT [ "/usr/bin/grumble", "--datadir", "/data", "--log", "/data/grumble.log" ]
