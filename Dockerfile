FROM ubuntu:14.04
MAINTAINER Stephen Paul Suarez <devpopol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
# Ruby deps && Ruby
RUN apt-get update && apt-get upgrade -y && \
  apt-get -y install \
    build-essential \
    curl \
    git-core \
    libcurl4-openssl-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    zlib1g-dev && \
  curl -O http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && \
  tar -zxvf ruby-2.1.2.tar.gz && \
  cd ruby-2.1.2 && \
  ./configure --disable-install-doc && \
  make && \
  make install && \
  cd .. && \
  rm -r ruby-2.1.2 ruby-2.1.2.tar.gz && \
  echo 'gem: --no-document' > /usr/local/etc/gemrc

RUN apt-get install software-properties-common -y
# NodeJS
RUN apt-add-repository -y ppa:chris-lea/node.js
RUN apt-get update -y
RUN apt-get install nodejs -y

# Bundler
RUN gem install bundler --version=1.6.2
# Rails
RUN gem install rails --version=4.1.1
RUN apt-get install libmysqlclient18 libmysqlclient-dev -y sudo

# Apache & Passenger
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN apt-get install apt-transport-https ca-certificates -y
ADD passenger.list /etc/apt/sources.list.d/passenger.list
RUN chown root: /etc/apt/sources.list.d/passenger.list
RUN chmod 600 /etc/apt/sources.list.d/passenger.list
RUN apt-get update -y

RUN apt-get install libapache2-mod-passenger  -y
#RUN a2enmod passenger
RUN service apache2 restart

RUN mkdir -p /apps/app
RUN chown -R www-data:www-data /apps

# Configure: remove default sites
RUN a2dissite 000-default
RUN a2dissite default-ssl