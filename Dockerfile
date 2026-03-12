FROM nginx:alpine

# Info
LABEL maintainer="Eswar Krishna Maganti"
LABEL email="maganti.ek@gmail.com"

ARG USER=app
ARG GROUP=deployment
ARG ID=1001
ARG DEPLOYMENT_PATH=/usr/share/nginx/html
ARG NGINC_CONF_PATH=/etc/nginx

# Create the required dirs
RUN mkdir -p /usr/share/nginx/html /etc/nginx  /var/cache/nginx /var/run 

RUN addgroup -g $ID $GROUP && \
    adduser -D -u $ID -G $GROUP $USER

# update the ownership to nginx user
RUN chown -R app:deployment /usr/share/nginx/html /etc/nginx  /var/cache/nginx /var/run /run/

# Copy the application files
COPY app/index.html $DEPLOYMENT_PATH/

# Copy the Nginx Configuration for https
COPY app/nginx.conf $NGINC_CONF_PATH/

EXPOSE 443/tcp 8443/tcp

USER $USER

# Run the nginx in foreground
CMD ["nginx", "-g", "daemon off;"]