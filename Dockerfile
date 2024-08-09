#FROM adoptopenjdk/openjdk11
#
#EXPOSE 8080
#
#ENV APP_HOME /usr/src/app
#
#COPY target/*.jar $APP_HOME/app.jar
#
#WORKDIR $APP_HOME
#
#CMD ["java", "-jar", "app.jar"]


# Stage 1: Build the application
FROM maven:3.8.5-openjdk-11-slim AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and download dependencies (use caching)
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Create a minimal runtime image
FROM adoptopenjdk/openjdk11:alpine-jre

# Set the environment variable for the app home
ENV APP_HOME=/usr/src/app

# Set the working directory
WORKDIR $APP_HOME

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
