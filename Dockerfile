FROM fedora:31
LABEL maintainer="https://twitter.com/carlesanagustin"
ENV BIN_PATH=/usr/local/bin

## update and install essential packages
RUN dnf upgrade -y && \
    dnf install -y vim curl git tmux telnet zip unzip bash-completion git zsh jq tree pwgen && \
    dnf install -y python3-pip

ENV TOOLS_VERSION=1.4

ENV OPENSHIFT_VERSION=v3.11.0-0cbc58b
ENV TERRAFORM_VERSION=0.12.20
# export KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
ENV KUBECTL_VERSION=v1.17.3
ENV AWSAUTH_VERSION=1.14.6
ENV DCOMPOSE_VERSION=1.25.4
ENV YQ_VERSION=3.1.2

ENV MACUSR=carles

# install ansible
#RUN dnf install -y ansible && \
#    dnf install -y python3-boto3 python3-botocore python3-boto python3-azure-sdk python3-libcloud
RUN pip install ansible && \
    pip install boto3 boto botocore azure apache-libcloud && \
    pip install ipdb ipython

## install openshift cli
RUN export OPENSHIFT_VERSION_NUMBER=$(echo $OPENSHIFT_VERSION | cut -d'-' -f1) && \
    curl -o /tmp/oc.tar.gz -sSL https://github.com/openshift/origin/releases/download/${OPENSHIFT_VERSION_NUMBER}/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit.tar.gz && \
    tar -zxvf /tmp/oc.tar.gz --directory /tmp/ && \
    mv /tmp/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit/oc $BIN_PATH && \
    rm -f /tmp/oc.tar.gz && \
    rm -Rf /tmp/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit

# install terraform
RUN curl -o ./terraform.zip -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip ./terraform.zip -d $BIN_PATH && \
    rm -f ./terraform.zip

# install aws tools
RUN dnf install -y awscli && \
    curl -o $BIN_PATH/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest && \
    chmod +x $BIN_PATH/ecs-cli && \
    curl -o $BIN_PATH/ec2.py https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py && \
    chmod +x $BIN_PATH/ec2.py && \
    curl -o $BIN_PATH/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${AWSAUTH_VERSION}/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x $BIN_PATH/aws-iam-authenticator

# install google cloud sdk
RUN echo -e '[google-cloud-sdk]\nname=Google Cloud SDK\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\n       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' > /etc/yum.repos.d/google-cloud-sdk.repo && \
    yum update -y && yum install -y google-cloud-sdk

## install powershell
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    curl -o /etc/yum.repos.d/microsoft.repo https://packages.microsoft.com/config/rhel/7/prod.repo && \
    dnf install -y compat-openssl10 powershell

# install azure cli tool
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo && \
    yum -y install azure-cli

# install kubernetes
RUN curl -o $BIN_PATH/kubectl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x $BIN_PATH/kubectl && \
    curl -o $BIN_PATH/kubectx -L https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && \
    chmod +x $BIN_PATH/kubectx && \
    curl -o $BIN_PATH/kubens -L https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && \
    chmod +x $BIN_PATH/kubens

# install docker-ce-cli
RUN dnf -y remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine && \
    dnf -y install dnf-plugins-core && \
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
    dnf -y install docker-ce-cli && \
    curl -o $BIN_PATH/docker-compose -L "https://github.com/docker/compose/releases/download/${DCOMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" && \
    chmod +x $BIN_PATH/docker-compose

ADD versions.sh $BIN_PATH/versions.sh
RUN chmod 755 $BIN_PATH/versions.sh

# install yq + ohmyzsh
RUN curl -o $BIN_PATH/yq -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#RUN useradd -m -s /usr/bin/zsh ${MACUSR}
#USER ${MACUSR}

RUN mkdir -p /Users && ln -s /root /Users/${MACUSR}
WORKDIR /root
#WORKDIR /Users/${MACUSR}

ENV PATH="${PATH}:${BIN_PATH}:${HOME}/.local/bin"
CMD [ "/usr/bin/bash", "-c", "/versions.sh" ]