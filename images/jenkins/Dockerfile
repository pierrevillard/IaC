FROM jenkins/jenkins:2.332.3-lts-jdk11
LABEL maintainer=ILKILABS
USER root
RUN apt update && apt install -yqq wget tar
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz
RUN tar -xvf docker-20.10.9.tgz
RUN mv /docker/docker /bin/docker
RUN chmod +x /bin/docker
RUN rm -rf /docker
#RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.22.0/bin/linux/amd64/kubectl
#RUN chmod +x kubectl
#RUN mv kubectl /bin/kubectl
