ARG GO_VERSION=1.11.5

FROM golang:${GO_VERSION}-alpine AS builder

ENV GOFLAGS="-mod=readonly"
ENV CGO_ENABLED=0

RUN apk add --update --no-cache ca-certificates make git curl mercurial bzr

RUN mkdir -p /build
WORKDIR /build

COPY go.* /build/
RUN go mod download

COPY . /build
RUN go build -o tcheck .


FROM alpine:3.8

RUN apk add --update --no-cache ca-certificates tzdata

COPY --from=builder /build/tcheck /usr/bin/tcheck
