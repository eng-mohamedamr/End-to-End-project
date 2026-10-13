FROM node:16 as build
WORKDIR /app
COPY package*.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build 

FROM nginx:alpine as production
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
ENV BACKEND_URL=http://backend:8000
EXPOSE 8080
USER 10001
CMD ["nginx", "-g", "daemon off;"]