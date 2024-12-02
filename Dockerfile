FROM ubuntu:latest

RUN apt update && apt install -y ttyd openssh-server zsh speedtest-cli ipcalc openvpn curl git iputils-ping nano
RUN chsh -s $(which zsh)
SHELL ["/bin/zsh", "-c"]

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

COPY ./assets/.p10k.zsh /root/.p10k.zsh
COPY ./assets/.zshrc /root/.zshrc

RUN mkdir -p /root/.cache/gitstatus
COPY ./assets/gitstatusd-linux-x86_64 /root/.cache/gitstatus/gitstatusd-linux-x86_64

COPY ./assets/start-services.sh /usr/local/bin/start-services.sh
RUN chmod +x /usr/local/bin/start-services.sh

RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

EXPOSE 22 7681

WORKDIR /root

ENTRYPOINT ["/usr/local/bin/start-services.sh"]