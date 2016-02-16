FROM ubuntu
EXPOSE 9000 22
RUN apt-get update && \
    apt-get -y install sudo openssh-server procps wget unzip mc curl subversion nmap software-properties-common python-software-properties && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -u 1000 -G users,sudo -d /home/user --shell /bin/bash -m user && \
    echo "secret\nsecret" | passwd user && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    sudo apt-get install git -y && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

USER user

LABEL che:server:9000:ref=play che:server:9000:protocol=http


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
RUN sudo apt-get update
RUN sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev

RUN sudo wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz 
RUN sudo tar -xvzf ruby-2.1.5.tar.gz
WORKDIR ruby-2.1.5/
RUN sudo ./configure --prefix=/usr/local
RUN sudo make
RUN sudo make install

WORKDIR /home/user

RUN sudo gem install sass -v 3.4.9

ADD activator activator-launch-1.3.7.jar build.sbt project /home/user/
RUN cd /home/user && \
    sudo chmod a+x activator && \
    sudo chown -R user:user /home/user
RUN /home/user/activator compile

CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null

