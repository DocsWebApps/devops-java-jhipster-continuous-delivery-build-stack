systemctl start docker
source ${BASE_DIR}/set_env.bash
echo "Starting Jenkins..."
systemctl start jenkins.service
echo "Starting Docker components..."
docker-compose -f ${BASE_DIR}/docker-compose.yml up -d
