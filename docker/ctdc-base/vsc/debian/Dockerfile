FROM debian:sid-slim

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes --no-install-recommends \
      bash \
      curl \
      htop \
      man \
      software-properties-common \
      sudo \
      systemd \
      systemd-sysv \
      unzip \
      nano \
      zsh \
      wget \
      git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd coder \
      --create-home \
      --shell=/bin/zsh \
      --uid=1000 \
      --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER coder

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

RUN sed -i.bak "s+robbyrussell+powerlevel10k/powerlevel10k+g" /home/coder/.zshrc