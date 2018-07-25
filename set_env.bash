# Choose where you want the bind mounts to go.
export DOCKER_VOLUMES=./docker_volumes

# Setup the LISTEN ports for the various components to your choice.
export GITLAB_PORT_80=9010
export GITLAB_PORT_22=9050
export GITLAB_PORT_443=9060

export NEXUS_PORT_8081=9030

export SONARQUBE_PORT_9000=9000
export SONARQUBE_PORT_9092=9080

# Set the docker image versions
export GITLAB_VERSION=10.8.4-ce.0
export NEXUS_VERSION=2.14.8-01
export SONARQUBE_VERSION=7.1
export POSTGRES_VERSION=10.3

# Set your version of java
export JAVA_VERSION=java-1.8.0-openjdk-devel

# Set your Maven version
export MAVEN_VERSION=3.5.4
