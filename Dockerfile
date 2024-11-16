FROM ubuntu:latest

RUN apt update && apt install -y ttyd openssh-server zsh speedtest-cli ipcalc openvpn curl git iputils-ping nano
RUN chsh -s $(which zsh)
SHELL ["/bin/zsh", "-c"]

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
  && sed -i 's_robbyrussell_powerlevel10k/powerlevel10k_g' ~/.zshrc \
  && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

RUN rm /root/.zshrc
COPY ./.p10k.zsh /root/.p10k.zsh
COPY ./.zshrc /root/.zshrc

RUN mkdir -p /root/.cache/gitstatus
COPY ./gitstatusd-linux-x86_64 /root/.cache/gitstatus/gitstatusd-linux-x86_64
RUN source /root/.zshrc

RUN printf 'alias ll="ls -lAhiS --group-directories-first"\n \
  alias privateip="ipcalc $(hostname -I | awk '\''{print $1}'\'')"\n \
  alias publicip="ipcalc $(curl --no-progress-meter ifconfig.me)"\n \
  alias updateall="apt -y update && apt -y upgrade && apt full-upgrade -y && apt -y dist-upgrade && apt -y autoremove && apt -y clean && apt -y autoclean"\n' \
  >> ~/.zshrc

COPY start-services.sh /usr/local/bin/start-services.sh
RUN chmod +x /usr/local/bin/start-services.sh

RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

EXPOSE 22 7681

ENTRYPOINT ["/usr/local/bin/start-services.sh"]