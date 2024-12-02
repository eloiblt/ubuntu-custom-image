FROM ubuntu:latest

RUN apt update && apt install -y ttyd openssh-server zsh speedtest-cli ipcalc openvpn curl git iputils-ping nano
RUN chsh -s $(which zsh)
SHELL ["/bin/zsh", "-c"]

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k \
  && git clone https://github.com/zsh-users/zsh-autosuggestions /root/.zsh/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.zsh/zsh-syntax-highlighting

COPY ./.p10k.zsh /root/.p10k.zsh
COPY ./.zshrc /root/.zshrc

RUN mkdir -p /root/.cache/gitstatus
COPY ./gitstatusd-linux-x86_64 /root/.cache/gitstatus/gitstatusd-linux-x86_64

COPY ./start-services.sh /usr/local/bin/start-services.sh
RUN chmod +x /usr/local/bin/start-services.sh

RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

EXPOSE 22 7681

ENTRYPOINT ["/usr/local/bin/start-services.sh"]