FROM golang:1.19-alpine3.16 AS builder

WORKDIR /go/src/teeproxy
COPY . ./
RUN go build -o teeproxy

FROM alpine:3.16 AS runner

RUN apk add --no-cache bash
COPY --from=builder /go/src/teeproxy/teeproxy /usr/local/bin/teeproxy

# We usually use 999 for mangadex, but it's taken on alpine for some reason
RUN addgroup --system --gid 1001 mangadex && \
    adduser  --system --uid 1001 --disabled-password --no-create-home --ingroup mangadex mangadex

USER mangadex
WORKDIR /tmp

COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
