FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json  ./
RUN npm ci || npm install
COPY . .
RUN npm run build

FROM nginxinc/nginx-unprivileged:alpine AS production
COPY --from=build /app/out /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
ENV BACKEND_URL=http://backend-nti:8000
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]