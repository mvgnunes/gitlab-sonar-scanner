FROM openjdk:8-jdk-alpine

# Install gradle and sonar-scanner
RUN mkdir /usr/lib/gradle /app

ENV GRADLE_VERSION 2.9
ENV GRADLE_HOME /usr/lib/gradle/gradle-${GRADLE_VERSION}
ENV PATH ${PATH}:${GRADLE_HOME}/bin
ENV SONAR_SCANNER_VERSION 3.0.3.778

WORKDIR /usr/lib/gradle
RUN set -x \
  && apk add --no-cache wget nodejs \
  && wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
  && unzip gradle-${GRADLE_VERSION}-bin.zip \
  && rm gradle-${GRADLE_VERSION}-bin.zip \ 
  && cd / \
  && wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
  && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION} \
  && cd /usr/bin && ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner sonar-scanner \
  && apk del wget \
  && ln -s /usr/bin/sonar-scanner-run.sh /bin/gitlab-sonar-scanner

RUN apk update && apk add bash libstdc++

COPY sonar-scanner-run.sh /usr/bin
