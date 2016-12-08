FROM tpaktop/ruby-slim-2.1.4:2.1.4-slim

RUN apt-get update -qq && apt-get install -yqq \
    curl \
    nodejs \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libsqlite3-dev \
    iceweasel \
    postgresql \
    locales

# Locales
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install bundler --no-ri --no-rdoc
