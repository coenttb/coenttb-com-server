FROM swift:6.1.2-jammy AS builder

WORKDIR /build

# Copy Package files and any cached dependencies
COPY Package.* ./
COPY .build* .build/

# Configure git and resolve dependencies
ARG GH_PAT
RUN git config --global url."https://${GH_PAT}@github.com/".insteadOf "https://github.com/" && \
    swift package resolve --skip-update

# Copy source code
COPY . .

# Build only the Server executable (not tests)
RUN swift build -c release --product Server

# Runtime stage
FROM swift:6.1.2-jammy AS runtime

WORKDIR /app

# Copy all files from release directory
COPY --from=builder /build/.build/release/ ./
# Copy Public directory for static assets
COPY --from=builder /build/Public ./Public

EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
