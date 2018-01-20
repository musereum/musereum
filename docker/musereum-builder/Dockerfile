FROM rust:1
MAINTAINER Andrey Andreev <andyceo@yandex.ru> (@andyceo)
WORKDIR /build

# install tools and dependencies
RUN apt-get update && \
	apt-get install -y --force-yes --no-install-recommends \
        # make
        build-essential \
        software-properties-common \
        make \
        curl \
        wget \
        git \
        g++ \
        gcc \
        libc6 \
        libc6-dev \
        binutils \
        file \
        openssl \
        libssl-dev \
        libudev-dev \
        pkg-config \
        dpkg-dev \
        # evmjit dependencies
        zlib1g-dev \
        libedit-dev \
		libudev-dev && \
	apt-get install -y --force-yes cmake llvm

# install evmjit
RUN git clone https://github.com/debris/evmjit && \
	cd evmjit && \
	mkdir build && cd build && \
	cmake .. && make && make install && cd

# install rustup
# curl https://sh.rustup.rs -sSf | sh -s -- -y && \

# rustup directory
# PATH=/root/.cargo/bin:$PATH && \

# show backtraces
# RUST_BACKTRACE=1 && \
# build parity

#cd /build&&git clone https://github.com/paritytech/parity && \
#        cd parity && \
#	git pull&& \
#	git checkout $BUILD_TAG && \
#        cargo build --verbose --release --features final
