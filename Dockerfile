# 使用 Alpine 为基础镜像，该镜像体积较小
FROM node:lts-alpine as builder

WORKDIR /app

# 将本地代码复制到镜像中
COPY . .

# 安装依赖
RUN npm install && \
    npm cache clean --force && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# 使用多阶段构建
FROM node:lts-alpine

WORKDIR /app

# 从上一个阶段拷贝构建好的 node_modules 目录和必要的文件
COPY --from=builder /app/node_modules ./node_modules/
COPY --from=builder /app/lib/ ./lib/
COPY --from=builder /app/server.js ./server.js

# 设置服务运行的端口
EXPOSE 8080

# 启动服务
CMD ["node", "server.js"]
