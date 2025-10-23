FROM eclipse-temurin:17-jre-jammy

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /necesse

# Build argument for server download URL
ARG SERVER_URL

# Download and extract server files
RUN if [ -z "$SERVER_URL" ]; then \
        echo "ERROR: SERVER_URL build argument is required"; \
        exit 1; \
    fi && \
    wget -O server.zip "$SERVER_URL" && \
    unzip server.zip && \
    rm server.zip && \
    # Move all files from the extracted subdirectory to the working directory
    mv necesse-server-*/* . && \
    rmdir necesse-server-* && \
    chmod +x Server.jar

# Create the full directory structure with proper permissions
RUN mkdir -p /root/.config/Necesse/saves/worlds && \
    chmod -R 755 /root/.config/Necesse

# Remove VOLUME declaration to avoid conflicts with bind mounts
# VOLUME ["/root/.config/Necesse/saves/worlds"]

# Expose both TCP and UDP ports
EXPOSE 14159/tcp
EXPOSE 14159/udp

# Set environment variables for server options
ENV SERVER_OPTS="-nogui"
ENV JAVA_OPTS=""

# Start the server with environment-configurable parameters
CMD ["sh", "-c", "java $JAVA_OPTS -jar Server.jar $SERVER_OPTS"]
