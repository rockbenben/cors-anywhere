# 使用 Alpine 为基础镜像，该镜像体积较小
FROM node:lts-alpine AS builder

WORKDIR /app

# 仅复制依赖清单，最大化缓存复用
COPY package.json package-lock.json ./

# 仅安装生产依赖，并清理缓存
RUN npm ci --omit=dev && \
    npm cache clean --force

# 使用多阶段构建
FROM node:lts-alpine

WORKDIR /app

ENV NODE_ENV=production

# 从构建阶段拷贝 node_modules，源码直接从构建上下文拷贝
COPY --from=builder /app/node_modules ./node_modules/
COPY lib/ ./lib/
COPY server.js ./server.js

# 设置服务运行的端口
EXPOSE 8080

# 启动服务
CMD ["node", "server.js"]
