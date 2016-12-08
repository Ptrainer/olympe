FROM ptrainer/rails

RUN apt-get update
RUN apt-get -y install git

RUN mkdir /ptrainer-website
WORKDIR /ptrainer-website

ADD ptrainer-website/Gemfile* ./
RUN bundle install

# User specific configuration
ARG UID=1000
ARG USER=docker

RUN useradd -u ${UID} -m ${USER}
