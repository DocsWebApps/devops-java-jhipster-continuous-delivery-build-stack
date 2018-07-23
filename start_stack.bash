source ${HOME}/DocsAppStack/set_env.bash
echo "Starting Jenkins..."
systemctl start jenkins.service
echo "Starting Docker components..."
docker-compose -f ${HOME}/DocsAppStack/docker-compose.yml up -d
