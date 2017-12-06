FROM rust:1 as builder
RUN apt-get install -qy libudev-dev libusb-1.0-0-dev libfox-1.6-dev
COPY . /musereum
WORKDIR /musereum
RUN cargo build --release
ENTRYPOINT ["parity"]

FROM alpine
MAINTAINER Andrey Andreev <andyceo@yandex.ru> (@andyceo)
COPY --from=builder /musereum/parity /musereum
EXPOSE 9001 9051
WORKDIR /root
VOLUME ["/root"]
ENTRYPOINT ["musereum"]
CMD [""]
