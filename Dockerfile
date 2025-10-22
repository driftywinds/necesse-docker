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

# Create volume mount point for world saves
VOLUME ["/root/.config/Necesse/saves/worlds"]

# Expose both TCP and UDP ports
EXPOSE 14159/tcp
EXPOSE 14159/udp

# Start the server with -nogui flag and interactive terminal
CMD ["java", "-jar", "Server.jar", "-nogui"]
