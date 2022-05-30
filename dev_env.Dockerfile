# User's dev env image must derive from recodesh/base-dev-env.
# See https://github.com/recode-sh/base-dev-env/blob/main/Dockerfile for source.
FROM recodesh/base-dev-env:latest

# Set timezone
ENV TZ=America/Los_Angeles

# Set locale
RUN sudo locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en 
ENV LC_ALL=en_US.UTF-8

# Install Zsh
RUN set -euo pipefail \
  && sudo apt-get --assume-yes --quiet --quiet update \
  && sudo apt-get --assume-yes --quiet --quiet install zsh \
  && sudo rm --recursive --force /var/lib/apt/lists/*

# Install OhMyZSH and some plugins
RUN set -euo pipefail \
  && sh -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && git clone --quiet https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Change default shell for user "recode"
RUN set -euo pipefail \
  && sudo usermod --shell $(which zsh) recode

# Add all dotfiles to home folder
COPY --chown=recode:recode ./dotfiles/.* $HOME/
