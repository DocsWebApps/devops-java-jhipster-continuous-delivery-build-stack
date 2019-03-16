# Choose where you want the base installation to go including the Docker Volumes to go.
export BASE_DIR=/root/DocsAppStack
export DOCKER_VOLUMES=${BASE_DIR}/docker_volumes
export DOCKER_COMPOSE=1.23.2

# GitBlit Setup - Chose the ports
export GITBLIT_PORT_8080=9010
export GITBLIT_PORT_8443=9020
export GITBLIT_PORT_9418=9030
export GITBLIT_PORT_29418=9040

# Nexus/Maven Setup
# The username and password that you will set up Nexus with needs to be exported so that Maven can proxy off the Nexus
# repository to Maven Central to resolve dependencies in the Maven settings file!
export NEXUS_USER=admin 			# Default Nexus Username
export NEXUS_PASS=admin123      		# Default Nexus Password - change it!
export NEXUS_PORT_8081=9050                     # Nexus webclient port
export MAVEN_VERSION=3.5.4			# Set Maven Version
export MAVEN_DIR=${BASE_DIR}/maven		# Maven installation directory
export MAVEN_REPO=${MAVEN_DIR}/maven-repo 	# Default location for the Maven Repository

# SonarQube Setup
export SONARQUBE_PORT_9000=9060
export SONARQUBE_PORT_9092=9070

# Set the docker image versions
export GITBLIT_VERSION=latest
export NEXUS_VERSION=2.14.12
export SONARQUBE_VERSION=7.6
export POSTGRES_VERSION=11.2

# Set your version of java
export JAVA_VERSION=java-1.8.0-openjdk-devel
