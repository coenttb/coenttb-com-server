FROM swift:6.1.2-jammy AS builder

WORKDIR /build

COPY Package.* ./

ARG GH_PAT
RUN git config --global url."https://${GH_PAT}@github.com/".insteadOf "https://github.com/"

# Clear all caches
RUN rm -rf ~/.swiftpm /tmp/swift-* ~/.cache/org.swift.swiftpm

# Resolve dependencies
RUN swift package resolve

COPY . .

# Clean build directory
RUN swift package clean && rm -rf .build

# Try size optimization first (usually most stable)
RUN swift build --product Server -c release -Xswiftc -Osize || \
    # If that fails, try with devirtualizer disabled
    swift build --product Server -c release \
        -Xswiftc -Xfrontend \
        -Xswiftc -disable-sil-devirtualizer || \
    # Last resort: minimal optimization
    swift build --product Server -c release \
        -Xswiftc -O \
        -Xswiftc -disable-sil-perf-optzns

FROM swift:6.1.2-jammy AS runtime

WORKDIR /app

COPY --from=builder /build/.build/release/ ./
COPY --from=builder /build/Public ./Public

EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
