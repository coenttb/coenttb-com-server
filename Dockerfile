FROM swift:6.1.0-jammy AS builder

WORKDIR /build

COPY Package.* ./

ARG GH_PAT
RUN git config --global url."https://${GH_PAT}@github.com/".insteadOf "https://github.com/"

COPY . .

RUN rm -f Package.resolved && rm -rf .build && swift package update

RUN swift package clean
RUN rm -rf .build
RUN swift build --product Server -c release

FROM swift:6.1.0-jammy AS runtime

WORKDIR /app

COPY --from=builder /build/.build/release/ ./
COPY --from=builder /build/Public ./Public

EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
