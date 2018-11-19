FROM jenkins/slave:3.23-1-alpine
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="3.23" Maintainer="Richard Felkl <richard.felkl@gmail.com>"

USER root

ENV GOPATH "/home/jenkins/go"
ENV GOBIN "/home/jenkins/go/bin"
ENV GLIDE_HOME "/home/glide"

ADD https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN mkdir -p /home/jenkins/go/src && \
    mkdir -p /home/jenkins/go/bin && \
    mkdir -p /home/glide/ && \
    touch /home/glide/mirrors.yaml

RUN apk update && \
    apk add docker alpine-sdk gettext && \
    chmod +x /usr/local/bin/kubectl

RUN sed -i -e 's/v[3.8]\.[3.8]/edge/g' /etc/apk/repositories

RUN apk update && \
    apk add go glide dep

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]