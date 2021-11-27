
FROM node:12.14.1 as build-deps-wizard
RUN apt-get update && apt-get install -y libusb-1.0-0-dev libudev-dev openssl
WORKDIR /build
RUN git clone https://github.com/MyCryptoHQ/MyCrypto.git
WORKDIR /build/MyCrypto
RUN ls -l
RUN git checkout tags/2.5.52
RUN yarn
RUN yarn build
RUN echo "output.."
RUN ls  -l /build/MyCrypto/dist/web

# build final image
FROM nginx:alpine

WORKDIR  /usr/share/nginx
RUN rm -Rf html
COPY --from=build-deps-wizard /build/MyCrypto/dist/web ./html
COPY wizard ./wizard
RUN mkdir -p /etc/nginx/certs/
RUN mkdir /cert
RUN wget -O /etc/nginx/certs/my.ava.do.crt http://iso.ava.do/my.ava.do.crt
RUN wget -O /etc/nginx/certs/my.ava.do.key  http://iso.ava.do/my.ava.do.key

RUN ls -l /etc/nginx/certs/
COPY files/nginx.conf /etc/nginx
