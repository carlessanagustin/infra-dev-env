FROM centos:centos7
LABEL maintainer="https://twitter.com/carlesanagustin"

ARG KUBECTL_VERSION=v1.13.2
ARG KTOOLS_VERSION=1.2.0
ARG TERRAFORM_VERSION=0.11.11
ARG KOPS_VERSION=1.11.0
ARG OPENSHIFT_VERSION=v3.11.0-0cbc58b
ARG RACK_VERSION=1.2

# update and install essential packages
RUN yum update -y \
    && yum install epel-release -y \
    && yum install vim git tmux telnet nc zip unzip -y \
    && yum install python2-pip python36 python36-pip -y

# install libcloud
RUN pip install apache-libcloud

# install ansible
RUN yum install ansible -y \
    && pip install pywinrm

# install ansible tower cli tool
RUN pip install ansible-tower-cli

# install openshift cli
RUN export OPENSHIFT_VERSION_NUMBER=$(echo $OPENSHIFT_VERSION | cut -d'-' -f1) \
    && curl -sSL https://github.com/openshift/origin/releases/download/${OPENSHIFT_VERSION_NUMBER}/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit.tar.gz -o /tmp/oc.tar.gz \
    && tar -zxvf /tmp/oc.tar.gz --directory /tmp/ \
    && cd /tmp/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit \
    && mv oc /usr/sbin/

# install terraform
RUN curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o ./terraform.zip \
    && unzip ./terraform.zip -d /usr/local/bin/ \
    && rm -f ./terraform.zip

# install kubectl
RUN curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# install kops
RUN curl -sSL https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 -o /usr/local/bin/kops \
    && chmod +x /usr/local/bin/kops

# install awscli tool
RUN pip install awscli

# install rack cli
RUN curl -sSL https://ec4a542dbf90c03b9f75-b342aba65414ad802720b41e8159cf45.ssl.cf5.rackcdn.com/$RACK_VERSION/Linux/amd64/rack  -o /usr/local/bin/rack \
    && chmod a+x /usr/local/bin/rack

# install gcloud cli tool
RUN echo -e "[google-cloud-sdk]\nname=Google Cloud SDK\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\n       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg\n" > /etc/yum.repos.d/google-cloud-sdk.repo \
    && yum install google-cloud-sdk -y

# install azure cli tool
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo \
    && yum install azure-cli -y

# install kubernetes tools
RUN curl -sSL https://codeload.github.com/shawnxlw/kubernetes-tools/zip/v${KTOOLS_VERSION} -o ktools.zip \
    && unzip ktools.zip && mv kubernetes-tools-${KTOOLS_VERSION}/bin/* /usr/local/bin/ && mv kubernetes-tools-${KTOOLS_VERSION}/completion/__completion /usr/local/bin/__completion && rm -rf kubernetes-tools*

ADD versions.sh /versions.sh
RUN chmod 755 /versions.sh \
    && export PATH=$PATH:/usr/local/bin

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "/versions.sh" ]
