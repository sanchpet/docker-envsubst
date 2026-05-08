# docker-envsubst

The smallest possible Docker image with `envsubst` — **743 KB**, built from a static binary on a `scratch` base.

All other public images use Alpine (~8 MB). This one compiles `envsubst` from [GNU gettext](https://www.gnu.org/software/gettext/) sources with full static linking and packages just the binary into a `scratch` image.

## Usage

```bash
# Substitute all environment variables
echo 'Hello, $USER!' | docker run --rm -i -e USER=world sanchpet/envsubst

# Substitute only specific variables
echo 'a=$FOO b=$BAR' | docker run --rm -i -e FOO=1 -e BAR=2 sanchpet/envsubst '$FOO'
```

## How it works

Multi-stage build:

1. **Build stage** (`debian:trixie-slim`): downloads gettext sources, runs `./configure`, builds object files with `make`, then manually relinks `envsubst` with `gcc -static` to produce a self-contained ELF binary.
2. **Final stage** (`scratch`): copies only the stripped static binary. No OS, no shell, no libc.

The key insight: `libgrt.a` (gettext's internal gnulib archive) already bundles all unicode and locale dependencies, so no external `.so` files are needed at runtime.

## Build

```bash
docker build --build-arg GETTEXT_VERSION=0.25.1 -t envsubst .
```

## Image size comparison

| Image | Base | Size |
|---|---|---|
| **sanchpet/envsubst** | scratch | **743 KB** |
| bhgedigital/envsubst | Alpine | ~8 MB |
| nimasystems/envsubst | Alpine | ~8 MB |
| cirocosta/alpine-envsubst | Alpine | ~8 MB |
