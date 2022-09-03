FROM golang:1.19-alpine3.16 AS builder

WORKDIR /go/src/teeproxy
COPY . ./
RUN go build -o teeproxy

FROM alpine:3.16 AS runner

COPY --from=builder /go/src/teeproxy/teeproxy /usr/local/bin

ENTRYPOINT ["/usr/local/bin/teeproxy"]
