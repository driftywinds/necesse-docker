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

# Create entrypoint script
RUN cat > /entrypoint.sh << 'ENTRYPOINT_EOF'
#!/bin/bash
set -e

# Default values
: ${JAVA_OPTS:=""}
: ${SERVER_OPTS:="-nogui"}

# Build the full Java command
JAVA_CMD="java"

# Add JAVA_OPTS if provided
if [ -n "$JAVA_OPTS" ]; then
    JAVA_CMD="$JAVA_CMD $JAVA_OPTS"
fi

# Add jar file
JAVA_CMD="$JAVA_CMD -jar Server.jar"

# Add SERVER_OPTS if provided
if [ -n "$SERVER_OPTS" ]; then
    JAVA_CMD="$JAVA_CMD $SERVER_OPTS"
fi

echo "Starting Necesse server with command: $JAVA_CMD"
echo "Memory limits: $(echo $JAVA_OPTS | grep -o '\-Xm[sx][^ ]*' || echo 'none specified')"

# Execute the command
exec $JAVA_CMD
ENTRYPOINT_EOF

RUN chmod +x /entrypoint.sh

# Expose both TCP and UDP ports
EXPOSE 14159/tcp
EXPOSE 14159/udp

# Set default environment variables
ENV SERVER_OPTS="-nogui"
ENV JAVA_OPTS="-Xmx2G -Xms1G"

# Use the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
