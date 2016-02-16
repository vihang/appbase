FROM ubuntu:15.10
EXPOSE 9000 80 9876 22
RUN wget \
    --no-cookies \
    --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    -qO- \
    "http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz" | sudo tar -zx -C /opt/

# Set JAVA_HOME and add to PATH    
ENV JAVA_HOME /opt/jdk1.8.0_51
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /home/user/.bashrc
ENV PATH $JAVA_HOME/bin:$PATH
RUN echo "export PATH=$PATH" >> /home/user/.bashrc

# Create app directory and extract build
RUN mkdir /home/user/app
WORKDIR /home/user/app
ADD $app$ /home/user/$app$
RUN unzip -q /home/user/$app$ -d /home/user/app && rm /home/user/$app$
  
# Create bin directory for sbt files, and move them from app directory
# Add sbt to PATH
RUN mkdir /home/user/bin
RUN cp /home/user/app/sbt/* /home/user/bin
RUN rm -rf /home/user/app/sbt
RUN chmod u+x /home/user/bin/sbt
ENV PATH /home/user/bin:$PATH
RUN echo "export PATH=$PATH" >> /home/user/.bashrc

# Execute SBT build
WORKDIR /home/user/app
RUN sbt clean compile run

    
RUN sudo apt-get update
RUN sudo apt-get install -y curl
RUN sudo apt-get install -y software-properties-common

# install essentials
RUN sudo apt-get -y install build-essential

RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
RUN sudo apt-get -y update
RUN sudo apt-get install sbt
RUN sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
RUN cd /tmp
RUN sudo wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz 
RUN sudo tar -xvzf ruby-2.1.5.tar.gz
WORKDIR ruby-2.1.5/
RUN sudo ./configure --prefix=/usr/local
RUN sudo make
RUN sudo make install

RUN sudo gem install sass -v 3.4.9
