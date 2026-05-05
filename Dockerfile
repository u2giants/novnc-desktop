FROM lscr.io/linuxserver/webtop:ubuntu-mate

# Google Chrome
RUN apt-get update && apt-get install -y --no-install-recommends wget gnupg ca-certificates && \
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub | \
        gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/* && \
    # Wrapper forces --no-sandbox (required in Docker)
    printf '#!/bin/bash\nexec /usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage "$@"\n' \
        > /usr/local/bin/google-chrome && \
    chmod +x /usr/local/bin/google-chrome && \
    sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/local/bin/google-chrome|g' \
        /usr/share/applications/google-chrome.desktop

# Dropbox daemon
RUN wget -qO /tmp/dropbox.tar.gz "https://www.dropbox.com/download?plat=lnx.x86_64" && \
    tar xzf /tmp/dropbox.tar.gz -C /opt && \
    ln -sf /opt/.dropbox-dist/dropboxd /usr/local/bin/dropboxd && \
    rm /tmp/dropbox.tar.gz

# Insync + Caja integration for MATE file manager
RUN wget -qO- https://apt.insync.io/insynchq.gpg | \
        gpg --dearmor -o /usr/share/keyrings/insync.gpg && \
    chmod a+r /usr/share/keyrings/insync.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/insync.gpg] http://apt.insync.io/ubuntu noble non-free contrib" \
        > /etc/apt/sources.list.d/insync.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends insync insync-caja && \
    rm -rf /var/lib/apt/lists/*
