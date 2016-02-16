FROM ubuntu:15.10
EXPOSE 8000 8080 9876 22
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

LABEL che:server:8080:ref=tomcat8 che:server:8080:protocol=http che:server:8000:ref=tomcat8-debug che:server:8000:protocol=http che:server:9876:ref=codeserver che:server:9876:protocol=http


ENV MAVEN_VERSION=3.3.9 \
    JAVA_VERSION=8u45 \
    JAVA_VERSION_PREFIX=1.8.0_45
    
ENV JAVA_HOME=/opt/jdk$JAVA_VERSION_PREFIX \
M2_HOME=/home/user/apache-maven-$MAVEN_VERSION

ENV PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

RUN mkdir /home/user/cbuild /home/user/tomcat8 /home/user/apache-maven-$MAVEN_VERSION && \
  wget \
  --no-cookies \
  --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  -qO- \
  "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-b14/jdk-$JAVA_VERSION-linux-x64.tar.gz" | sudo tar -zx -C /opt/ && \
  wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C /home/user/apache-maven-$MAVEN_VERSION/
ENV TERM xterm
ENV PATH_TO_CBUILD_PROJECTS_FOLDER /projects
ENV PATH_TO_CBUILD_LIBRARY_FOLDER /home/user/cbuild

ADD cbuild buildLibrary.sh clone_codenvy.sh projectsList.sh cbuild_autocompletion /home/user/cbuild/
RUN cd /home/user/cbuild && \
    sudo chmod a+x cbuild buildLibrary.sh clone_codenvy.sh projectsList.sh && \
    sudo chown -R user:user /home/user/cbuild

RUN /home/user/cbuild/cbuild --install

CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null
    
RUN apt-get update
RUN apt-get install -y rubygems-integration inotify-tools
RUN gem install sass -v 3.4.9
