FROM alpine:3
RUN wget https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_amd64.zip
RUN unzip terraform_1.2.9_linux_amd64.zip
RUN mv terraform /bin/
RUN rm -rf terraform_1.2.9_linux_amd64.zip
RUN wget https://dl.k8s.io/release/v1.24.3/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /bin/
RUN apk add git
