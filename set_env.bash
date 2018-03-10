# Choose where you want the bind mounts to go.
export DOCKER_VOLUMES=/docker_volumes

# Setup the LISTEN ports for the various components to your choice.
export GITLAB_PORT_80=9010
export GITLAB_PORT_22=9050
export GITLAB_PORT_443=9060

#export JENKINS_PORT_8080=9020
#export JENKINS_PORT_5000=9070

export NEXUS_PORT_8081=9030

export SONARQUBE_PORT_9000=9040
export SONARQUBE_PORT_9092=9080

# Set the docker image versions, JENKINS reverts to LTS so if you want change it change it in the Dockerfile
export GITLAB_VERSION=10.3.5-ce.0
export NEXUS_VERSION=2.14.5
export SONARQUBE_VERSION=6.7.1
export POSTGRES_VERSION=10.1
