FROM eclipse-temurin:17-jdk-alpine

ENV APP_HOME /usr/src/app

COPY target/*.jar $APP_HOME/app.jar

EXPOSE 8080

WORKDIR $APP_HOME

CMD ["java","-jar","app.jar"]

