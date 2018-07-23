source ${HOME}/DocsAppStack/set_env.bash
echo "Stopping Jenkins...."
systemctl stop jenkins.service
echo "Stopping Docker components...."
docker-compose -f ${HOME}/DocsAppStack/docker-compose.yml down
