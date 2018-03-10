#####################################################################
# Build a Continuous Integration Server for Application Development #
# CentOS v7.4                                                       #
# Dave Collier @10/01/2018                                          #
#####################################################################
# Instructions: Full instruction are in the README.md file          #
# 1. Set the environment variables to your choice in set_env.bash   #
# 2. Run the build script as root: ./build.bash                     #
#                                                                   #
# Contents                                                          #
# --------                                                          #
# GitLab - source code repo                                         #
# Jenkins - task runner                                             #
# Maven - build tool and dependecy management                       #
# Nexus - built package and compiled artifact repo                  #
# SonarQube - code analyser                                         #
#####################################################################

# Install OracleJDK
install_java() {
    cd /opt
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz \
    && tar xvfz jdk-8u161-linux-x64.tar.gz \
    && ln -s /opt/jdk1.8.0_161 /opt/jdk8 \
    && ln -s /opt/jdk1.8.0_161/bin/java /usr/bin/java 
    export JAVA_HOME=/opt/jdk8
    export PATH=$JAVA_HOME/bin:$PATH
}


# Install Apache Maven
install_maven() {
    cd /opt
    wget http://apache.mirror.anlx.net/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz \
    && tar xvfz apache-maven-3.5.2-bin.tar.gz \
    && ln -s /opt/apache-maven-3.5.2 /opt/mvn3
}

# Set Environment
set_env() {
    echo "Setting environment variables..."
    source ./set_env.bash
}

# Update System
update_system()  {
    echo "Updating system..."
    yum -y update
    yum -y upgrade
    yum install -y yum-utils device-mapper-persistent-data lvm2 wget unzip zip
    yum install -y fontconfig freetype freetype-devel fontconfig-devel libstdc++
}

# Setup Other Folders
setup_folders() {
    echo "Creating bind mounts..."
    mkdir ${DOCKER_VOLUMES}
    mkdir ${DOCKER_VOLUMES}/nexus
}

# Setup Users
setup_users() {
    echo "Setting up Jenkins and Nexus users..."
    adduser -d /home/jenkins -b /bin/bash -u 1000 jenkins
    adduser -d ${DOCKER_VOLUMES}/nexus -b /bin/bash -u 200 nexus
    chown jenkins:jenkins -R /home/jenkins
    chown nexus:nexus -R ${DOCKER_VOLUMES}/nexus
}

# Install Jenkins
install_jenkins() {
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum install -y jenkins
}

# Docker Install
docker_install() {
    echo "Installing Docker..."
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
    systemctl enable docker
    systemctl start docker
    yum install -y epel-release
    yum install -y python-pip 
    pip install docker-compose
    pip install --upgrade pip
}

# Docker Compose Install
docker_compose_install() {
    echo "Installing Docker Compose..."
    curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

# Docker Machine Install
docker_machine_install() {
    echo "Installing Docker Machine..."
    curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine
    chmod +x /usr/local/bin/docker-machine
}

# Docker-Compose - Build servers !
buid_stack() {
    echo "OK, building your stack..."
    ./start_stack.bash 
}

# Build Steps
set_env
update_system
setup_folders
install_java
install_maven
setup_users
install_jenkins
docker_install
docker_compose_install
docker_machine_install
buid_stack
echo "All Done !!"
# End
