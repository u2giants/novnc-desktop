FROM lscr.io/linuxserver/webtop:ubuntu-mate

# Google Chrome
RUN apt-get update && apt-get install -y --no-install-recommends wget gnupg ca-certificates && \
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub | \
        gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Dropbox daemon
RUN wget -qO /tmp/dropbox.tar.gz "https://www.dropbox.com/download?plat=lnx.x86_64" && \
    tar xzf /tmp/dropbox.tar.gz -C /opt && \
    ln -sf /opt/.dropbox-dist/dropboxd /usr/local/bin/dropboxd && \
    rm /tmp/dropbox.tar.gz

# Insync (using noble repo — update to resolute when available)
RUN gpg --no-default-keyring \
        --keyring gnupg-ring:/usr/share/keyrings/insync.gpg \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys ACCAF35C && \
    chmod a+r /usr/share/keyrings/insync.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/insync.gpg] http://apt.insynchq.com/ubuntu noble non-free" \
        > /etc/apt/sources.list.d/insync.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends insync && \
    rm -rf /var/lib/apt/lists/*
