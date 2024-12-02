# Stage 1 - Build the JAR (Java Application Runtime) using Maven
FROM maven:3.8.3-openjdk-17 AS builder

WORKDIR /app

# Copy only the necessary files to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

# Create JAR file
RUN mvn clean install -DskipTests=true

# Stage 2 - Execute JAR File from the above stage
FROM openjdk:17-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar /app/expenseapp.jar

CMD ["java", "-jar", "expenseapp.jar"]
