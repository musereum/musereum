FROM rust:1 as builder
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
