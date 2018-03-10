source ./set_env.bash
systemctl start jenkins.service
docker-compose -f ./docker-compose.yml up -d
