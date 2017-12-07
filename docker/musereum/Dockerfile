FROM andyceo/musereum:builder as builder
MAINTAINER Andrey Andreev <andyceo@yandex.ru> (@andyceo)
COPY . /build/parity
RUN cd /build/parity && \
	cargo build --verbose --release --features final && \
	strip /build/parity/target/release/parity && \
	mkdir -p /parity && cp /build/parity/target/release/parity /parity
	
EXPOSE 8080 8545 8180
ENTRYPOINT ["/parity/parity"]
