# syntax=docker/dockerfile:1.2
# ================================
# Build image
# ================================
FROM swift:6.0.1-focal as build

# Install OS updates and, if needed, sqlite3 and OpenSSL development libraries
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y \
          libssl-dev \
          sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Set up a build area
WORKDIR /build

# Set up git to use GitHub credentials for private repositories
# Using Docker's secret to avoid exposing credentials
RUN --mount=type=secret,id=github_token \
    git config --global url."https://$(cat /run/secrets/github_token)@github.com/".insteadOf "https://github.com/"

# First, copy only package files to cache dependencies
COPY ./Package.swift ./Package.resolved ./

# Create a separate layer for package resolution
# This will be cached unless Package.swift or Package.resolved change
RUN --mount=type=cache,target=/root/.cache/org.swift.swiftpm \
    --mount=type=cache,target=/root/.cache/swiftpm \
    swift package resolve

# Copy source code, excluding files in .dockerignore
COPY . .

# Build with caching and optimizations
RUN --mount=type=cache,target=/root/.cache/org.swift.swiftpm \
    --mount=type=cache,target=/root/.cache/swiftpm \
    --mount=type=cache,target=/build/.build \
    swift build -c release --static-swift-stdlib

# Switch to the staging area
WORKDIR /staging

# Copy main executable and resources
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Server" ./ \
    && find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \; \
    && [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true \
    && [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# ================================
# Run image
# ================================
FROM ubuntu:focal

# Make sure all system packages are up to date in a single layer
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y ca-certificates tzdata \
    && rm -r /var/lib/apt/lists/*

# Create a vapor user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

WORKDIR /app
COPY --from=build --chown=vapor:vapor /staging /app

USER vapor:vapor
EXPOSE 8080

ENTRYPOINT ["./Server"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
