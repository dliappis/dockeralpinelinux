FROM alpine:latest
ENV GRADLE_VERSION 2.13
ENV GRADLE_HOME /usr/local/gradle
ENV PATH ${PATH}:${GRADLE_HOME}/bin
ARG USER_ID=1000
ARG GROUP_ID=1000

# Update image and install base packages
RUN apk update && \
    apk upgrade && \
    apk add bash git libstdc++ openjdk8 openssl && \
    rm -rf /var/cache/apk/*

# Install gradle
WORKDIR /usr/local
RUN wget  https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    unzip gradle-$GRADLE_VERSION-bin.zip && \
    rm -f gradle-$GRADLE_VERSION-bin.zip && \
    ln -s gradle-$GRADLE_VERSION gradle && \
    echo -ne "- with Gradle $GRADLE_VERSION\n" >> /root/.built

# Install elasticsearch user
RUN adduser -D -u ${USER_ID} -h /elasticsearch elasticsearch
USER ${USER_ID}
WORKDIR /elasticsearch
