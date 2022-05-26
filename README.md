Get the stack: "git clone https://github.com/pierreilki/IaC.git"

cd IaC


Can be launched with : "GITLAB_EXTERNAL_URL=http://IP_DOCKER_HOST docker-compose up -d"



Can be totally destroyed with:  "docker-compose down -v --rmi all --remove-orphans"


Get InitialJenkins Password: cat /var/lib/docker/volumes/iac_jenkins_data/_data/secrets/initialAdminPassword


