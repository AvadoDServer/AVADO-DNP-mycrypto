
FROM node:12.14.1 as build-deps-wizard
RUN apt-get update && apt-get install -y libusb-1.0-0-dev libudev-dev openssl
WORKDIR /build
RUN git clone https://github.com/MyCryptoHQ/MyCrypto.git
WORKDIR /build/MyCrypto
RUN ls -l
RUN git checkout tags/2.2.2
RUN yarn
RUN yarn build
RUN echo "output.."
RUN ls  -l /build/MyCrypto/dist/web

WORKDIR /cert
RUN cp /etc/ssl/openssl.cnf .
RUN echo "[SAN]\nsubjectAltName=DNS:my.mycrypto.avado.dnp.dappnode.eth" >> openssl.cnf
RUN cat openssl.cnf
RUN PASSWORD=$(echo $(LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 20)) && \
    openssl genrsa -des3 -passout pass:${PASSWORD} -out server.pass.key 2048 && \
    openssl rsa -passin pass:${PASSWORD} -in server.pass.key -out server.key && \
    rm server.pass.key && \
    openssl req -new -key server.key -out server.csr \
        -reqexts SAN \
        -extensions SAN \
        -config openssl.cnf \
        -subj "/C=DE/ST=AVADO/L=AVADO/O=my.mycrypto.avado.dnp.dappnode.eth/OU=saskia@ava.do/CN=my.mycrypto.avado.dnp.dappnode.eth" && \
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
RUN ls -l /cert


# # build monitor
# WORKDIR /usr/src/app/monitor
# COPY monitor .
# RUN npm i --production

# build final image
FROM nginx:alpine


# WORKDIR /usr/src/app
# USER root

#RUN apk add -U --no-cache supervisor

WORKDIR  /usr/share/nginx
RUN rm -Rf html
COPY --from=build-deps-wizard /build/MyCrypto/dist/web ./html
COPY wizard ./wizard
RUN mkdir -p /etc/nginx/certs/
COPY --from=build-deps-wizard /cert/server.* /etc/nginx/certs/
RUN ls -l /etc/nginx/certs/
COPY files/nginx.conf /etc/nginx

# COPY --from=build-deps-wizard /usr/src/app/wizard/build /usr/src/monitor/wizard

# COPY files/supervisord.conf /etc/supervisord/

# ENTRYPOINT supervisord -n -c /etc/supervisord/supervisord.conf
