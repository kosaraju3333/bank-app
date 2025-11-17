# Stage 1: Build stage
FROM maven:3.9.4-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml ./
COPY src ./src

# Build the application and create a fat jar (adjust this if using Spring Boot or plain Java)
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the jar from the build stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the port your app listens on
EXPOSE 5050

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]

