# syntax = docker.runsoft.online:5000/docker.io/dockerfile:1.19.0
# BuildKit 为实验特性，开头都必须加上指令

FROM docker.runsoft.online:5000/docker.io/golang:1.25.6-alpine AS builder
#使用私有镜像仓库

LABEL stage=gobuilder
#构建后清理: docker image prune --force --filter label=stage=gobuilder

WORKDIR /build
# 工作目录

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=arm64 \
    GOPROXY=https://goproxy.cn,direct
# 设置交叉编译环境变量，指定目标架构 linux/amd64

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
#镜像加速
RUN apk update --no-cache && apk add --no-cache tzdata
#添加时区信息

ADD go.mod go.sum ./
RUN --mount=type=cache,target=/data/gopath \
    go mod download -x
#下载依赖并缓存

COPY . ./
RUN go build -ldflags="-s -w" -o srv
# 交叉编译

# FROM docker.runsoft.online:5000/docker.io/alpine:latest
FROM --platform=linux/arm64 docker.runsoft.online:5000/docker.io/alpine:arm-latest

WORKDIR /app
# 工作目录

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
#镜像加速

RUN apk add --no-cache ca-certificates tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata
# 安装必要的系统依赖（如时区、证书等，根据实际需求调整）

EXPOSE 80
# 使端口80可供此容器外的环境使用

VOLUME ["/app/cfg/"]
# 配置挂载点

COPY --from=builder /build/srv /app/srv
# 构建工作数据

CMD ["./srv"]