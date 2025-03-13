FROM swift:6.0.3-jammy as runtime
WORKDIR /app
COPY Server ./Server
COPY Public ./Public
COPY Resources ./Resources
COPY .build/release ./.build/release
# Copy resource bundle directly
COPY Sources/Server\ Application/Blog/Posts ./coenttb-com-server_Server\ Application.resources/Blog/Posts
EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
