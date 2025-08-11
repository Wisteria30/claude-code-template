FROM node:22

# ---------- go install ----------
ARG GO_VERSION=1.24.4
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${arch}.tar.gz" -o /tmp/go.tgz; \
    rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go.tgz; \
    rm /tmp/go.tgz
ENV PATH="/usr/local/go/bin:${PATH}"
# ---------- go end ----------

ARG TZ
ENV TZ="$TZ"

# ---------- Git ≥ 2.48 で worktree.useRelativePaths を有効 ----------
#   * sid(unstable) を追加して git* のみ優先度 990 で取得
#   * Git 2.48 以上で worktree.useRelativePaths が正式サポート
#     ref: git-config(2.48) docs  [oai_citation:0‡git-scm.com](https://git-scm.com/docs/git-config/2.48.0?utm_source=chatgpt.com)
#   * sid に入っている git 2.50.0-1 をインストール（2025-06-30 時点）
#     ref: Debian sid package list  [oai_citation:1‡packages.debian.org](https://packages.debian.org/sid/git?utm_source=chatgpt.com)
RUN set -eux; \
    echo 'deb http://deb.debian.org/debian sid main' > /etc/apt/sources.list.d/sid.list; \
    printf 'Package: *\nPin: release a=sid\nPin-Priority: 100\n\n' \
        >  /etc/apt/preferences.d/git-from-sid; \
    printf 'Package: git*\nPin: release a=sid\nPin-Priority: 990\n' \
        >> /etc/apt/preferences.d/git-from-sid; \
    apt-get update; \
    apt-get install -y --no-install-recommends git; \
    git --version;
# ---------- Git section end ----------

# Install basic development tools and iptables/ipset
RUN apt update && apt install -y less \
  procps \
  sudo \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  tmux \
  vim \
  libnspr4 \
  libnss3 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libgbm1 \
  libxkbcommon0 \
  libxss1 \
  libgtk-3-0 \
  libasound2 \
  libxshmfence1

# 日本語フォントと必要な依存関係をインストール
RUN apt install -y \
    fonts-liberation \
    fonts-noto-cjk \
    fonts-ipafont-gothic \
    fonts-ipafont-mincho \
    locales \
    && locale-gen ja_JP.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R node:node /usr/local/share

ARG USERNAME=node

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/node/.claude && \
  chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace

RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_0.18.2_${ARCH}.deb" && \
  rm "git-delta_0.18.2_${ARCH}.deb"

# Set up non-root user
USER node

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV GOPATH=/home/node/go
ENV PATH=$PATH:/usr/local/share/npm-global/bin:$GOPATH/bin
ENV PATH=$PATH:/home/node/.local/bin

# Install uvx
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Default powerline10k theme
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install Claude
RUN npm install -g @anthropic-ai/claude-code

# Install MCP server
RUN npm install -g task-master-ai n8n-mcp

# Install tools
RUN go install github.com/d-kuro/gwq/cmd/gwq@latest && \
  go install github.com/go-task/task/v3/cmd/task@latest && \
  go install github.com/peco/peco/cmd/peco@latest && \
  go install github.com/x-motemen/ghq@latest && \
  npm install -g ccmanager && \
  npm install -g ccusage

# Copy and setup playwright config
COPY --chown=node:node setup/playwright-config.json /home/node/playwright-config.json

# Install LSP
RUN npm install -g typescript typescript-language-server

# Copy and setup .zshrc
COPY --chown=node:node setup/.zshrc.local /home/node/.zshrc.local
RUN cat /home/node/.zshrc.local >> /home/node/.zshrc

# Copy and setup .gitconfig
COPY --chown=node:node setup/.gitconfig.local /home/node/.gitconfig.local
RUN cat /home/node/.gitconfig.local >> /home/node/.gitconfig

# Copy ccmanager config
COPY --chown=node:node setup/ccmanager-config.json /home/node/.config/ccmanager/config.json

# Copy and set up firewall script
COPY setup/init-firewall.sh /usr/local/bin/
COPY setup/init-claude-mcp.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh /usr/local/bin/init-claude-mcp.sh && \
  echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
  chmod 0440 /etc/sudoers.d/node-firewall
USER node
