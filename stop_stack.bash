source ./set_env.bash
systemctl stop jenkins.service
docker-compose -f ./docker-compose.yml down
