FROM python:2.7-jessie

ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code

# needed for recompile org designs on the server
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt update
RUN apt -y upgrade
# the following commands are needed to install postgresql-client-12 properly
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb https://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list
RUN apt update
RUN apt install -y bash-completion libssl-dev krb5-multidev comerr-dev python-dev libenchant1c2a libpq-dev libproj-dev \
gdal-bin libffi-dev libxml2 libxml2-dev libxslt1-dev libxslt1-dev libxslt1.1 libgconf-2-4 libopenblas-dev liblapack-dev \
librsvg2-bin libjpeg-dev make memcached wamerican binutils tesseract-ocr imagemagick supervisor xpdf libreoffice-common \
poppler-utils libpulse-dev swig autoconf automake libtool pkg-config zsh nodejs postgresql-client-12

RUN npm install --global stylus

# configure zsh
ENV ZSH_THEME amuse
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Copy RDS root CA certificate
WORKDIR /usr/local/share/ca-certificates
RUN curl -o rds-ca-2019-root.pem https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem


WORKDIR /code
# copy only the local tests directory into the container to install deps
COPY ./tests/ ./tests/
RUN pip install -r tests/requirements.txt
RUN python -c "import nltk; nltk.download('averaged_perceptron_tagger')"
