FROM ubuntu:14.04
MAINTAINER Stephen Paul Suarez <devpopol@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
# Java & JRuby
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-7-jre-headless tar curl && apt-get autoremove -y && apt-get clean
ENV JRUBY_VERSION 1.7.16
RUN curl http://jruby.org.s3.amazonaws.com/downloads/$JRUBY_VERSION/jruby-bin-$JRUBY_VERSION.tar.gz | tar xz -C /opt
ENV PATH /opt/jruby-$JRUBY_VERSION/bin:$PATH
# NodeJS
RUN apt-get install software-properties-common -y
RUN apt-add-repository -y ppa:chris-lea/node.js
RUN apt-get update -y
RUN apt-get install nodejs -y
# Gems
RUN echo gem: --no-document >> /etc/gemrc
RUN gem update --system
# Bundler
RUN jruby -S gem install bundler --version=1.6.2
# Rails
RUN jruby -S gem install rails --version=4.0.3
# Jetty
ENV JETTY_VERSION 9.2.3.v20140905
ADD http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-$JETTY_VERSION.tar.gz&r=1 /opt/jetty.tar.gz
RUN tar -xvf /opt/jetty.tar.gz -C /opt/
RUN rm /opt/jetty.tar.gz
RUN mv /opt/jetty-distribution-$JETTY_VERSION /opt/jetty
RUN useradd jetty -U -s /bin/false
RUN chown -R jetty:jetty /opt/jetty

RUN mkdir -p /apps/app