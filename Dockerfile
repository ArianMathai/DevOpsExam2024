FROM maven:3.8-eclipse-temurin-17 AS builder
WORKDIR /app
COPY java_sqs_client/pom.xml .
COPY java_sqs_client/src ./src
RUN mvn package -DskipTests

# Use a base image with Java 17
FROM eclipse-temurin:17-jre-jammy AS final
WORKDIR /app
COPY --from=builder /app/target/*.jar /app/application.jar
ENTRYPOINT ["java", "-jar", "/app/application.jar"]