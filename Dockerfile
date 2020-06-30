# image name
FROM centos:7
# some basic softwares
RUN yum install sudo -y
RUN yum install net-tools -y
RUN yum install wget -y
RUN yum install git -y
RUN yum install vim -y 
RUN yum install python3 -y
RUN yum install /sbin/service -y 
CMD sudo service jenkins start -DFOREGROUND && /bin/bash
Expose 8080



# setup jenkins repository
RUN wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
RUN rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
# installing jenkins + java is required
RUN yum install jenkins -y
RUN yum install java-11-openjdk.x86_64  -y
# append in the sudoers file so that jenkins can get sudo powers
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# some softwares to run docker from inside
RUN yum install ca-certificates -y
RUN yum install curl -y
RUN yum install gnupg2 -y
RUN yum install dnf -y
# setup repository for docker
RUN dnf install 'dnf-command(config-manager)' -y
RUN dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo -y
# install docker 
RUN yum install docker-ce -y
RUN sudo usermod -a -G docker jenkins


RUN touch /etc/yum.repos.d/kubernetes.repo
RUN echo $'[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64\n\
enabled=1\n\
gpgcheck=1\n\
repo_gpgcheck=1\n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' >> /etc/yum.repos.d/kubernetes.repo


RUN yum install -y kubectl



# this is the most important command
CMD chmod 777 /var/run/docker.sock && java -jar /usr/lib/jenkins/jenkins.war
CMD sudo service jenkins start -DFOREGROUND && /bin/bash
EXPOSE 8080
