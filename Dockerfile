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

# Copy Package.swift and Package.resolved files
COPY ./Package.swift ./Package.resolved ./

# Resolve and cache dependencies
RUN swift package resolve

# Copy the rest of the source code
COPY . .

# Build everything, with optimizations
RUN swift build -c release --static-swift-stdlib

# Switch to the staging area
WORKDIR /staging

# Copy main executable to staging area
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Server" ./

# Copy resources bundled by SPM to staging area
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

# Copy any resources from the public directory and views directory if the directories exist
# Ensure that by default, neither the directory nor any of its contents are writable.
RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# ================================
# Run image
# ================================
FROM ubuntu:focal

# Make sure all system packages are up to date.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get -q update && apt-get -q dist-upgrade -y && apt-get -q install -y ca-certificates tzdata && \
    rm -r /var/lib/apt/lists/*

# Create a vapor user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

# Switch to the new home directory
WORKDIR /app

# Copy built executable and any staged resources from builder
COPY --from=build --chown=vapor:vapor /staging /app

# Ensure all further commands run as the vapor user
USER vapor:vapor

# Let Docker bind to port 8080
EXPOSE 8080

# Start the Vapor service when the image is run, default to listening on 8080 in production environment
ENTRYPOINT ["./Server"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
