#!/usr/bin/env bash

export PYTHONUNBUFFERED=1
export DEBIAN_FRONTEND=noninteractive

echo "Setting up Node 10"
curl -sL https://deb.nodesource.com/setup_10.x | bash -
echo

echo "Setting up PostgreSQL"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo "deb https://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list
echo

echo "Installing base Packages"
apt-get update -y
apt-get dist-upgrade -y
apt-get install -y bash-completion libssl-dev krb5-multidev comerr-dev python-dev libenchant1c2a libpq-dev libproj-dev \
    gdal-bin libffi-dev libxml2 libxml2-dev libxslt1-dev libxslt1-dev libxslt1.1 libgconf-2-4 libopenblas-dev liblapack-dev \
    librsvg2-bin libjpeg-dev make memcached wamerican binutils tesseract-ocr imagemagick supervisor xpdf libreoffice-common \
    poppler-utils libpulse-dev swig autoconf automake libtool pkg-config zsh nodejs postgresql-client-12 vim git man \
    python2 python2-pip python3 python3-pip
echo

echo "Adding RDS Root Certificate"
curl -o /usr/local/share/ca-certificates/rds-ca-2019-root.pem https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem
echo

echo "Installing Sylus"
npm install --global stylus
echo

echo "Installing git-crypt"
GIT_CRYPT_TEMP_DIR="$(mktemp -d)"
cd "$GIT_CRYPT_TEMP_DIR"
git clone https://github.com/AGWA/git-crypt.git --branch 0.6.0
cd git-crypt
make install
cd /
rm -rf "$GIT_CRYPT_TEMP_DIR"
echo

echo "Creating /code"
mkdir /code
echo

echo "Setup Complete"
