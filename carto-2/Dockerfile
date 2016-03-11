FROM ubuntu:12.04
MAINTAINER Ido Shamon

ENV DEBIAN_FRONTEND noninteractiveo

RUN dpkg-reconfigure locales && \
      locale-gen en_US.UTF-8 && \
      update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV REDIS_PORT 6379

RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    python-software-properties

RUN useradd -m -d /home/cartodb -s /bin/bash cartodb && \
    apt-key update apt-get update && \
    add-apt-repository -y ppa:cartodb/gis && \
    add-apt-repository -y ppa:cartodb/postgresql-9.3 && \
    add-apt-repository ppa:ubuntu-toolchain-r/test

RUN apt-get update && \
    apt-get install -y \
    python-setuptools \
    python-simplejson \ 
    python-all-dev \
    python-all-dev \
    htop git openssl net-tools wget \
    vim sudo make unp zip \
    pkg-config \
    libreadline6-dev \
    imagemagick \
    libpq-dev libicu-dev \
    gdal-bin python-gdal \
    libgdal-dev libgdal1-dev libpango1.0-dev

# ogr2ogr2 static build, see https://github.com/CartoDB/cartodb/wiki/How-to-build-gdal-and-ogr2ogr2
RUN cd /opt && git clone https://github.com/OSGeo/gdal ogr2ogr2 && cd ogr2ogr2 && \
git remote add cartodb https://github.com/cartodb/gdal && git fetch cartodb && \
git checkout trunk && git pull origin trunk && \
git checkout upstream && git merge --ff-only origin/trunk && \
git config --global user.email "you@example.com" && \
git config --global user.name "Your Name" && \
git checkout ogr2ogr2 && git merge upstream -m "Merged it" && \
cd ogr2ogr2 && ./configure --disable-shared && make -j 4 && \
cp apps/ogr2ogr /usr/bin/ogr2ogr2 && rm -rf /opt/ogr2ogr2 /root/.gitconfig

# set gdal envs
ENV CPLUS_INCLUDE_PATH $CPLUS_INCLUDE_PATH:/usr/include/gdal
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:/usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

# update gcc
RUN apt-get install -y gcc-4.9 g++-4.9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

# Install NodeJS
RUN curl https://nodejs.org/download/release/v0.10.41/node-v0.10.41-linux-x64.tar.gz| tar -zxf - --strip-components=1 -C /usr

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable --ruby
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc
RUN /bin/bash -l -c rvm requirements
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN echo rvm_max_time_flag=15 >> ~/.rvmrc
RUN /bin/bash -l -c 'rvm install 2.2.3'
RUN /bin/bash -l -c 'rvm use 2.2.3 --default'
RUN /bin/bash -l -c 'gem install bundle archive-tar-minitar'

# Install bundler
RUN /bin/bash -l -c 'gem install bundler --no-doc --no-ri'

# Install pip
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python /tmp/get-pip.py
RUN pip install mapnik

# Install CartoDB API
RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && \
      cd CartoDB-SQL-API && ./configure && npm install

# Install Windshaft
RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && \
      cd Windshaft-cartodb && ./configure && npm install && mkdir logs

# Install CartoDB (with the bug correction on bundle install)
RUN git clone git://github.com/CartoDB/cartodb.git && \
      cd cartodb && /bin/bash -l -c 'bundle install' || \
      /bin/bash -l -c "cd $(/bin/bash -l -c 'gem contents \
            debugger-ruby_core_source' | grep CHANGELOG | sed -e \
            's,CHANGELOG.md,,') && /bin/bash -l -c 'rake add_source \
            VERSION=$(/bin/bash -l -c 'ruby --version' | awk \
            '{print $2}' | sed -e 's,p55,-p55,' )' && cd /cartodb && \
            /bin/bash -l -c 'bundle install'"

ENV PATH $PATH:/cartodb/node_modules/grunt-cli/bin
RUN cd cartodb && bundle exec grunt --environment development

ADD ./config/app_config.yml /cartodb/config/app_config.yml
ADD ./config/database.yml /cartodb/config/database.yml
ADD ./script/setup_user /cartodb/script/setup_user
ADD ./script/create_dev_user /cartodb/script/create_dev_user
RUN chmod +x /cartodb/script/create_dev_user
RUN chmod +x /cartodb/script/setup_user

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

EXPOSE 3000 8080 8181

ADD ./startup.sh /opt/startup.sh

CMD ["/bin/bash", "/opt/startup.sh"]
