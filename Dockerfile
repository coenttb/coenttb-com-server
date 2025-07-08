FROM swift:6.1.0-jammy as builder

WORKDIR /build

COPY ./Package.* .

ARG GH_PAT
RUN git config --global url."https://${GH_PAT}@github.com/".insteadOf "https://github.com/" && \
    swift package resolve --skip-update

COPY . .

RUN swift build -c release

FROM swift:6.1.0-jammy as runtime

WORKDIR /app

COPY --from=builder /build/Public ./Public
COPY --from=builder /build/.build/release/ ./

EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
