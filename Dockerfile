FROM swift:6.0.1-jammy as runtime
WORKDIR /app
COPY Server ./Server
COPY Public ./Public
COPY Resources ./Resources
EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
