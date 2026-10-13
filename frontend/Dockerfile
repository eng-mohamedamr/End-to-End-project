# LOCAL ONLY image: build the static export, then serve it with nginx (+ /api proxy).
# In AWS the same ./out folder is uploaded to S3 and served by CloudFront.
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci || npm install
COPY . .
ARG NEXT_PUBLIC_APP_VERSION=local
ENV NEXT_PUBLIC_APP_VERSION=${NEXT_PUBLIC_APP_VERSION} \
    NEXT_TELEMETRY_DISABLED=1
RUN npm run build

FROM nginxinc/nginx-unprivileged:1.29-alpine
COPY --from=build /app/out /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
ENV BACKEND_URL=http://backend:8000
USER 101
EXPOSE 8080
