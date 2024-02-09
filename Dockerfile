FROM amd64/alpine:20230208
RUN apk update && \
    apk add --no-cache \
        openjdk-17-jre-headless=17.0.9+9-1~20.04

# App user
ARG APP_USER="mindustry"
ARG APP_UID=1368
RUN adduser --disabled-password --uid "$APP_UID" --no-create-home --gecos "$APP_USER" --shell /sbin/nologin "$APP_USER"

# Server binary
ARG APP_VERSION=141.3
ARG APP_BIN="/opt/server.jar"
RUN wget \
        --quiet \
        --output-document "$APP_BIN" \
        "https://github.com/Anuken/Mindustry/releases/download/v$APP_VERSION/server-release.jar"

# Volumes
ARG DATA_DIR="/mindustry"
RUN mkdir "$DATA_DIR" && \
    chown -R "$APP_USER":"$APP_USER" "$DATA_DIR"
VOLUME ["$DATA_DIR"]

#      GAME     STATUS
EXPOSE 6567/udp 6567/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENV APP_BIN="$APP_BIN" 
ENTRYPOINT exec java $JAVA_OPT -jar "$APP_BIN"
