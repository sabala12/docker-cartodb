FROM ubuntu:14.04
MAINTAINER Ido Shamon

ENV  DEBIAN_FRONTEND noninteractive

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable --ruby
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc
RUN /bin/bash -l -c rvm requirements
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -l -c 'rvm install 1.9.3-p547 --patch railsexpress'
RUN /bin/bash -l -c 'rvm use 1.9.3-p547 --default'
RUN /bin/bash -l -c 'gem install bundle archive-tar-minitar'

RUN apt-get update -y && apt-get install -y \
    libreadline6-dev openssl git make g++ \
    python-setuptools python-simplejson

# Install bundler & compass
RUN /bin/bash -l -c 'gem install bundler --no-doc --no-ri'
RUN /bin/bash -l -c 'gem install compass --no-doc --no-ri'

# Install CartoDB (with the bug correction on bundle install)
RUN git clone git://github.com/CartoDB/cartodb.git && \
      cd cartodb && /bin/bash -l -c 'bundle install' || \
      /bin/bash -l -c "cd $(/bin/bash -l -c 'gem contents \
            debugger-ruby_core_source' | grep CHANGELOG | sed -e \
            's,CHANGELOG.md,,') && /bin/bash -l -c 'rake add_source \
            VERSION=$(/bin/bash -l -c 'ruby --version' | awk \
            '{print $2}' | sed -e 's,p55,-p55,' )' && cd /cartodb && \
            /bin/bash -l -c 'bundle install'"

# Copy confs
ADD ./config/app_config.yml /cartodb/config/app_config.yml
ADD ./config/database.yml /cartodb/config/database.yml

# Run setup configurations
ADD ./setup /cartodb/script/setup.sh
RUN chmod +x /cartodb/script/setup.sh
RUN /cartodb/script/setup.sh

EXPOSE 3000

COPY entry-point.sh /home
RUN chmod 700 /home/entry-point.sh
ENTRY [/home/entry-point.sh]
