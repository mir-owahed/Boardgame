# Stage 1: Build stage using Maven
FROM maven:3.8.3-openjdk-17-slim AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

# Copy rest of the app source
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Stage 2: Runtime stage using Alpine and non-root user
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Change ownership and switch to non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# Expose app port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
