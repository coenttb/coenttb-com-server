FROM swift:6.0.3-jammy as runtime
WORKDIR /app
COPY Server ./Server
COPY Public ./Public
COPY Resources ./Resources
# Create resource bundle directory and copy blog posts
RUN mkdir -p coenttb-com-server_Server\ Application.resources/Blog/Posts
COPY Sources/Server\ Application/Blog/Posts/ coenttb-com-server_Server\ Application.resources/Blog/Posts/
EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
