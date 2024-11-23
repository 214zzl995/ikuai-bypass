FROM golang:1.23.3-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o ikuai-bypass .


FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/ikuai-bypass .
RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone
ENV TZ=Asia/Shanghai
CMD ["./ikuai-bypass", "-c", "/etc/ikuai-bypass/config.yml"]
