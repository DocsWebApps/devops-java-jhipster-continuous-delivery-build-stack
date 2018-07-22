source /root/DocsAppStack/set_env.bash
echo "Stopping Jenkins...."
systemctl stop jenkins.service
docker-compose -f /root/DocsAppStack/docker-compose.yml down
