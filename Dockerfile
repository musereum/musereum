FROM andyceo/musereum:builder as builder
MAINTAINER Andrey Andreev <andyceo@yandex.ru> (@andyceo)
COPY . /build/parity
RUN cd /build/parity && \
	cargo build --verbose --release --features final && \
	strip /build/parity/target/release/parity

FROM alpine
MAINTAINER Andrey Andreev <andyceo@yandex.ru> (@andyceo)
COPY --from=builder /build/parity/target/release/parity /musereum
EXPOSE 9001 9051
WORKDIR /root
VOLUME ["/root"]
EXPOSE 8080 8545 8180
ENTRYPOINT ["/musereum"]
