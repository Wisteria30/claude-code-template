FROM node:20

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

# Install basic development tools and iptables/ipset
RUN apt update && apt install -y less \
  git \
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
RUN npm install -g task-master-ai

# Install tools
RUN go install github.com/d-kuro/gwq/cmd/gwq@latest && \
  go install github.com/go-task/task/v3/cmd/task@latest && \
  go install github.com/peco/peco/cmd/peco@latest && \
  go install github.com/x-motemen/ghq@latest

# Copy and setup .zshrc
COPY setup/.zshrc.local /home/node/.zshrc.local
RUN cat /home/node/.zshrc.local >> /home/node/.zshrc

# Copy and setup .gitconfig
COPY setup/.gitconfig.local /home/node/.gitconfig.local
RUN cat /home/node/.gitconfig.local >> /home/node/.gitconfig

# Copy and set up firewall script
COPY setup/init-firewall.sh /usr/local/bin/
COPY setup/init-claude-mcp.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh /usr/local/bin/init-claude-mcp.sh && \
  echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
  chmod 0440 /etc/sudoers.d/node-firewall
USER node
