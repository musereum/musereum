FROM musereum/builder:stable as build
LABEL maintainer="Andrey Andreev <andyceo@yandex.ru> (@andyceo)"
LABEL maintainer="Aler Denisov <aler.zampillo@gmail.com> (@alerdenisov)"
WORKDIR /build
COPY . /build/node
RUN cd /build/node && \
  	cargo build --verbose --release --features final && \
  	strip /build/node/target/release/musereum


FROM debian:stretch-slim
LABEL maintainer="Andrey Andreev <andyceo@yandex.ru> (@andyceo)"
LABEL maintainer="Aler Denisov <aler.zampillo@gmail.com> (@alerdenisov)"
WORKDIR /root
RUN apt-get update && \
  	apt-get install -y --force-yes --no-install-recommends openssl && \
    apt-get clean && apt-get autoremove && rm -r /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/*
COPY --from=build /build/node/target/release/musereum /musereum
VOLUME ["/root"]
