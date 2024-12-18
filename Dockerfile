FROM ubuntu:latest

RUN apt update && apt install -y ttyd openssh-server zsh speedtest-cli ipcalc openvpn curl git iputils-ping nano
RUN chsh -s $(which zsh)
SHELL ["/bin/zsh", "-c"]

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

COPY ./assets/.zshrc /root/.zshrc
COPY ./assets/starship.toml /root/.config/starship.toml

COPY ./assets/start-services.sh /usr/local/bin/start-services.sh
RUN chmod +x /usr/local/bin/start-services.sh

RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

EXPOSE 22 7681

WORKDIR /root

ENTRYPOINT ["/usr/local/bin/start-services.sh"]