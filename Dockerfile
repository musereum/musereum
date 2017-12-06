FROM rust:1 as builder
RUN apt-get update -qy && apt-get install -qy build-essential libudev-dev
COPY . /musereum
WORKDIR /musereum
RUN cargo build --release
ENTRYPOINT ["./target/release/parity"]

FROM alpine
MAINTAINER Andrey Andreev <andyceo@yandex.ru> (@andyceo)
COPY --from=builder /musereum/target/release/parity /musereum
EXPOSE 9001 9051
WORKDIR /root
VOLUME ["/root"]
ENTRYPOINT ["musereum"]
CMD [""]
