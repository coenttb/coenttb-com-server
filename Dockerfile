FROM swift:6.0.3-jammy as runtime
WORKDIR /app
COPY Server ./Server
COPY Public ./Public
COPY Resources ./Resources
COPY Sources ./Sources

# Create resource bundles in both possible locations where Swift looks for them
RUN mkdir -p "/app/coenttb-com-server_Server Application.resources/Blog/Posts" && \
    mkdir -p "/app/.build/x86_64-unknown-linux-gnu/release/coenttb-com-server_Server Application.resources/Blog/Posts" && \
    cp -r /app/Sources/Server\ Application/Blog/Posts/*.md "/app/coenttb-com-server_Server Application.resources/Blog/Posts/" && \
    cp -r /app/Sources/Server\ Application/Blog/Posts/*.md "/app/.build/x86_64-unknown-linux-gnu/release/coenttb-com-server_Server Application.resources/Blog/Posts/"

EXPOSE 8080
CMD ./Server serve --hostname 0.0.0.0 --port $PORT
