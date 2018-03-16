FROM rust:1
LABEL maintainer="Andrey Andreev <andyceo@yandex.ru> (@andyceo)"
LABEL maintainer="Aler Denisov <aler.zampillo@gmail.com> (@alerdenisov)"

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