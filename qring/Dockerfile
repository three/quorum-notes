FROM debian:buster

ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

# Global dependencies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb https://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list && \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y bash-completion libssl-dev krb5-multidev comerr-dev python-dev libenchant1c2a libpq-dev libproj-dev \
        gdal-bin libffi-dev libxml2 libxml2-dev libxslt1-dev libxslt1-dev libxslt1.1 libgconf-2-4 libopenblas-dev liblapack-dev \
        librsvg2-bin libjpeg-dev make memcached wamerican binutils tesseract-ocr imagemagick supervisor xpdf libreoffice-common \
        poppler-utils libpulse-dev swig autoconf automake libtool pkg-config zsh nodejs postgresql-client-12 vim git man && \
    curl -o /usr/local/share/ca-certificates/rds-ca-2019-root.pem https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem && \
    npm install --global stylus && \
    cd /root && git clone https://github.com/AGWA/git-crypt.git --branch 0.6.0 && cd /root/git-crypt && make install && \
    mkdir /code

# Local environment
WORKDIR /root
ENV DOTFILES /root/dotfiles
RUN ssh-keygen -t rsa -b 4096 -N "" -f "$HOME/.ssh/id_rsa" && \
    git clone https://github.com/three/dotfiles.git && \
    /root/dotfiles/update-deps.sh && \
    echo "source /root/dotfiles/shell/zsh.sh" >> /root/.zshrc && \
    ln -s /root/dotfiles/vim /root/.vim && \
    vim +PlugUpdate +qall

# Local dependencies
WORKDIR /code
COPY ./tests/ ./tests/
#COPY gdrive_token.json gdrive_credentials.json gdrive_service_account_key_file.json /root/.ssh/
RUN pip install -r tests/requirements.txt && \
    python -c "import nltk; nltk.download('averaged_perceptron_tagger')"

WORKDIR /code
CMD ["/usr/bin/zsh"]
