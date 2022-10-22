FROM fedora:latest

SHELL ["/bin/bash", "-c"]

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False \
    bash \
    curl \
    htop \
    man \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    nano \
    zsh \
    wget \
    git \
    && dnf clean all

RUN cd /bin && if [ "$(uname -m)" == "aarch64" ]; then curl -LSs "https://download.jetbrains.com/product?code=FLL&release.type=eap&platform=linux_aarch64" --output fleet && chmod +x fleet; else curl -LSs "https://download.jetbrains.com/product?code=FLL&release.type=eap&platform=linux_x64" --output fleet && chmod +x fleet; fi;

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

#a