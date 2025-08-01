FROM swift:6.1.2-jammy AS builder

WORKDIR /build

# Copy package files first for better caching
COPY Package.swift Package.resolved ./

ARG GH_PAT
RUN git config --global url."https://${GH_PAT}@github.com/".insteadOf "https://github.com/"

# Resolve dependencies first - this layer will be cached if Package.resolved doesn't change
RUN swift package resolve

# Copy source code after dependencies are resolved
COPY Sources ./Sources
COPY Public ./Public

# Build only if source code or dependencies changed
RUN swift build --product Server -c release

FROM swift:6.1.2-jammy AS runtime

WORKDIR /app

COPY --from=builder /build/.build/release/ ./
COPY --from=builder /build/Public ./Public

EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
