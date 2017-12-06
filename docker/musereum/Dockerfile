FROM andyceo/musereum:builder as builder
MAINTAINER Andrey Andreev <andyceo@yandex.ru> (@andyceo)
COPY . /build/parity
RUN cd /build/parity && \
	cargo build --verbose --release --features final && \
        #ls /build/parity/target/release/parity && \
        strip /build/parity/target/release/parity && \
 file /build/parity/target/release/parity&&mkdir -p /parity&& cp /build/parity/target/release/parity /parity&&\
#cleanup Docker image
 rm -rf /root/.cargo&&rm -rf /root/.multirust&&rm -rf /root/.rustup&&rm -rf /build&&\
 apt-get purge -y  \
        # make
        build-essential \
        # add-apt-repository
        software-properties-common \
        make \
        curl \
        wget \
        git \
        g++ \
        gcc \
        binutils \
        file \
        pkg-config \
        dpkg-dev \
        # evmjit dependencies
        zlib1g-dev \
        libedit-dev \
        cmake llvm-3.7-dev&&\
 rm -rf /var/lib/apt/lists/*
# setup ENTRYPOINT
EXPOSE 8080 8545 8180
ENTRYPOINT ["/parity/parity"]
