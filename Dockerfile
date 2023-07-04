FROM gradle:7.6.1-jdk17-alpine as build

ENV APP_HOME=/apps

WORKDIR $APP_HOME

COPY build.gradle settings.gradle gradlew $APP_HOME/
RUN gradle build --parallel --continue > /dev/null 2>&1 || true

COPY gradle $APP_HOME/gradle

RUN chmod +x gradlew

# RUN ./gradlew build || return 0

COPY src $APP_HOME/src

RUN ./gradlew clean build

FROM openjdk:17-jdk-slim

ENV APP_HOME=/apps
ARG ARTIFACT_NAME=app.jar
ARG JAR_FILE_PATH=build/libs/ZeroZoneRefactoring-1.0.jar

WORKDIR $APP_HOME

# build 이미지에서 build/libs/ZeroZoneRefactoring-1.0.jar을 app.jar로 복사
COPY --from=build $APP_HOME/$JAR_FILE_PATH $ARTIFACT_NAME

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]