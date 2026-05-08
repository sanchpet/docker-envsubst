# syntax=docker/dockerfile:1.4
# hadolint global ignore=DL3008

ARG GETTEXT_VERSION=0.25.1

# ============================================================================
# Stage 1: Build static envsubst binary from GNU gettext sources
# ============================================================================
FROM debian:trixie-slim AS build

ARG GETTEXT_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        make \
        libc6-dev \
        libunistring-dev \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL \
        "https://ftp.gnu.org/pub/gnu/gettext/gettext-${GETTEXT_VERSION}.tar.gz" \
       | tar xz -C /tmp \
    && cd "/tmp/gettext-${GETTEXT_VERSION}" \
    && ./configure \
        --disable-shared \
        --enable-static \
        --disable-nls \
        --disable-rpath \
        --disable-java \
        --disable-csharp \
        --disable-libasprintf \
        --disable-openmp \
        --disable-acl \
        --without-git \
        --without-cvs \
        --without-bzip2 \
        --without-xz \
        --without-emacs \
        CFLAGS="-Os" \
        LDFLAGS="-static" \
    && make -j"$(nproc)" -C gettext-runtime \
    && gcc -static -Os \
        -o /usr/local/bin/envsubst \
        gettext-runtime/src/envsubst-envsubst.o \
        gettext-runtime/gnulib-lib/libgrt.a \
    && strip /usr/local/bin/envsubst

# ============================================================================
# Stage 2: Minimal final image — scratch with just the static binary (~743 KB)
# ============================================================================
FROM scratch

COPY --from=build /usr/local/bin/envsubst /usr/local/bin/envsubst

ENTRYPOINT ["/usr/local/bin/envsubst"]
