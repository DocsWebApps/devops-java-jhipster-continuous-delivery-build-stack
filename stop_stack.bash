source ./set_env.bash
echo "Stopping Jenkins...."
systemctl stop jenkins.service
echo "Stopping Docker components...."
docker-compose -f ./docker-compose.yml down
