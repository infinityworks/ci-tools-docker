FROM registry.ipttools.io/dtp/jenkins-docker

MAINTAINER Ayache Khettar "ayache.khettar@infinityworks.com"	

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_UC https://updates.jenkins-ci.org

USER root
# copy additional plugins
COPY plugins.sh /usr/local/bin/plugins.sh
COPY plugins.txt ${JENKINS_HOME}/additionalPlugins.txt

RUN /usr/local/bin/plugins.sh ${JENKINS_HOME}/additionalPlugins.txt

USER jenkins




