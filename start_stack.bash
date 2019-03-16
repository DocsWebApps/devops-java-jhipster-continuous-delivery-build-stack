systemctl start docker
source ./set_env.bash
echo "Starting Jenkins..."
systemctl start jenkins.service
echo "Starting Docker components..."
docker-compose -f ./docker-compose.yml up -d
