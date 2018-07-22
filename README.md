## A Continuous Integration Environment for JHipster Projects using Maven

Version 1.1.0 2nd February 2018

This project contains a build script to enable you to automatically build a complete working continuous integration environment from Docker images to support your JHipster development projects. 

The script is written for installation on Centos 7.

Although originally designed to support JHipster projects that are built using Maven, it can be configured for other types of projects such as Java or Spring projects.

For more information about JHipster please visit the following link:  <a href="http://www.jhipster.tech/" target="_blank">JHipster</a>

The environment has the following components:

1. GitLab: This component is used to store the source code for your project.
2. Maven: I'm using Maven for code compilation and dependecy management.
3. Jenkins: This is the task runner for the environment.
4. Nexus: For storing built artifacts and dependencies. Proxies Maven Central for seemless downloading of dependencies.
5. SonarQube: To analyse your code to identify code smells, bugs and vulnerabilities. 

### Workflow

You check you code into GitLab throughout the day as you develop it. Jenkins will poll GitLab every 5 mins checking for new commits. On finding one it will checkout the code and build it getting any depdencies from the Nexus respository (that also proxies Maven Central for convinience). It will identify any build issues and once succssfully built with the 'package' Maven goal, it will run your automated tests to check for any failures. If your tests pass, the final step is to analyse your code using SonarQube. You can then view the results of the analysis and rectify any problems early in the development lifecycle.

The idea behind this project is simple, develop good quality code and detect issues early on when they can be easily fixed.

Semantic versioning is applied to this project.

Good luck and enjoy !

### Instructions to build the environment

1. First you need to create a basic Linux server by installing Centos 7. This can be any type of server, physical, VM or cloud based.

2. Install 'git' so that you can download this repository

```ruby
 yum install -y git
```

3. Clone this repository onto your new Centos 7 server 

```ruby
git clone https://github.com/DocsWebApps/JHispterCIBuildEnvironment.git
```

4. Set the environment variables to your choice in the file set_env.bash. This involves selecting where you want the container bind mounts, what ports your want each service in the environment to listen on and which versions of each component do you wish to use. You can also set up the hostname of your server here.  

5. Set the number of Jenkins executors you need in the executors.groovy file under the jenkins folder.

6. Rename the folder JHispterCIBuildEnvironment to a name of your choice. I advise this since Docker will use the folder name to create and name a docker network for the environment and also as a prefix for the containers that are created. Therefore having a meaningful name here helps.

6. Run the build script as root, once completed you should have a fully built CI environment

```ruby
./appdev_ci_build.bash
``` 

7. Now you need to configure the environment by following the instructions below

### Instructions to configure the environment

#### GitLab
1. Naviagte to http://{serverhostname}:9010 

2. You'll be asked to change your password. This is infact the password for the 'root' user which is the default administration account.

3. You can now login as 'root' and create groups and other users as you please. 

4. For more information about GitLab and how to use it please visit: <a href="https://about.gitlab.com/" target="_blank">GitLab</a>

#### Jenkins
1. Naviagte to http://{serverhostname}:9020

2. You will be asked to unlock Jenkins by entering the admin password. This can be found in the file below. Simply 'cat' this file and copy the contents into the Admistrator password field in the browser. 

```ruby
${DOCKER_VOLUMES}/secrets/initialAdminPassword
```

3. Jenkins will then ask you if you want to 'Install suggested plugins' - choose this option and let Jenkins download and install them

4. Once the plugins have been installed, you can create your first admin user

5. Jenkins is now ready to use, but you'll need to download and install more plugins as required for your projects

6. More information about how to setup and use Jenkins can be found at: <a href="https://jenkins.io/" target="_blank">Jenkins</a>

#### Nexus
1. Navigate to http://{serverhostname}:9030/nexus/#welcome

2. Login using the default username password of: admin / admin123. Now change the admin password.

3. Setup new users and repositories as you need

4. For more information about Nexus, please visit: <a href="https://support.sonatype.com/hc/en-us/categories/201980798" target="_blank">Nexus</a>

#### SonarQube
1. Navigate to http://{serverhostname}:9040

2. Login using the default username / password of: admin / admin. Now change the admin password.

3. You will be asked if you want to setup a token, but you can skip this tutorial

4. More information about SonarQube can be found at <a href="https://docs.sonarqube.org/display/SONAR/Documentation" target="_blank">SonarQube</a>

### Starting and stopping your environment

You can start and stop your CI environment by simply using the following commands:

```ruby
./start_stack.bash - to start the CI environment
```

```ruby
./stop_stack.bash - to stop the CI environment
```

### License

JHispterCIBuildEnvironment is released under the <a href="http://www.opensource.org/licenses/MIT" target="_blank">MIT License</a>.