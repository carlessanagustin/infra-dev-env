FROM fedora:31
LABEL maintainer="https://twitter.com/carlesanagustin"

## update and install essential packages
RUN dnf upgrade -y && \
    dnf install -y vim curl git tmux telnet zip unzip bash-completion git zsh jq && \
    dnf install -y python3-ipython python3-ipdb python3-pip && \
    dnf -y install dnf-plugins-core

# export KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
ENV TOOLS_VERSION=1.4
ENV OPENSHIFT_VERSION=v3.11.0-0cbc58b
ENV TERRAFORM_VERSION=0.12.20
ENV KUBECTL_VERSION=v1.17.3
ENV AWSAUTH_VERSION=1.14.6

ENV MACUSR=carles

## install openshift cli
RUN export OPENSHIFT_VERSION_NUMBER=$(echo $OPENSHIFT_VERSION | cut -d'-' -f1) && \
    curl -sSL https://github.com/openshift/origin/releases/download/${OPENSHIFT_VERSION_NUMBER}/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit.tar.gz -o /tmp/oc.tar.gz && \
    tar -zxvf /tmp/oc.tar.gz --directory /tmp/ && \
    cd /tmp/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit && \
    mv oc /usr/sbin/

# install terraform
RUN curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o ./terraform.zip && \
    unzip ./terraform.zip -d /usr/local/bin/ && \
    rm -f ./terraform.zip

# install kubectl
RUN curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    dnf -y copr enable cerenit/kubectx && \
    dnf -y install kubectx

# install ansible
RUN dnf install -y ansible && \
    dnf install -y python3-boto3 python3-botocore python3-boto python3-azure-sdk python3-libcloud

# install aws tools
RUN dnf install -y awscli && \
    curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest && \
    chmod +x /usr/local/bin/ecs-cli && \
    curl -o /usr/local/bin/ec2.py https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py && \
    chmod +x /usr/local/bin/ec2.py && \
    curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${AWSAUTH_VERSION}/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x /usr/local/bin/aws-iam-authenticator

# install google cloud sdk
RUN echo -e '[google-cloud-sdk]\nname=Google Cloud SDK\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\n       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' > /etc/yum.repos.d/google-cloud-sdk.repo && \
    yum update -y && yum install -y google-cloud-sdk

## install powershell
#RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
#    curl -o /etc/yum.repos.d/microsoft.repo https://packages.microsoft.com/config/rhel/7/prod.repo && \
#    dnf install -y compat-openssl10 powershell

# install azure cli tool
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo && \
    yum -y install azure-cli

# install docker-ce-cli
RUN dnf -y remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine && \
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
    dnf -y install docker-ce-cli

ADD versions.sh /versions.sh
RUN chmod 755 /versions.sh && export PATH=$PATH:/usr/local/bin

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN useradd -m -s /usr/bin/zsh ${MACUSR}
RUN mkdir -p /Users && ln -s /root /Users/${MACUSR}
WORKDIR /root
#WORKDIR /Users/${MACUSR}
#USER ${MACUSR}

CMD [ "/usr/bin/bash", "-c", "/versions.sh" ]
