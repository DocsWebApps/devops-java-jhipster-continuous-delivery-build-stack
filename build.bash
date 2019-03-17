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
# Docker / Docker-Compose - To run your containers                  #
# GitBlit - source code repo                                        #
# Jenkins - task runner                                             #
# Maven - build tool and dependecy management                       #
# Nexus - built package and compiled artifact repo                  #
# SonarQube - code analyser                                         #
#####################################################################

# Install OracleJDK
install_java() {
    echo "Installing Java..."
    yum install -y $JAVA_VERSION
}


# Install Apache Maven
install_maven() {
    echo "Installing Maven..."
    mkdir ${MAVEN_DIR}
    cd ${MAVEN_DIR}
    wget http://apache.mirror.anlx.net/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar xvfz apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && ln -s ${MAVEN_DIR}/apache-maven-${MAVEN_VERSION} ${MAVEN_DIR}/mvn3
    echo "export MAVEN_HOME=${MAVEN_DIR}/mvn3" >> ${HOME}/.bashrc
    echo "export PATH=${MAVEN_DIR}/mvn3/bin:$PATH" >> ${HOME}/.bashrc
    source ${HOME}/.bashrc
    sed -e "s|env.MAVEN_REPO|$MAVEN_REPO|g" -e "s|env.NEXUS_USER|$NEXUS_USER|g" -e "s|env.NEXUS_PASS|$NEXUS_PASS|g" -e s"|env.NEXUS_PORT_8081|$NEXUS_PORT_8081|g" < ${BASE_DIR}/settings.xml.orig > ${MAVEN_DIR}/mvn3/conf/settings.xml
    rm -rf ${MAVEN_DIR}/apache-maven-${MAVEN_VERSION}-bin.tar.gz
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

# Setup Users
setup_users() {
    echo "Setting up Jenkins and Nexus users..."
    adduser -d /home/jenkins -b /bin/bash -u 1000 jenkins
    adduser -d /home/nexus -b /bin/bash -u 200 nexus
    mkdir -p ${DOCKER_VOLUMES}/nexus
    chown nexus:nexus -R ${DOCKER_VOLUMES}/nexus
    mkdir -p ${DOCKER_VOLUMES}/sonarqube/logs
    mkdir -p ${DOCKER_VOLUMES}/sonarqube/conf
    mkdir -p ${DOCKER_VOLUMES}/sonarqube/data
    mkdir -p ${DOCKER_VOLUMES}/sonarqube/extensions
    chmod 777 ${DOCKER_VOLUMES}/sonarqube -R

}

# Install Jenkins
install_jenkins() {
    echo "Installing Jenkins..."
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum install -y jenkins
    firewall-cmd --zone=public --permanent --add-port=8080/tcp
    systemctl restart firewalld
}

# Docker Install
install_docker() {
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
install_docker_compose() {
    echo "Installing Docker Compose..."
    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

# Build Steps
set_env
update_system
setup_users
install_java
install_maven
install_jenkins
install_docker
install_docker_compose
echo "All Done !!"
# End
