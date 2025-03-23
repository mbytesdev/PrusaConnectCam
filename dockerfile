FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y  --no-install-recommends --no-install-suggests \
    curl \
    ca-certificates \
    ffmpeg \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

COPY prusa.sh /usr/local/bin/prusa
RUN chmod +x /usr/local/bin/prusa

ENTRYPOINT [ "prusa" ]