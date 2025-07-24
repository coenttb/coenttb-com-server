FROM swift:6.1.2-jammy AS builder

WORKDIR /build

COPY Package.* ./
COPY .build* .build/

ARG GH_PAT
RUN git config --global url."https://${GH_PAT}@github.com/".insteadOf "https://github.com/"

RUN swift package resolve

COPY . .

RUN swift build -c release --product Server

FROM swift:6.1.2-jammy AS runtime

WORKDIR /app

COPY --from=builder /build/.build/release/ ./
COPY --from=builder /build/Public ./Public

EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
