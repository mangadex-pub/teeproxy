FROM golang:1.21-bookworm AS builder

WORKDIR /go/src/teeproxy
COPY . ./
RUN go build -o teeproxy

FROM debian:bookworm-slim AS runner

COPY --from=builder /go/src/teeproxy/teeproxy /usr/local/bin/teeproxy

RUN groupadd -r -g 9999 mangadex && useradd -u 9999 -r -g 9999 mangadex
USER mangadex
WORKDIR /tmp

COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
