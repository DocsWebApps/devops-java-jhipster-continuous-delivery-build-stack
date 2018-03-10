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
    adduser -d ${DOCKER_VOLUMES}/jenkins -b /bin/bash -u 1000 jenkins
    adduser -d ${DOCKER_VOLUMES}/nexus -b /bin/bash -u 200 nexus
    chown jenkins:jenkins -R ${DOCKER_VOLUMES}/jenkins
    chown nexus:nexus -R ${DOCKER_VOLUMES}/nexus
}

# SDK Install
sdk_install() {
    curl -s "https://get.sdkman.io" | bash
    source "/root/.sdkman/bin/sdkman-init.sh"
    echo 'export SDKMAN_DIR="/root/.sdkman"' >> .bashrc
    echo '[[ -s "/root/.sdkman/bin/sdkman-init.sh" ]] && source "/root/.sdkman/bin/sdkman-init.sh"' >> .bashrc
    sdk install java 8u161-oracle
    sdk install maven 3.5.2
    java -version
    mvn --version
}

# Install Jenkins
install_jenkins() {
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum install jenkins
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
setup_users
sdk_install
install_jenkins
docker_install
docker_compose_install
docker_machine_install
buid_stack
echo "All Done !!"
# End
